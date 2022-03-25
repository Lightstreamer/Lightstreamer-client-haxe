package com.lightstreamer.internal;

import haxe.macro.Expr;
using haxe.macro.Tools;

macro function assert(e: Expr) {
  var expr = e.toString();
  var pos = e.pos;
  return macro if (!$e) @:pos(pos) throw new haxe.Exception("Assertion failure: " + $v{expr});
}