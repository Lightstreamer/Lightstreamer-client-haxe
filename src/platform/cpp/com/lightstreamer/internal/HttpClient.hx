package com.lightstreamer.internal;

import cpp.Star;
import cpp.Reference;
import cpp.ConstCharStar;
import sys.thread.Thread;
import poco.net.ProxyConfig;
import com.lightstreamer.cpp.CppStringMap;
import com.lightstreamer.hxpoco.HttpClientCpp;
import com.lightstreamer.client.Proxy.LSProxy as Proxy;
import com.lightstreamer.internal.PlatformApi.IHttpClient;
import com.lightstreamer.log.LoggerTools;

using com.lightstreamer.log.LoggerTools;

@:unreflective
class HttpClient implements IHttpClient {
  final _onText: (HttpClient, String)->Void;
  final _onError: (HttpClient, String)->Void;
  final _onDone: HttpClient->Void;
  var _client: Null<Star<HttpClientAdapter>>;

  public function new(url: String, body: String, 
    headers: Null<Map<String, String>>,
    proxy: Null<Proxy>,
    _onText: (HttpClient, String)->Void, 
    _onError: (HttpClient, String)->Void, 
    _onDone: HttpClient->Void) 
  {
    // TODO print trust manager
    streamLogger.logDebug('HTTP sending: $url $body headers($headers) proxy($proxy)');
    this._onText = _onText;
    this._onError = _onError;
    this._onDone = _onDone;
    // headers
    var hs = new CppStringMap();
    if (headers != null) {
      for (k => v in headers) {
        hs.add(k, v);
      }
    }
    // proxy
    var pc = new ProxyConfig();
    if (proxy != null) {
      pc.setHost(proxy.host);
      pc.setPort(proxy.port);
      if (proxy.user != null) {
        pc.setUsername(proxy.user);
      }
      if (proxy.password != null){
        pc.setPassword(proxy.password);
      }
    }
    // connect
    this._client = new HttpClientAdapter(url, body, hs, pc, s -> onText(s), s -> onError(s), () -> onDone());
    _client.start();
  }

  /**
   * NB `dispose` method is not reentrant.
   * Make sure to call it from a different thread than the one calling the `onText`, `onError`, and `onDone` callbacks.
   */
  public function dispose() {
    streamLogger.logDebug("HTTP disposing");
    if (_client != null) {
      _client.dispose();
      // manually release the memory acquired by the native objects
      untyped __cpp__("delete {0}", _client);
      _client = null;
    }
  }

  public function isDisposed(): Bool {
    return _client != null ? _client.isDisposed() : true;
  }

  function onText(line: String): Void {
    if (isDisposed()) {
      return;
    }
    streamLogger.logDebug('HTTP event: text($line)');
    this._onText(this, line);
  }

  function onError(error: String): Void {
    if (isDisposed()) {
      return;
    }
    streamLogger.logDebug('HTTP event: error($error)');
    this._onError(this, error);
  }

  function onDone(): Void {
    if (isDisposed()) {
      return;
    }
    streamLogger.logDebug("HTTP event: complete");
    this._onDone(this);
  }
}

@:nativeGen
@:structAccess
class HttpClientAdapter extends HttpClientCpp {
  final _onText: String->Void;
  final _onError: String->Void;
  final _onDone: ()->Void;

  public function new(url: String, body: String, 
    headers: CppStringMap,
    proxy: Reference<ProxyConfig>,
    onText: String->Void, 
    onError: String->Void, 
    onDone: ()->Void) 
  {
    super(url, body, headers, proxy);
    this._onText = onText;
    this._onError = onError;
    this._onDone = onDone;
  }

  override function submit() {
    var that: Star<HttpClientAdapter> = untyped __cpp__("this");
    // TODO use a thread pool?
    @:nullSafety(Off)
    Thread.create(() -> that.doSubmit());
  }

  override public function onText(line: ConstCharStar): Void {
    this._onText(line);
  }

  override public function onError(error: ConstCharStar): Void {
    this._onError(error);
  }

  override public function onDone(): Void {
    this._onDone();
  }
}