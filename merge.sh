#!/usr/bin/env bash

# Assumes source is in users home in a directory called "orion"
export ORIONPATH="${HOME}/orion"

# Set the tag you want to merge
export TAG="android-6.0.1_r72"

# Orion manifest is setup with path first, then repo name, so the path attribute is after 2 spaces, and the name within "" in it
for repos in $(grep 'remote="orion"' ${ORIONPATH}/.repo/manifests/default.xml  | awk '{print $2}' | cut -d '"' -f2)
do
echo -e ""
echo "Merging $repos"
echo -e ""
cd $repos;
git fetch https://android.googlesource.com/platform/$repos $TAG -q && git merge --no-edit FETCH_HEAD;
if [ $? -ne 0 ];
then
echo "$repos" >> ${ORIONPATH}/failed
echo "$repos failed :C"
else
echo "$repos" >> ${ORIONPATH}/success
echo "$repos succeeded"
fi
echo -e ""
cd ${ORIONPATH};
done

echo -e ""
echo -e "These repos failed"
cat ./failed
echo -e ""
echo -e "These succeeded"
cat ./success
