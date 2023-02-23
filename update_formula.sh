#!/bin/bash
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This script updates the sha256 hash of bottled binary packages with .sha256
# files created when binary packages are bottled. It searches files under the
# current directory with the suffix sha256, replaces root_url's version number,
# and rebuilds the sha256-hash entries with the current bottle entries.
#
# The name of sha256 hash files should be,
# <Formula-name>-<version>.<macosname>.bottle.<rebuildnumber>.sha256
#
# Usage:
# $ updatee_bottles.sh <Formula names> or <Formula files>
# Examples:
# $ ./update_bottle.sh omniorb-ssl-py313
# $ ./update_bottle.sh omniorb-ssl-*.rb
#

update_formula()
{
  arg=$1
  rb_file="${arg}.rb"
  version=""
  new_bottle_blocks=""

  # find .sha256 files and extract version number
  sha256_files=$(find . -name "${arg}"-*.sha256 2> /dev/null)
  if [ -z "$sha256_files" ]; then
    echo "No .sha256 file found for ${arg}"
    exit 1
  fi

  # collect bottle do blocks from .sha256 files
  for sha256_file in $sha256_files; do
    # obtain version number from file name
    version=$(echo "$sha256_file" | awk -v pref=$arg 'BEGIN{FS=pref;}{print $2;}' | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" )
    if [ -z "$version" ]; then
      echo "Failed to extract version from file name $sha256_file"
      continue
    fi

    # extract bottle do block in the .sha256 file
    bottle_block=$(sed '/bottle do/,/end/!d; /bottle do/d; /end/d' "$sha256_file")
    if [ -z "$bottle_block" ]; then
      echo "Failed to extract bottle block from $sha256_file"
      continue
    fi
    # add bottle block
    new_bottle_blocks="$new_bottle_blocks
$bottle_block"
  done
  new_bottle_blocks=`echo "$new_bottle_blocks" | sed '/^$/d'`

  # modify bottle do block in the <arg>.rb file
  if [ -f "$rb_file" ]; then
    # extract bottle do block
    existing_bottle_block=$(grep "root_url" "$rb_file")

    if [ -n "$existing_bottle_block" ]; then
      # replace version number
      updated_bottle_block=$(echo "$existing_bottle_block" | sed "s/\/[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\//\/$version\//g")

      # create new_bottle_blocks.tmp file as new bottle block
      echo "  bottle do" > new_bottle_blocks.tmp
      echo "$updated_bottle_block" >> new_bottle_blocks.tmp
      echo "$new_bottle_blocks" >> new_bottle_blocks.tmp
      echo "  end" >> new_bottle_blocks.tmp
      echo "" >> new_bottle_blocks.tmp
      new_bottle_blocks=$(sed 's/$/\\/' new_bottle_blocks.tmp)
      rm new_bottle_blocks.tmp

      # replace bottle block with new_bottle_blocks.tmp
      sed -i.bak "/bottle do/,/end/c\\
$new_bottle_blocks
" $rb_file
      echo "Updated bottle block in $rb_file"
    else
      echo "No existing bottle block found in $rb_file"
    fi
  else
    echo "$rb_file not found"
    exit 1
  fi
}

#---------------------------
# Check number of args
#---------------------------
if [ $# -lt 1 ]; then
  echo "Usage: $0 <formulas> or <*.rb>"
  exit 1
fi

#---------------------------
# main
#---------------------------
for arg in $* ; do
  formula_name=`echo $arg | sed 's/\(.*\)\.rb/\1/' `
  update_formula $formula_name
done
