#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

NUMBER_OF_PARAGRAPHS=${NUMBER_OF_PARAGRAPHS:-220}

if [[ ! ${TEMP_DIR:-} ]]; then
  TEMP_DIR=$(mktemp -d -t generate-fat-lib)
fi
echo "Using $TEMP_DIR"

# Download each chapter then collate into a singular paragraphs.html
echo > "$TEMP_DIR/paragraphs.html"
for chapter_index in 1 2 3 4; do
  if [[ ! -f $TEMP_DIR/chapter$chapter_index.html ]]; then
    curl "https://www.marxists.org/archive/marx/works/1848/communist-manifesto/ch0$chapter_index.htm" --silent > "$TEMP_DIR/chapter$chapter_index.html"
  fi

  htmlq body blockquote p --pretty --remove-nodes .title < "$TEMP_DIR/chapter$chapter_index.html" >> "$TEMP_DIR/paragraphs.html"

  echo -n "paragraphs.html line count after chapter $chapter_index: "
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
      echo -ne "\r\033[Kindex: $index (+ $offset)"

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

  echo
  echo -n 'Bytes: '
  gdu --block-size=1 --apparent-size "$filepath"
}

generate esm lib/fat-lib.mjs
# generate commonjs lib/fat-lib.cjs
