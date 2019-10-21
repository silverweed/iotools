#!/bin/bash

BM_FIELD=${BM_FIELD:-realtime}

if [ -f $BM_OUTPUT ]; then
  mv $BM_OUTPUT $BM_OUTPUT.save
fi

for result in $@; do
  medium=$(echo $result | cut -d_ -f3 | cut -d. -f1)
  sample=$(echo $result | cut -d. -f2 | cut -d+ -f1 | cut -d~ -f1)
  format=$(echo $result | cut -d. -f3)
  header="$sample $medium $format"
  echo "$result --> $sample $medium $format"
  grep "^${BM_FIELD}" $result | awk -v header="$header" \
    '{ for(i=2; i<NF; i++) printf "%s",$i OFS; if(NF) printf "%s",$NF; printf ORS} BEGIN {printf "%s ", header}' \
    >> $BM_OUTPUT
done
