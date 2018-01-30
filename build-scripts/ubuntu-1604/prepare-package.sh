#!/bin/bash -xe

if [ "$1" = "--help" ] ; then
  echo "Usage: $0 <path-to-repo-folder> <release-version-dotted>"
fi

repo="$1"
version_dotted="$2"

MANIFEST_FNAME="manifest.txt"

echo -e "\n\nAbout to start updating package $repo to version $version_dotted info from cur dir: $(pwd)"

manifest_file="$(find $repo -name $MANIFEST_FNAME)"

if [ -z $manifest_file ] ; then
  echo "FAILED finding manifest"
  exit $ret
fi

# update manifest file
repourl=$(git --git-dir $repo/.git --work-tree $repo config --get remote.origin.url)
hashcommit=$(git --git-dir $repo/.git --work-tree $repo rev-parse HEAD)
manifest_data="// built from: repo version hash\n$repourl $version_dotted $hashcommit"

echo "Adding manifest\n=======\n$manifest_data\n=======\n into $manifest_file"
rm -rf $manifest_file
echo -e $manifest_data >$manifest_file

echo -e "Finished preparing $repo for publishing\n"
