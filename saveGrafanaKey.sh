#!/bin/sh

var4="$(cat grafanaApiResponse.json | jq -r '.key')"

var4="GRAFANA_API_KEY=${var4}"

echo "$var4"

echo "" >> envfolder/DMSenv # for one blank line
echo "$var4" >> envfolder/DMSenv

# delete the grafanaApiResponse.json file
rm grafanaApiResponse.json
