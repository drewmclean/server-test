#!/bin/bash

#
# Run a pod update if we have a repo, otherwise run a pod install
#

#xcodebuild -project ./ServerTest.xcodeproj -target "ServerTest" -showBuildSettings

cd ServerTest

if [ -e "Pods" ]
then
pod update
else
pod install
fi