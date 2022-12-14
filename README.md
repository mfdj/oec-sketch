# Hello World, with Rollup

This project contains a hello world program in `main.js`:

```js
console.log('hello world!');
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

	console.log('hello world!');

}));
```
