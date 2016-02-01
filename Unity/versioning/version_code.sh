#!/bin/sh

#environment vars...
#FILE - the file in which we want to replace
#CORE_TAG_FILE - the file containing the core sdk version major minor revision build number mbmobile/builds
#BUILD_TIMESTAMP
 
CORE_VERSION=`strings $CORE_TAG_FILE`
VERSION="$CORE_VERSION $BUILD_TIMESTAMP" 

echo "unity test app version title $VERSION"
sed  -E -i .original -e 's/[[:space:]]+public[[:space:]]+static[[:space:]]+string[[:space:]]+BUILD_DATE[[:space:]]*=[[:space:]]*".*"[[:space:]]*;/ public static string BUILD_DATE="'"$VERSION"'";/' $FILE
