import HxUtils;
import sys.io.File;

function main() {
  var coreClasses: Array<String> = haxe.Json.parse(File.getContent("tools/classes.core.json"));
  copyPackageJson();
  HxUtils.fixLib("bin/node/lightstreamer-node_orig.js", coreClasses);
  generateLibs();
  HxUtils.renameTypescriptDeclarationFile("bin/node/lightstreamer-node_orig.d.ts");
}

function copyPackageJson() {
  File.copy("tools/node/package.json", "bin/node/package.json");
}

function generateLibs() {
  HxUtils.run("npx rollup --config rollup.config.node.js");
}