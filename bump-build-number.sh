#!/bin/bash

#
# Use agvtool to set Xcode project build number and create git tag
# Commit the updated .xcproject and plist files back to git
# Note: requires Xcode project configured to use Apple Generic Versioning and git
#
# Usage: set_agv_ver.sh 123
#
# src: https://gist.github.com/rob-murray/8644974
#
 
NOTE="'bump-build-number.sh' will increment build version number of Xcode project"
 
# just increment the version
function next_build_version() {
    # bump the version number
    $(agvtool next-version -all &> /dev/null)
}
 
function get_marketing_version() {
    agvtool what-marketing-version -terse1
}

function get_build_version() {
    agvtool what-version -terse
}

# function git_tag(label, message)
function git_tag() {
 
    local _version="$1"
 
    if [[ -z "$_version" ]]
    then
        echo "Param version is empty."
        exit
    fi

    git tag -a $_version -m "Tag build $_version"
    git push --tags

    git add .
    git commit -m "Increment build number (_version)"
    git push
}
 
echo "$NOTE"
 
#set_version $VERSION
next_build_version
 
# grab the marketing and build versions
marketing_version=`get_marketing_version`
new_version=`get_build_version`
 
# will tag in this format; e.g. {marketing_version}.{build_version} 2.1.4.68
version_id="$marketing_version.$new_version"

# commit changes and tag
git_tag $version_id
 
echo "Set Xcode project to build version $VERSION and tagged with label $version_id"