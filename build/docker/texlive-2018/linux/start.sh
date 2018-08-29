#!/bin/bash

create_output() {
  echo "Creating output location"
  test -d /docs/output || {
    mkdir -p /docs/output/PDF
  }
}

start_build() {
  while read source
  do
    cd "$source"
    cd ..
    build_dir="$PWD"
    echo "Building $build_dir"
    if [ -d "${build_dir}/source" ] ; then
      docname=$(basename "$build_dir")
      make clean singlehtml
      cd build/singlehtml
      pandoc -f html -t docx -o "${docname}.docx" index.html
      cd "$build_dir"
      make latex
      make latexpdf
      clear
      output="/docs/output/${docname}"
      mkdir -p "${output}"
      cp -a build/singlehtml/index.html "${output}/${docname}.html"
      cp -a build/singlehtml/"${docname}.docx" "${output}"
      cp -a build/latex/*.pdf "${output}"
      make clean
    else
      printf "Not a valid source.\n"
    fi
  done < <(find /docs/ -type d -iname 'source')
}

doc_source_input=$(find /docs -type d -iname 'source' 2>/dev/null | wc -l)

# start building
if [ $doc_source_input -eq 0 ]
then
  printf "Document source was empty. Please check the volume mountpoint.\n"
else
  start_build
fi
