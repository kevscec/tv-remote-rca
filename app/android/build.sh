#!/bin/bash
# Builds app/android/build/TV-Remote-RCA.apk (release, signed) with Gradle. Needs JDK 17+ and the Android SDK
# (ANDROID_HOME, default ~/Library/Android/sdk). The project can also be opened in Android Studio: open the "app/gradle" folder.
# Signing values come from the environment; never silently replace the installed app's signer.
set -e
cd "$(dirname "$0")"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
: "${RCA_KEYSTORE_PATH:?Set the absolute path to the private RCA signing keystore}"
: "${RCA_STORE_PASSWORD:?Set the keystore password}"
: "${RCA_KEY_ALIAS:?Set the signing key alias}"
: "${RCA_KEY_PASSWORD:?Set the signing key password}"
test -f "$RCA_KEYSTORE_PATH"
../gradle/gradlew -q -p ../gradle :android:assembleRelease
cp build/outputs/apk/release/android-release.apk build/TV-Remote-RCA.apk
ls -l build/TV-Remote-RCA.apk | awk '{print "built", $9, $5, "bytes"}'
