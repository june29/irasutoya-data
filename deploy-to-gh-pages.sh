#!/bin/sh

set -e
pwd

remote="https://$GH_TOKEN@github.com/june29/irasutoya-data.git"

dist="$1"

if [ ! -d "$dist" ]
then
    echo "Usage: $0 <site source dir>"
    exit 1
fi

rm -rf .git

mkdir gh-pages-branch
cd gh-pages-branch

git config --global user.email "$GH_EMAIL" > /dev/null 2>&1
git config --global user.name  "$GH_NAME" > /dev/null 2>&1
git init

cp "../${dist}/irasutoya.json" .

git add .
git commit -m "Deploy by CircleCI"
git remote add origin "$remote"
git push --force --quiet origin master:gh-pages > /dev/null 2>&1

cd ..
rm -rf gh-pages-branch

echo "Finished!"
