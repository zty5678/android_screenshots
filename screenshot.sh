#!/usr/bin/env bash
# deprecated! use ```fastlane android screenshots```
locales=('en-US' 'zh-CN')
tests_apk_path="app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk"
app_apk_path="app/build/outputs/apk/debug/app-debug.apk"

./gradlew assembleDebug assembleAndroidTest

rm -r fastlane/metadata/android/

function start_clean_status_bar {
    # Start demo mode
    adb shell settings put global sysui_demo_allowed 1

    # Display time 12:00
    adb shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 1200
    # Display full mobile data without type
    adb shell am broadcast -a com.android.systemui.demo -e command network -e mobile show -e level 4 -e datatype false
    adb shell am broadcast -a com.android.systemui.demo -e command network -e wifi show -e level 4 -e fully true
    # Hide notifications
    adb shell am broadcast -a com.android.systemui.demo -e command notifications -e visible false
    # Show full battery but not in charging state
    adb shell am broadcast -a com.android.systemui.demo -e command battery -e plugged false -e level 100
}

function stop_clean_status_bar {
    adb shell am broadcast -a com.android.systemui.demo -e command exit
}

for i in "${locales[@]}"
do
#    start_clean_status_bar
    fastlane screengrab \
        --locales=$i \
        --tests_apk_path="$tests_apk_path" \
        --app_apk_path="$app_apk_path"
#    stop_clean_status_bar
done
