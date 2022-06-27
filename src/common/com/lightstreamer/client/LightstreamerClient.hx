package com.lightstreamer.client;

import com.lightstreamer.client.internal.ClientMachine;
import com.lightstreamer.internal.NativeTypes;
import com.lightstreamer.internal.EventDispatcher;
import com.lightstreamer.internal.PlatformApi;
import com.lightstreamer.internal.Types;
import com.lightstreamer.log.LoggerTools;
import com.lightstreamer.internal.Constants;

using com.lightstreamer.log.LoggerTools;

class ClientEventDispatcher extends EventDispatcher<ClientListener> {}

/**
 * LightstreamerClient class
 **/
#if (js || python) @:expose @:native("LightstreamerClient") #end
#if (java || cs || python) @:nativeGen #end
@:build(com.lightstreamer.internal.Macros.synchronizeClass())
class LightstreamerClient {
  public static final LIB_NAME: String = LS_LIB_NAME;
  public static final LIB_VERSION: String = LS_LIB_VERSION;

  public final connectionDetails: ConnectionDetails;
  public final connectionOptions: ConnectionOptions;
  final eventDispatcher = new ClientEventDispatcher();
  final machine: ClientMachine;

  public static function setLoggerProvider(provider: com.lightstreamer.log.LoggerProvider): Void {
    com.lightstreamer.log.LogManager.setLoggerProvider(provider);
  }

  #if LS_HAS_COOKIES
  public static function addCookies(uri: NativeURI, cookies: NativeCookieCollection): Void {
    com.lightstreamer.internal.CookieHelper.instance.addCookies(uri, cookies);
  }

  public static function getCookies(uri: Null<NativeURI>): NativeCookieCollection {
    #if cs @:nullSafety(Off) #end
    return com.lightstreamer.internal.CookieHelper.instance.getCookies(uri);
  }
  #end

  #if LS_HAS_TRUST_MANAGER
  public static function setTrustManagerFactory(factory: NativeTrustManager) {
    com.lightstreamer.internal.Globals.instance.setTrustManagerFactory(factory);
  }
  #end

  /**
   * LightstreamerClient ctor
   * @param serverAddress 
   * @param adapterSet 
   */
  public function new(serverAddress: String, adapterSet: String 
  #if LS_TEST , ?wsFactory: IWsClientFactory, ?httpFactory: IHttpClientFactory, ?ctrlFactory: IHttpClientFactory, ?timerFactory: ITimerFactory, ?randomGen: Millis->Millis, ?reachabilityFactory: IReachabilityFactory #end
  ) {
    connectionDetails = new ConnectionDetails(@:nullSafety(Off) this);
    connectionOptions = new ConnectionOptions(@:nullSafety(Off) this);
    #if LS_TEST
    machine = new ClientMachine(this, wsFactory ?? createWsClient, httpFactory ?? createHttpClient, ctrlFactory ?? createHttpClient, timerFactory ?? createTimer, randomGen ?? randomMillis, reachabilityFactory ?? createReachabilityManager);
    #else
    machine = new ClientMachine(this, createWsClient, createHttpClient, createHttpClient, createTimer, randomMillis, createReachabilityManager);
    #end
    if (serverAddress != null) {
      connectionDetails.setServerAddress(serverAddress);
    }
    if (adapterSet != null) {
      connectionDetails.setAdapterSet(adapterSet);
    }
  }

  public function addListener(listener: ClientListener): Void {
    eventDispatcher.addListenerAndFireOnListenStart(listener, this);
  }

  public function removeListener(listener: ClientListener): Void {
    eventDispatcher.removeListenerAndFireOnListenEnd(listener, this);
  }

  public function getListeners(): NativeList<ClientListener> {
    return new NativeList(eventDispatcher.getListeners());
  }

  /**
   * connect
   */
  public function connect(): Void {
    machine.connect();
  }

  public function disconnect(): Void {
    machine.disconnect();
  }

  public function getStatus(): String {
    return machine.getStatus();
  }

  #if (java || cs)
  overload public function sendMessage(message: String) {
    machine.sendMessage(message, null, -1, null, false);
  }

  overload public function sendMessage(message: String, sequence: Null<String>, delayTimeout: Int, listener: Null<ClientMessageListener>, enqueueWhileDisconnected: Bool): Void {
    machine.sendMessage(message, sequence, delayTimeout, listener, enqueueWhileDisconnected);
  }
  #else
  public function sendMessage(message: String, sequence: Null<String> = null, delayTimeout: Null<Int> = -1, listener: Null<ClientMessageListener> = null, enqueueWhileDisconnected: Null<Bool> = false): Void {
    machine.sendMessage(message, sequence, delayTimeout != null ? delayTimeout : -1, listener, enqueueWhileDisconnected != null ? enqueueWhileDisconnected : false);
  }
  #end

