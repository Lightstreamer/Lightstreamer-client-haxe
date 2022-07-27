import utest.Runner;
import com.lightstreamer.log.ConsoleLoggerProvider;
import com.lightstreamer.client.Proxy;
import com.lightstreamer.client.LightstreamerClient;
import com.lightstreamer.internal.*;

@:timeout(1500)
class TestProxyCs extends  utest.Test {
  static var proxy = new Proxy("HTTP", "localtest.me", 8079, "myuser", "mypassword");
  // use an alias of localhost to fool the network layer and force it to pass through the proxy
  // see https://stackoverflow.com/a/7103016
  var host = "localtest.me:8080";
  var output: Array<String>;

  public static function main() {
    setupClass();
    var runner = new Runner();
    runner.addCase(TestProxyCs);
    runner.run();
    runner.await();
  }

  static function setupClass() {
    // NB needs a validator even if the proxy is not secured
    LightstreamerClient.setTrustManagerFactory((sender, cert, chain, sslPolicyErrors) -> true);
    new LightstreamerClient(null, null).connectionOptions.setProxy(proxy);
  }

  function setup() {
    output = [];
  }

  function testProxyHttp(async: utest.Async) {
    new HttpClient(
      "http://" + host + "/lightstreamer/create_session.txt?LS_protocol=TLCP-2.4.0", 
      "LS_polling=true&LS_polling_millis=0&LS_idle_millis=0&LS_adapter_set=TEST&LS_cid=mgQkwtwdysogQz2BJ4Ji%20kOj2Bg", null,
      function onText(c, line) output.push(line), 
      function onError(c, error) { 
        fail(error); 
        async.completed(); 
      }, 
      function onDone(c) { 
        isTrue(output.length > 0);
        match(~/CONOK/, output[0]);
        async.completed(); 
      });
  }

  @:timeout(3000)
  function testProxyHttps(async: utest.Async) {
    new HttpClient(
      "https://push.lightstreamer.com/lightstreamer/create_session.txt?LS_protocol=TLCP-2.4.0", 
      "LS_polling=true&LS_polling_millis=0&LS_idle_millis=0&LS_adapter_set=DEMO&LS_cid=mgQkwtwdysogQz2BJ4Ji%20kOj2Bg", null,
      function onText(c, line) output.push(line), 
      function onError(c, error) { 
        fail(error); 
        async.completed(); 
      }, 
      function onDone(c) { 
        isTrue(output.length > 0);
        match(~/CONOK/, output[0]);
        async.completed(); 
      });
  }

  function testProxyWs(async: utest.Async) {
    new WsClient(
      "ws://" + host + "/lightstreamer", 
      null,
      proxy,
      null,
      function onOpen(c) {
        c.send("create_session\r\nLS_polling=true&LS_polling_millis=0&LS_idle_millis=0&LS_adapter_set=TEST&LS_cid=mgQkwtwdysogQz2BJ4Ji%20kOj2Bg");
      },
      function onText(c, line) {
        if (c.isDisposed()) return;
        match(~/CONOK/, line);
        c.dispose();
        async.completed();
      }, 
      function onError(c, error) {
        if (c.isDisposed()) return;
        fail(error); 
        async.completed(); 
      });
  }

  @:timeout(3000)
  function testProxyWss(async: utest.Async) {
    new WsClient(
      "wss://push.lightstreamer.com/lightstreamer", 
      null,
      proxy,
      // NB needs a validator even if the proxy is not secured
      (sender, cert, chain, sslPolicyErrors) -> true,
      function onOpen(c) {
        c.send("create_session\r\nLS_polling=true&LS_polling_millis=0&LS_idle_millis=0&LS_adapter_set=DEMO&LS_cid=mgQkwtwdysogQz2BJ4Ji%20kOj2Bg");
      },
      function onText(c, line) {
        if (c.isDisposed()) return;
        match(~/CONOK/, line);
        c.dispose();
        async.completed();
      }, 
      function onError(c, error) {
        if (c.isDisposed()) return;
        fail(error); 
        async.completed(); 
      });
  }

  function testInstallSameProxy() {
    var proxy = new com.lightstreamer.client.Proxy("HTTP", "localtest.me", 8079, "myuser", "mypassword");
    new LightstreamerClient(null, null).connectionOptions.setProxy(proxy);
    pass();
  }

  function testInstallDifferentProxy() {
    var proxy = new com.lightstreamer.client.Proxy("HTTP", "localtest.me", 8079);
    raisesEx(
      () -> new LightstreamerClient(null, null).connectionOptions.setProxy(proxy),
      com.lightstreamer.internal.NativeTypes.IllegalStateException,
      "Proxy already installed");
  }
}