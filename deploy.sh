#!/bin/bash

set -e

npm run build

cd dist

git add -A
git commit -m "deploy"
git push -f git@github.com:Roman1462/shop_online.git master:gh-pages

cd -

rm -rf dist
