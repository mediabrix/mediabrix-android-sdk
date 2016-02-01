#!/bin/sh

echo "\n=================== building ane ===================\n"
pushd ../mediabrix-air-sdk
pwd
./build.sh
popd


echo "\n=================== building test apa ===================\n"

FLEX_SDK=/USERS/YOUR LOGIN NAME/FULL_FILE_PATH/AIRSDK
IOS_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk

$FLEX_SDK/bin/amxmlc -source-path ./src -swf-version=14  -external-library-path+="../mediabrix-air-sdk/build/mediabrix.ane" -output ./bin/Main.swf src/Main.as

cp -R ./src/* ./bin

pushd bin

$FLEX_SDK/bin/adt -package -target ipa-ad-hoc \
# $FLEX_SDK/bin/adt -package -target ipa-test-interpreter \
	
-provisioning-profile /USERS/YOUR LOGIN NAME/FULL_FILE_PATH/PROFILE.mobileprovision \
-storetype pkcs12 -keystore /USERS/YOUR LOGIN NAME/FULL_FILE_PATH/YOUR_CERTIFICATE.p12 -storepass PASSWORD \
./mediabrix.ipa \
./Main-app.xml ./assets/airicon.png \
./Main.swf \
-extdir ../../mediabrix-air-sdk/build \
-platformsdk $IOS_SDK

popd 

echo "\n=================== deploying test apa ===================\n"

ruby transporter_chief.rb ./bin/MediabrixAIR.ipa --verbose

