#!/bin/bash

source ~/.profile

set -e
set -x
cd "$(dirname "$0")"

git pull

signalNoUpdate=0
signalUpdate=42

{
	node 1_download.js &&
	node 2_deduplicate.js &&
	node 3_parse.js &&
	node 4_generate_csv.js
} || {
	error=$?
	signalNoUpdate=$error
	signalUpdate=$error
	echo "ERROR happend $error"
}

sleep 3

git add ../data/
git commit -m "automatic data update" || exit $signalNoUpdate
git push

exit $signalUpdate
