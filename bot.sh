#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
# ------------------------------------------------------------------

if [ -e "Pods" ]
then
pod update
else
pod install
fi
