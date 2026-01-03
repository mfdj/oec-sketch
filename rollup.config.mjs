import packageJson from './package.json' with { type: 'json' };

export default [
  {
    input: 'main.mjs',
    output: [
      {
        file: packageJson.exports.import,
        format: 'es',
      },
      {
        file: packageJson.exports.require,
        format: 'cjs',
      },
    ],
  },
];
