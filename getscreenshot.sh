#!/bin/bash
CURRENT=`pwd`
cd /home/mark/projects/scrsht
node index.js mstringer animals1 "$@"
cd ${CURRENT}
cp /home/mark/projects/scrsht/screenshots/url.png graphs

