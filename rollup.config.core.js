import JsUtils from './tools/JsUtils'
import { terser } from 'rollup-plugin-terser'
import pkg from './bin/web/package.json'
import classes from './tools/classes.core.json';

const [versionNum, buildNum] = JsUtils.parseSemVer(pkg.version)

export default [
  {
    input: 'bin/web/lightstreamer_orig.core.js',
    output: [ 
      {
        name: 'lightstreamerExports',
        file: 'bin/web/lightstreamer-core.js',
        format: 'iife',
        banner: JsUtils.generateCopyright("Web", versionNum, buildNum, "UMD", classes) + "\n" + JsUtils.generateUmdHeader(classes),
        footer: JsUtils.generateUmdFooter('lightstreamerExports')
      },
      {
        name: 'lightstreamerExports',
        file: 'bin/web/lightstreamer-core.min.js',
        format: 'iife',
        banner: JsUtils.generateCopyright("Web", versionNum, buildNum, "UMD", classes) + "\n" + JsUtils.generateUmdHeader(classes),
        footer: JsUtils.generateUmdFooter('lightstreamerExports'),
        sourcemap: true,
        plugins: [
          terser()
        ]
      },
      {
        file: 'bin/web/lightstreamer-core.esm.js',
        format: 'es',
        banner: JsUtils.generateCopyright("Web", versionNum, buildNum, "ESM", classes)
      },
      {
        file: 'bin/web/lightstreamer-core.common.js',
        format: 'cjs',
        banner: JsUtils.generateCopyright("Web", versionNum, buildNum, "CJS", classes)
      }
    ]
  }
];