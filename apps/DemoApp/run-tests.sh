#!/bin/bash
set -euo pipefail

# Delete the old stuff
rm -Rf XCFramework
# reset simulators
xcrun -v simctl shutdown all
xcrun -v simctl erase all
buildkite-agent artifact download "MUXSDKStats.xcframework.zip" . --step ".buildkite/build.sh"
unzip MUXSDKStats.xcframework.zip
cd apps/DemoApp
pod deintegrate && pod update
xcodebuild -workspace DemoApp.xcworkspace \
           -scheme "DemoApp" \
           -destination 'platform=iOS Simulator,name=iPhone 11,OS=15.2' \
           test
