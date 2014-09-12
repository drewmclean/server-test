#!/bin/bash

xcodebuild -project ./ServerTest.xcodeproj -target "ServerTest" -showBuildSettings

if [ -e "Pods" ]
then
pod update
else
pod install
fi
