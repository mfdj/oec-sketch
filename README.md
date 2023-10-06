# Hello World, with Rollup

This project contains a hello world program in `main.js` which uses a library:

```js
const { func99 } = require('./lib/fat-lib.js');
console.log('hello world!');
func99();
```

Which we'll build with Rollup using UMD, so it's compatible with Node and Browsers:

```sh
$ rollup main.js --file bundle.js --format umd --name 'myBundle'
```

### Rollup

Install packages

```sh
$ yarn 
```

Run build

```sh
$ yarn build
```

This will output **bundle.js**:

```js
(function (factory) {
	typeof define === 'function' && define.amd ? define(factory) :
	factory();
})((function () { 'use strict';

	const { func99 } = require('./lib/fat-lib.js');

	console.log('hello world!');
	func99();

}));
```
