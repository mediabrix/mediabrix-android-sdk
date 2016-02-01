#!/bin/sh

#this script is expected to be called from its parent directory (e.g. scripts\android_build.sh)

echo current directory `pwd`
echo "" > out.txt
tail -f out.txt &
if [ -z "`jobs`" ]; then exit 1; fi
cp defines/android.rsp Assets/smcs.rsp
mkdir -p Builds/android
/Applications/Unity/Unity.app/Contents/MacOS/Unity -batchmode -quit -projectPath `pwd` -executeMethod MediaBrixUnityBuild.PerformAndroidBuild -logFile out.txt 
sleep 1
kill %1

echo grepping logs to verify build success or failure
if [ -n "`grep Creating\ APK\ package out.txt`" ]; then
if [ -n "`grep Exiting\ batchmode\ successfully out.txt`" ]; then exit 0; fi;
fi

if [ -n "`grep Aborting\ batchmode out.txt`" ]; then exit 1; fi
