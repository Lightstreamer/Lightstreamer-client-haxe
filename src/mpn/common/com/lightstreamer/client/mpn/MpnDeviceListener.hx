package com.lightstreamer.client.mpn;

interface MpnDeviceListener {
  public function onListenStart(device: MpnDevice): Void;
  public function onListenEnd(device: MpnDevice): Void;
  public function onRegistered(): Void;
  public function onSuspended(): Void;
  public function onResumed(): Void;
  public function onStatusChanged(status: String, timestamp: haxe.Int64): Void;
  public function onRegistrationFailed(code: Int, message: String): Void;
  public function onSubscriptionsUpdated(): Void;
}