(function (factory) {
	typeof define === 'function' && define.amd ? define(factory) :
	factory();
})((function () { 'use strict';

	const { func99 } = require('./lib/fat-lib.js');

	console.log('hello world!');
	func99();

}));
