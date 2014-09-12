#!/bin/bash
 
#
# Use agvtool to set Xcode project build number and create git tag
# Note: requires Xcode project configured to use Apple Generic Versioning and git
#
# Usage: set_agv_ver.sh 123
#
# src: https://gist.github.com/rob-murray/8644974
#
 
NOTE="'set_agv_ver.sh' will set build version number of Xcode project"
 
# just increment the version
function bump_version() {
    # bump the version number
    $(agvtool next-version -all &> /dev/null)
}
 
# set Xcode project to version passed as argument
function set_version() {
    local _version="$1"
    
    if [[ -z "$_version" ]]
    then
        echo "Version is empty."
        exit
    fi
 
    # bump the version number
    $(agvtool new-version -all $_version &> /dev/null)
}
 
function getAgvMarketingVersion() {
    agvtool what-marketing-version -terse1
}
 
function getAgvBuildVersion() {
    agvtool what-version -terse
}
 
# function git_tag(label, message)
function git_tag() {
 
    local _label="$1"
    local _message="$2"
 
    if [[ -z "$_label" ]]
    then
        echo "Param label is empty."
        exit
    fi
 
    if [[ -z $_message ]]
    then
        echo "Param message is empty."
        exit
    fi
 
    git tag -a $_label -m"$_message"
    git push --tags
}
 
# entry
if [ $# -lt 1 ]
then
  echo "Usage: $0 version_id"
  exit
fi

VERSION="$1"
 
echo "$NOTE"
 
#set_version $VERSION
bump_version
 
# grab the marketing and build versions
marketing_version=`getAgvMarketingVersion`
new_version=`getAgvBuildVersion`
 
# will tag in this format; e.g. {marketing_version}.{build_version} 2.1.4.68
version_id="$marketing_version.$new_version"
 
# commit changes and tag
git_tag $version_id "Tag build $version_id"
 
echo "Set Xcode project to build version $VERSION and tagged with label $version_id"