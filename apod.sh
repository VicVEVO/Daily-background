#!/bin/bash
WORKDIR=$1
cd $WORKDIR

today_is_video=false
random_apod=false

if [ -z "$1" ]; then
  echo "No argument supplied" && exit
else
  TARGETDIR="$1"
fi

apodjson=$(curl -X GET "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")
date=$(echo $apodjson | json_pp | grep "\"date\"" | awk -F '"' '{print $4}')
media_type=$(echo $apodjson | json_pp | grep "\"media_type\"" | awk -F '"' '{print $4}')
hdurl=$(echo $apodjson | json_pp | grep "\"hdurl\"" | awk -F '"' '{print $4}')

# Download today's image
if [ $media_type == "image" ]; then
  curl -o $TARGETDIR/${date}.jpg ${hdurl}
else
  echo "Today APOD is not an image."
fi

# Clean outdated images
find $TARGETDIR -mtime +$(($screen_num + 3)) -exec rm {} \;
