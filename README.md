# oec-sketch

This project is a basic library using `main.js` as an entrypoint:

```js
const { func99, func79, func59, func39, func19, func9 } = require('./lib/fat-lib.js');

console.log('➳ oec-sketch module evaluation');

function main() {
  return func79() + func59() + func39() + func19() + func9();
}

module.exports = {
  func99,
  main
};
```

Which we'll build with Rollup using UMD, so it's compatible with Node and Browsers:

```sh
$ rollup main.js --file bundle.js --format umd --name 'oecSketch'
```

We'll reference the bundle in **main** field of our package.json:

```js
{
  "name": "@mfdj/oec-sketch",
  "main": "./bundle.js"
}
```

### Rollup build

Install packages + build

```sh
$ yarn; yarn build 
```

This will output **bundle.js**:

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

When added to a create-react project the entire library (106.34 KB) will be included in the main chunk:

<img src="docs/analyze-umd-build.png" />