  public function subscribe(subscription: Subscription): Void {
    machine.subscribeExt(subscription);
  }

  public function unsubscribe(subscription: Subscription) {
    machine.unsubscribe(subscription);
  }

  public function getSubscriptions(): NativeList<Subscription> {
    return new NativeList(machine.getSubscriptions());
  }

  #if LS_MPN
  public function registerForMpn(mpnDevice: com.lightstreamer.client.mpn.MpnDevice) {
    var machine = cast(machine, com.lightstreamer.client.internal.MpnClientMachine);
    machine.registerForMpn(mpnDevice);
  }

  public function subscribeMpn(mpnSubscription: com.lightstreamer.client.mpn.MpnSubscription, coalescing: Bool) {
    var machine = cast(machine, com.lightstreamer.client.internal.MpnClientMachine);
    machine.subscribeMpn(mpnSubscription, coalescing);
  }

  public function unsubscribeMpn(mpnSubscription: com.lightstreamer.client.mpn.MpnSubscription) {
    var machine = cast(machine, com.lightstreamer.client.internal.MpnClientMachine);
    machine.unsubscribeMpn(mpnSubscription);
  }

  public function unsubscribeMpnSubscriptions(filter: Null<String>) {
    var machine = cast(machine, com.lightstreamer.client.internal.MpnClientMachine);
    machine.unsubscribeMpnSubscriptions(filter);
  }

  public function getMpnSubscriptions(filter: Null<String>): NativeList<com.lightstreamer.client.mpn.MpnSubscription> {
    var machine = cast(machine, com.lightstreamer.client.internal.MpnClientMachine);
    return new NativeList(machine.getMpnSubscriptions(filter));
  }

  public function findMpnSubscription(subscriptionId: String): Null<com.lightstreamer.client.mpn.MpnSubscription> {
    var machine = cast(machine, com.lightstreamer.client.internal.MpnClientMachine);
    machine.findMpnSubscription(subscriptionId);
  }
  #end

  function createWsClient(url: String, headers: Null<Map<String, String>>, 
    onOpen: IWsClient->Void,
    onText: (IWsClient, String)->Void, 
    onError: (IWsClient, String)->Void): IWsClient {
    #if java
    var proxy = connectionOptions.getProxy();
    var trustManager = com.lightstreamer.internal.Globals.instance.getTrustManagerFactory();
    return new com.lightstreamer.internal.WsClient(url, headers, proxy, trustManager, onOpen, onText, onError);
    #elseif cs
    var proxy = connectionOptions.getProxy();
    var trustManager = com.lightstreamer.internal.Globals.instance.getTrustManagerFactory();
    return new com.lightstreamer.internal.WsClient(url, headers, proxy, trustManager, onOpen, onText, onError);
    #elseif (js && LS_WEB)
    return new com.lightstreamer.internal.WsClient(url, onOpen, onText, onError);
    #elseif js
    return new com.lightstreamer.internal.WsClient(url, headers, onOpen, onText, onError);
    #elseif python
    var proxy = connectionOptions.getProxy();
    var trustManager = com.lightstreamer.internal.Globals.instance.getTrustManagerFactory();
    return new com.lightstreamer.internal.WsClient(url, headers, proxy, trustManager, onOpen, onText, onError);
    #else
    @:nullSafety(Off)
    return null;
    #end
  }
  
  function createHttpClient(url: String, body: String, headers: Null<Map<String, String>>,
    onText: (IHttpClient, String)->Void, 
    onError: (IHttpClient, String)->Void, 
    onDone: IHttpClient->Void): IHttpClient {
    #if java
    var proxy = connectionOptions.getProxy();
    var trustManager = com.lightstreamer.internal.Globals.instance.getTrustManagerFactory();
    return new com.lightstreamer.internal.HttpClient(url, body, headers, proxy, trustManager, onText, onError, onDone);
    #elseif cs
    return new com.lightstreamer.internal.HttpClient(url, body, headers, onText, onError, onDone);
    #elseif js
    return new com.lightstreamer.internal.HttpClient(url, body, headers, onText, onError, onDone);
    #elseif python
    var proxy = connectionOptions.getProxy();
    var trustManager = com.lightstreamer.internal.Globals.instance.getTrustManagerFactory();
    return new com.lightstreamer.internal.HttpClient(url, body, headers, proxy, trustManager, onText, onError, onDone);
    #else
    @:nullSafety(Off)
    return null;
    #end
  }
  
  function createReachabilityManager(host: String): IReachability {
    return new com.lightstreamer.internal.DummyReachabilityManager();
  }
  
  function createTimer(id: String, delay: Millis, callback: ITimer->Void): ITimer {
    return new com.lightstreamer.internal.Timer(id, delay, callback);
  }
  
  function randomMillis(max: Millis): Millis {
    return new Millis(Std.random(max.toInt()));
  }
}