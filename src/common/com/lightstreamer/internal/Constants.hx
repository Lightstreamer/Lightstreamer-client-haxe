package com.lightstreamer.internal;

final TLCP_VERSION = "TLCP-2.3.0";
final FULL_TLCP_VERSION = TLCP_VERSION + ".lightstreamer.com";

#if LS_TEST
final LS_LIB_NAME = "generic_client";
final LS_LIB_VERSION = "0.0 build 0";
final LS_CID = "mgQkwtwdysogQz2BJ4Ji kOj2Bg";
#elseif LS_WEB
final LS_LIB_NAME = "javascript_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "pcYgxn8m8 feOojyA1V661f3g2.pz482h85HM8j";
#elseif LS_NODE
final LS_LIB_NAME = "nodejs_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "tqGko0tg4pkpW3EAK3M4hwLri8M4O968hAx";
#elseif android
final LS_LIB_NAME = "android_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "gpGxttxdysogQz2KJ4L73dXoqoH6M982l89r";
#elseif java
final LS_LIB_NAME = "javase_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "pcYgxptg4pkpW3EAK3M4hwLri8M4O968hAo";
#elseif cs
final LS_LIB_NAME = "dotnet_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "jqWtj1tg4pkpW3EAK3M4hwLri8M4O968hAj";
#elseif python
final LS_LIB_NAME = "python_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "v Wntytg4pkpW3EAK3M4hwLri8M4O968hAe";
#elseif php
final LS_LIB_NAME = "php_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "vjSfhw.i6 3Be64BHfDprfc85DM4S9Ai";
#elseif cpp
final LS_LIB_NAME = "cpp_client";
final LS_LIB_VERSION = "9.0.0 build 20220624";
final LS_CID = "irSfhw.i6 3Be64BHfDprfc85DM4S9Ad";
#end