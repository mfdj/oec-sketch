#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

NUMBER_OF_PARAGRAPHS=${NUMBER_OF_PARAGRAPHS:-220}

if [[ ! ${TEMP_DIR:-} ]]; then
  TEMP_DIR=$(mktemp -d -t generate-fat-lib)
fi
echo "Using $TEMP_DIR"

# Collect paragraphs
echo > "$TEMP_DIR/paragraphs.html"
for i in 1 2 3 4; do
  if [[ ! -f $TEMP_DIR/chapter$i.html ]]; then
    curl "https://www.marxists.org/archive/marx/works/1848/communist-manifesto/ch0$i.htm" > "$TEMP_DIR/chapter$i.html"
  fi
  htmlq body blockquote p --pretty --remove-nodes .title < "$TEMP_DIR/chapter$i.html" >> "$TEMP_DIR/paragraphs.html"
  wc -l < "$TEMP_DIR/paragraphs.html"
done

generate() {
  local type=$1
  local filepath=$2

  # Generate some code
  echo > "$filepath"
  offset=0
  for index in $(seq 1 "$NUMBER_OF_PARAGRAPHS"); do
    paragraph=
    while [[ -z $paragraph ]]; do
      selector=$(printf 'p:nth-child(%i)' "$(( index + offset ))")
      paragraph=$(htmlq --text "$selector" < "$TEMP_DIR/paragraphs.html" | tr '\n' ' ')
      echo "$index (+ $offset): $paragraph"

      # filter in paragraphs that are only spaces
      if [[ -z $(tr -d ' ' <<< "$paragraph") ]]; then
        offset=$(( offset + 1 ))
        paragraph=
      fi
    done

    if [[ $type == esm ]]; then
      printf 'export ' >> "$filepath"
    fi
    # shellcheck disable=SC2016
    printf 'function func%i(index = %i) {\n  const data = `%s`\n' "$index" "$index" "$paragraph" >> "$filepath"
    # shellcheck disable=SC2016
    printf '  console.log(`manifesto ${index}`);\n  return data;\n}\n\n' >> "$filepath"
  done

  if [[ $type == commonjs ]]; then
    printf 'module.exports = {\n' >> "$filepath"
    for index in $(seq 1 "$NUMBER_OF_PARAGRAPHS"); do
      printf '  func%i,\n' "$index" >> "$filepath"
    done
    echo '}' >> "$filepath"
  fi
}

generate esm lib/fat-lib.mjs
generate commonjs lib/fat-lib.cjs
