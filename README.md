# oec-sketch

**Git history highlights**

[27566ff](https://github.com/mfdj/oec-sketch/tree/27566ff583a1f460dc49a4199c1264aa27dcb00a) Functional UMD package with fat-lib

## Details

This project is a basic library with two entrypoints: one in ES and the other is a CommonJS clone.

`main.mjs` using modern ES features (namely `import` + `export`):

```js
import { func79, func59, func39, func19, func9 } from './lib/fat-lib.mjs';

console.log('➳ oec-sketch ESM evaluation');

export function main() {
  return func79() + func59() + func39() + func19() + func9();
}

export { func99 } from './lib/fat-lib.mjs';
```

`main.cjs` using "classic" Node apis (namely `require` + `module.exports`):

```js
const { func99, func79, func59, func39, func19, func9 } = require('./lib/fat-lib.cjs');

console.log('➳ oec-sketch CommonJS evaluation');

function main() {
  return func79() + func59() + func39() + func19() + func9();
}

module.exports = {
  func99,
  main
};
```

Both entrypoints are bundled with Rollup:

```js
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
```

The outputs utilize the **export** field of our package.json:

```js
{
  "name": "@mfdj/oec-sketch",
  "exports": {
    "import": "./bundle.mjs",
    "require": "./bundle.cjs"
  }
}
```

### Rollup build + usage in CRA host-app

Install packages + build

```sh
$ yarn; yarn build 
```

Add to a create-react project using yarn add link:

```sh
$ yarn add link:../oec-sketch
```

And use in App.jsx:

```jsx
import { main, func99 } from "@mfdj/oec-sketch";

function App() {
  const handleClick = useCallback(() => {
    func99();
    console.log("App ☢️ " + main());
  }, []);

  return (
    <div className="App">
      <header className="App-header" onClick={handleClick}>
        <img src={logo} className="App-logo" alt="logo" />
      </header>
    </div>
  );
}
```

#### ES output: bundle.mjs

```js
function func9(index = 9) {
  // …
}

function func19(index = 19) {
  // …
}

function func39(index = 39) {
  // …
}

function func59(index = 59) {
  // …
}

function func79(index = 79) {
  // …
}

function func99(index = 99) {
  // …
}

console.log('➳ oec-sketch ESM evaluation');

function main() {
  return func79() + func59() + func39() + func19() + func9();
}

export { func99, main };
```

The tree-shaken bundle is 2.64 KB in the main chunk:

<img src="docs/analyze-mjs-build.png" />

#### CommonJS output: bundle.cjs

```js
'use strict';

const { func99, func79, func59, func39, func19, func9 } = require('./lib/fat-lib.cjs');

console.log('➳ oec-sketch CommonJS evaluation');

function main() {
  return func79() + func59() + func39() + func19() + func9();
}

module.exports = {
  func99,
  main
};
```

Which Jest will use during tests:

<img src="docs/jest-using-cjs-export.png" />

#### Former UMD output: bundle.js

Previously the UMD output included:

```js
(function (factory) {
  typeof define === 'function' && define.amd ? define(factory) :
  factory();
})((function () { 'use strict';

  const { func99, func79, func59, func39, func19, func9 } = require('./lib/fat-lib.js');

  console.log('➳ oec-sketch module evaluation');

  function main() {
    return func79() + func59() + func39() + func19() + func9();
  }

  module.exports = {
    func99,
    main
  };

}));
```

The entire library (106.34 KB) was included in the main chunk:

<img src="docs/analyze-umd-build.png" />
