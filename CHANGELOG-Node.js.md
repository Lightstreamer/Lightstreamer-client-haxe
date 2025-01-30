# Lightstreamer Node.js Client Changelog

## [unreleased]

Changed HTTP `Content-Type` header to use `text/plain` instead of `application/x-www-form-urlencoded`.


## 9.2.1
*Compatible with Lightstreamer Server since 7.4.0*<br/>
*Compatible with code developed using the previous version.*<br/>
*Made available on 29 Oct 2024*

Fix the `README.md` in the package page on the npm repository.


## 9.2.0
*Compatible with Lightstreamer Server since 7.4.0*<br/>
*May not be compatible with code developed using the previous version.*<br/>
*Made available on 29 Oct 2024*

Changed the behavior of the listener `ClientListener.onPropertyChange` to be called whenever the value of a property is changed by the server or by the user through a property setter.


## 9.1.0
*Compatible with Lightstreamer Server since 7.4.0*<br/>
*Compatible with code developed using the previous version.*<br/>
*Made available on 19 Dec 2023*

Improved the client's performance to handle more server updates per second.


## 9.0.0
*Compatible with Lightstreamer Server since 7.4.0*<br/>
*Not compatible with code developed using the previous version.*<br/>
*Made available on 10 Jul 2023* 

Added a second argument to the listener `ClientMessageListener.onProcessed` carrying the response, from the Metadata Adapter of a Lightstreamer Server, to a message sent by the Client through the method `LightstreamerClient.sendMessage`.

Added this check: when a `Subscription` is configured by means of an ItemList or a FieldList, the client checks that the number of items and fields returned by the server coincides with the number of elements in the ItemList and the FieldList, and if the numbers are different, the client deletes the subscription and fires the listener `SubscriptionListener.onSubscriptionError` with the error code 61.

Changed the behavior of the method `ItemUpdate.forEachChangedField` when `ItemUpdate` refers to the first server update (possibly the snapshot): the iterator function passed to the method is invoked on every field, while previously it was invoked only on non-null fields. 


## 9.0.0-beta.3
*Compatible with Lightstreamer Server since 7.3.2*<br/>
*Not compatible with code developed using the previous version.*<br/>
*Made available on 22 Jun 2023* 

Fixed the validation check of the setter `setItems` of the class `Subscription` in order to accept item names that start with a digit but contain non-digit characters too.

Updated the library haxe-concurrent to version 5.1.3.


## 9.0.0-beta.2
*Compatible with Lightstreamer Server since 7.3.2*<br/>
*Not compatible with code developed using the previous version.*<br/>
*Made available on 5 Apr 2023* 

Rewritten the function to decode the percent encoded messages sent by the Server so that it has the same behavior on all the targets.

Suppressed the unsolicited console outputs produced by the library.


## 9.0.0-beta.1
*Compatible with Lightstreamer Server since 7.3.2*<br/>
*Not compatible with code developed using the previous version.*<br/>
*Made available on 14 Mar 2023* 

Rewritten the whole Client SDK in the cross-platform programming language Haxe, which allows to share the core features with the other Client SDKs and at the same time to add functionalities specific to this platform.<br>
The old library is still available [here](https://github.com/Lightstreamer/Lightstreamer-lib-client-javascript).

Improved the "delta delivery" mechanism, by adding the support for value differences, as per the extension introduced in Server version 7.3.0.
Currently two "diff" formats are supported: JSON Patch and TLCP-diff.

Added the getValueAsJSONPatchIfAvailable function in the ItemUpdate class, to take advantage of the new support for JSON Patch differences, which may prove useful in some use cases.
See the Docs for details.

Added the new error code 70 to the interface method `ClientListener.onServerError`, to report that an unusable port was configured on the server address.
Previously a similar case was treated as a request syntax error.

Removed the following restriction on the method `ConnectionOptions.setHttpExtraHeaders`: the Websocket transport is no more disabled when any extra headers are set.

The logging facilities have been revised in order to expose the same API on all supported platforms.<br/>
They consist of:

- the Logger and LoggerProvider interfaces
- the off-the-shelf ConsoleLoggerProvider class, which prints messages to the console when passed to the method `LightstreamerClient.setLoggerProvider(LoggerProvider)`.

The logging methods `fatal(String)`, `error(String)`, `warn(String)`, `info(String)` and `debug(String)` have been removed from the Logger interface.

Added the following restriction to the method `LightstreamerClient.addCookies`: the URI argument must not be null.

The following properties have been changed:

- `Subscription.getItems`
- `Subscription.getItemGroup`
- `Subscription.getFields`
- `Subscription.getFieldSchema`
- `Subscription.getCommandSecondLevelFields`
- `Subscription.getCommandSecondLevelFieldSchema`

Now they return null when the values are not available. 
Previously they threw an IllegalStateException.

The following obsolete methods have been removed:

- `ConnectionOptions.getConnectTimeout`
- `ConnectionOptions.setConnectTimeout`
- `ConnectionOptions.getCurrentConnectTimeout`
- `ConnectionOptions.setCurrentConnectTimeout`
- `ConnectionOptions.isEarlyWSOpenEnabled`
- `ConnectionOptions.setEarlyWSOpenEnabled`

The signatures of the following methods have been changed:

- `ClientListener.onListenStart` and `ClientListener.onListendEnd`: removed the parameter of type LightstreamerClient
- `SubscriptionListener.onListenStart` and `SubscriptionListener.onListendEnd`: removed the parameter of type Subscription


# Previous Versions

See the full [changelog](https://github.com/Lightstreamer/Lightstreamer-lib-client-javascript/blob/master/CHANGELOG_Nodejs.md).