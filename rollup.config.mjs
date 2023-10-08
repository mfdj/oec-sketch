import packageJson from './package.json' assert { type: "json" };

export default [
  {
    input: 'main.mjs',
    output: {
      name: 'oecSketch',
      file: packageJson.exports.import,
      format: 'es'
    }
  },
  {
    input: 'main.cjs',
    output: {
      name: 'oecSketch',
      file: packageJson.exports.require,
      format: 'cjs'
    }
  }
];
