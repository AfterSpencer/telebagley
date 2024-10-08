#!/bin/bash

# 10/08/2024
# slctrib scaper v.2

if [ -f /opt/sltrib/comic.jpg ]
then
	mv /opt/sltrib/comic.jpg /opt/sltrib/comic-last.jpg
fi

first=""

first=`curl -g -s -L https://www.sltrib.com/opinion/bagley/ | grep -o 'opinion/bagley/20[^[:blank:]]*' | head -n 1 | awk -F '"' '{print $1}'`
echo $first
second=`curl -g -s -L "https://www.sltrib.com/$first" | grep -o 'https://cloudfront-us-east-1.images.arcpublishing.com/sltrib/[^[:blank:]]*' | grep jpg | head -n 1 | awk -F '"' '{print $1}'`
name=`curl -g -s -L "https://www.sltrib.com/$first" | awk -vRS="</title>" '/<title>/{gsub(/.*<title>|\n+/,"");print;exit}' | awk -F ": " '{print $NF}'`
echo $second
wget -N -O /opt/sltrib/comic.jpg "${second}"

if cmp -s "/opt/sltrib/comic-last.jpg" "/opt/sltrib/comic.jpg"
then
	echo "No new comic"
	exit 0
else
/usr/bin/printf "Comic of the day" | /usr/local/bin/telegram-send /opt/sltrib/comic.jpg "$name"
fi
