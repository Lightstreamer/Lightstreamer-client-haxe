import utest.ui.common.ResultAggregator;
import utest.ui.common.PackageResult;
import utest.Runner;
import utest.ui.Report;
import com.lightstreamer.client.*;

class TestAll {

  static function buildSuite(runner: Runner) {
    runner.addCase(new TestCase());
    runner.addCase(new TestConnectionDetails());
    runner.addCase(new TestConnectionOptions());
    runner.addCase(new TestSubscription());
    #if LS_MPN
    #if js
    runner.addCase(new com.lightstreamer.client.mpn.TestMpnDevice());
    runner.addCase(new com.lightstreamer.client.mpn.TestFirebaseMpnBuilder());
    runner.addCase(new com.lightstreamer.client.mpn.TestSafariMpnBuilder());
    #end
    runner.addCase(new com.lightstreamer.client.mpn.TestMpnSubscription());
    #if java
    runner.addCase(new com.lightstreamer.client.mpn.TestAndroidMpnBuilder());
    #end
    #end
    runner.addCase(new TestEventDispatcher());
  }

  public static function main() {
    var runner = new Runner();
    buildSuite(runner);
    Report.create(runner);
    runner.run();
  }

  #if java
  // alternative entry point to run instrumented tests under android:
  // class Report interferes with logcat
  public static function androidMain() {
    var runner = new Runner();
    buildSuite(runner);
    var aggregator = new ResultAggregator(runner, true);
    aggregator.onComplete.add(complete);
    runner.run();
  }

  static function complete(result : PackageResult) {
    var stats = result.stats;
    Sys.println("assertions: "   + stats.assertations);
    Sys.println("successes: "      + stats.successes);
    Sys.println("errors: "         + stats.errors);
    Sys.println("failures: "       + stats.failures);
    Sys.println("warnings: "       + stats.warnings);
    Sys.println("results: " + (stats.isOk ? "ALL TESTS OK (success: true)" : "SOME TESTS FAILURES (success: false)"));
    if (!stats.isOk) {
      throw "SOME TESTS FAILURES (success: false)";
    }
  }
  #end
}