#! /bin/bash

rm -f feedback

for filename in $(find pic -type f -name "*.bmp")
do
    name=$(basename $filename | awk -F. '{ print $1 }')

    outb=/tmp/$name
    tesseract -l chi $filename $outb
    egrep '[0-9]+级[油铁硅铜宝]' $outb.txt
    if [ $? -ne 0 ]; then
        echo "please check $filename $outb.txt"

        echo "$filename" >> feedback
        sleep 1
    fi
done
