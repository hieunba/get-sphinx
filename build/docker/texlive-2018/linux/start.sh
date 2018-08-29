#!/bin/bash

create_output() {
  echo "Output directory structure here."
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
    else
      printf "Not a valid source.\n"
    fi
  done < <(find /docs/ -type d -iname 'source')
}


# if [ -z "$doclist" ] ; then
#   printf "Document directory seemed empty. Please check mount point.\n"
#   exit 0
# fi

# start building
start_build
