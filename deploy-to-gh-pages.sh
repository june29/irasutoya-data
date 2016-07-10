#!/bin/sh

set -e
pwd

remote=$(git config remote.origin.url)

siteSource="$1"

if [ ! -d "$siteSource" ]
then
    echo "Usage: $0 <site source dir>"
    exit 1
fi

mkdir gh-pages-branch
cd gh-pages-branch

git config --global user.email "$GH_EMAIL" > /dev/null 2>&1
git config --global user.name "$GH_NAME" > /dev/null 2>&1
git init
git remote add --fetch origin "$remote"

if git rev-parse --verify origin/gh-pages > /dev/null 2>&1
then
    git checkout gh-pages
    git rm -rf .
else
    git checkout --orphan gh-pages
fi

cp -a "../${siteSource}/." .

git add -A
git commit --allow-empty -m "Deploy by CircleCI"
git push --force --quiet origin gh-pages > /dev/null 2>&1

cd ..
rm -rf gh-pages-branch

echo "Finished!"
