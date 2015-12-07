#!/bin/bash

#Mauna Loa monthly data
files[0]='co2_mm_mlo.txt'
headers[0]='Date,Decimal Date,Average,Interpolated,Trend,Number of Days'
# Mauna Loa annual data
files[1]='co2_annmean_mlo.txt'
headers[1]='Year,Mean,Uncertainty'
#Mauna Loa growth rate data
files[2]='co2_gr_mlo.txt'
headers[2]='Year,Annual Increase,Uncertainty'
# global monthly data
files[3]='co2_mm_gl.txt'
headers[3]='Date,Decimal Date,Average,Trend'
#global annual data
files[4]='co2_annmean_gl.txt'
headers[4]='Year,Mean,Uncertainty'
#global growth rate data
files[5]='co2_gr_gl.txt'
headers[5]='Year,Annual Increase,Uncertainty'

rename () {
  echo $1 | \
    # replace underscores with dashes
    sed 's/_/-/g' | \
    # replace txt extension with csv
    sed 's/\.txt$/.csv/'
}

write_csv_header () {
  # write the header to the output file
  echo $1 > $2
}

write_csv_content () {
  cat $1 | \
    # delete note at top
    sed '/^#/ d' | \
    # remove leading whitespace
    sed 's/^[ ][ ]*//' | \
    # replace whitespace with commas
    sed 's/[ ][ ]*/,/g' | \
    # combine year and month
    sed 's/^\([0-9]\{4\}\),\([0-9]\{1,2\}\),/\1-\2,/' | \
    # change 1980-1 to 1980-01
    sed 's/\-\([0-9]\),/-0\1,/g' \
    >> $2
}

mkdir -p tmp
mkdir -p data

for index in "${!files[@]}"; do
  file="${files[$index]}"
  header="${headers[$index]}"
  curl ftp://aftp.cmdl.noaa.gov/products/trends/co2/$file > tmp/$file
  output=`rename $file`
  write_csv_header "${header}" data/$output
  write_csv_content tmp/$file data/$output
done
