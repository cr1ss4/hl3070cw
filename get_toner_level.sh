#!/bin/bash
#
# 20220109 ts get toner level from printer status web site
#             LCNT see https://stackoverflow.com/questions/16679369/count-occurrences-of-a-char-in-a-string-using-bash

PRINTER="Brother HL-3070CW"
URL="https://hl3070cw.fritz.box/etc/view_config.html"
TMPFILE="/tmp/.get_toner_level.$$"

# wget --quiet --no-check-certificate --output-document=$TMPFILE $URL
curl --silent --insecure --output $TMPFILE $URL

if [ -f $TMPFILE ];
then
  echo $PRINTER "toner level"
  for COLOR in Cyan Magenta Yellow Black
  do
    LEVEL=`grep -A10 "^$COLOR" $TMPFILE | tail -1 | sed "s/&#x25a0;/#/g" | sed "s/&#x25a1;/./g"`
    LCNT=`grep -o '#' <<<"$LEVEL" | grep -c .`
    LPER=`echo "$LCNT * 10" | bc`

    echo -e $COLOR"\t"$LEVEL $LPER"%"
  done
else
  echo $PRINTER "couldn't get status"
fi

# 20220109 ts one liner to remove temp file
test -f $TMPFILE && rm $TMPFILE

# eof
