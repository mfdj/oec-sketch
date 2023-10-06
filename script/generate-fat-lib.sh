#!/usr/bin/env bash

echo > lib/fat-lib.js

for index in $(seq 1 100); do
  printf 'function func%i() {\n  console.log("hello %i");\n }\n\n' "$index" "$index" >> lib/fat-lib.js
done

printf '\nmodule.exports = {\n' >> lib/fat-lib.js

for index in $(seq 1 100); do
  printf '  func%i,\n' "$index" >> lib/fat-lib.js
done

echo '}' >> lib/fat-lib.js