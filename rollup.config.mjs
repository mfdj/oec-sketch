import packageJson from './package.json' with { type: 'json' };
import json from '@rollup/plugin-json';

export default [
  {
    input: 'main.mjs',
    output: [
      {
        file: packageJson.exports.import,
        format: 'es',
        sourcemap: true,
      },
      {
        file: packageJson.exports.require,
        format: 'cjs',
        sourcemap: true,
      },
    ],
    plugins: [json()],
  },
];
