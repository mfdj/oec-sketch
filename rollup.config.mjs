import json from '@rollup/plugin-json';

export default [
  {
    input: 'main.mjs',
    output: [
      {
        dir: 'dist/es',
        format: 'es',
        preserveModules: true,
      },
      {
        dir: 'dist/cjs',
        format: 'cjs',
        preserveModules: true,
      },
    ],
    plugins: [json()],
  },
];
