#!/bin/bash

create_output() {
  for dir in PDF HTML Doc
  do
    test -d /docs/output/$dir || mkdir -p /docs/output/$dir
  done
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
      mv build/singlehtml/"${docname}.docx" /docs/output/Doc
      mv build/singlehtml /docs/output/HTML/"${docname}"
      mv build/latex/*.pdf /docs/output/PDF
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
  create_output
  start_build
fi
