package com.lightstreamer.hxpoco;

import com.lightstreamer.cpp.CppString;
import cpp.Reference;
import cpp.ConstCharStar;
import poco.net.ProxyConfig;
import com.lightstreamer.cpp.CppStringMap;

@:structAccess
@:include("Lightstreamer/HxPoco/WsClient.h")
@:native("Lightstreamer::HxPoco::WsClient")
extern class WsClientCpp {
  // public
  function new(host: ConstCharStar, subProtocol: ConstCharStar, headers: CppStringMap, proxy: Reference<ProxyConfig>);
  function connect(): Void;
  function send(txt: Reference<CppString>): Void;
  function dispose(): Void;
  // protected
  function gc_enter_blocking(): Void;
  function gc_exit_blocking(): Void;
  function submit(): Void;
  function doSubmit(): Void;
  function onOpen(): Void;
  function onText(line: ConstCharStar): Void;
  function onError(msg: ConstCharStar): Void;
}