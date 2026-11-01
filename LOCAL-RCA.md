# TV Remote RCA

Independent phone-only compatibility fork of [HoangTran0410/tv-remote](https://github.com/HoangTran0410/tv-remote), based on tag **v0.39.0**, commit `7ef9c8837d3b996449f4aa4b231dbe37c73a5b56`. That release contains phone component **0.36.0**; the first public fork release reports **0.36.1-rca1** (versionCode 103601), following the private **0.36.0-rca1** test install. The upstream MIT license, copyright and Git history are retained. This is not an official upstream release.

The work began during a [CleanYourTV](https://github.com/Gathin23/cleanyourtv/blob/main/PROMPT.md) audit of an old RCA TV whose physical remote was missing. A free phone remote with a working Home button was needed. This fork does not port the CleanYourTV launcher or change TV firmware.

## Problem and changes

On the tested RCA / Realtek RT2831, Android 7.1.1 / API 25 firmware, a new remote ADB handshake repeatedly timed out while another remote client retained its session. After that client disconnected, a new handshake succeeded. ADB remained enabled. Upstream's saved-TV status reader retains its own AdbLink for up to 40 seconds after leaving the list; remote control, mirroring and background Manage preparation can create separate connections. The observed device behavior and source explain this case; this is not a universal claim about all Realtek firmware or RCA TVs. The commercial model on the TV's label was not confirmed.

This build uses a separate package and label, `dev.tvremote.phone.rca` / **TV Remote RCA**, so the original app stays installed with its data. `BuildConfig.RCA_SINGLE_ADB` is always true. It disables automatic saved-TV ADB status probes, starts without video regardless of saved preference, hides separate video/audio/Manage toolbar buttons, skips background Manage preparation and the TV Setup installation prompt, and disables upstream phone update checks for the separately signed package. The shared ADB protocol is unchanged.

The flag gates the tested normal remote path. It is not a global transport arbiter: inherited advanced actions, widgets, scenes or settings are not all removed or validated. The saved-list screenshots icon can still appear; its background status reader is disabled. Use another ADB client only after disconnecting this remote. **picture off** means mirroring is off, not that the television is off.

The app uses a temporary scrcpy server via `app_process` for input. It may write temporary files and execute processes on the TV while connected; no TV receiver APK was installed during testing. No root or Play Protect change was needed. ADB must remain enabled and authorized on the TV. Use a trusted local network and do not expose ADB to the internet.

Source edits are confined to the Phone app; the desktop client, shared core, TV web page and launcher flow are unchanged. Upstream documentation describes the full suite, not this fork's tested feature set.

## Build

Prerequisites: Git, JDK 17, Android SDK platform 35 and build-tools 35.0.0. Set `ANDROID_HOME` to your SDK, or create the ignored `app/gradle/local.properties` with `sdk.dir=<your SDK path>`. The wrapper downloads Gradle 8.13 and dependencies on the first build.

Linux / macOS, from the repository root:

```sh
cd app/gradle
./gradlew :android:assembleDebug :android:testDebugUnitTest :android:lintDebug --no-daemon --max-workers=2
```

Windows PowerShell, from the repository root (upstream has no gradlew.bat):

```powershell
Set-Location app/gradle
java -classpath gradle/wrapper/gradle-wrapper.jar org.gradle.wrapper.GradleWrapperMain :android:assembleDebug :android:testDebugUnitTest :android:lintDebug --no-daemon --max-workers=2
```

Output: `app/android/build/outputs/apk/debug/android-debug.apk`. Install on your phone, not the TV. Example from repository root, with an explicitly selected phone:

```sh
adb -s <PHONE_SERIAL> install --user 0 -r app/android/build/outputs/apk/debug/android-debug.apk
```

If Windows JDK 17 fails with `Unable to establish loopback connection` from its Unix-domain selector, this session used a process-only workaround before Gradle: set `JDK_JAVA_OPTIONS` to `-Djdk.net.unixdomain.tmpdir=<absolute path to a directory that does not exist>`. The failed Unix listener causes OpenJDK's TCP fallback. Use your own path; do not create that directory. No global Java or firewall change is required.

## Signing and distribution

[Download the signed RCA phone APK](https://github.com/kevscec/tv-remote-rca/releases/latest/download/TV-Remote-RCA.apk) or [read release notes and SHA256SUMS](https://github.com/kevscec/tv-remote-rca/releases/latest). Release APKs are built with the release build type (not debuggable, R8 enabled). Updates are manual: this fork does not check or install upstream updates.

Upstream download links and Downloader codes install upstream, not this fork. The optional manual workflow `RCA Android validation` builds a debug test artifact with an ephemeral CI key; it does not publish a release and cannot be assumed to update a published install.

The first release deliberately retains the initial local test install's certificate to preserve in-place updates. This certificate originated as the workstation's Android development identity; its private key is now also retained in a password-protected release keystore outside the repository. This is a sideload compatibility release, not a Play Store submission. The private key is not an APK asset and is never uploaded. Signing certificate SHA256: `5056760554b8b30848b6253ea8de0cbb552dc83763e3504b326db0a07dc4e148`.

Release builds use four environment variables: `RCA_KEYSTORE_PATH` (absolute path), `RCA_STORE_PASSWORD`, `RCA_KEY_ALIAS`, `RCA_KEY_PASSWORD`. With them set, run `:android:assembleRelease :android:lintRelease` from app/gradle, or `bash app/android/build.sh` from the repository root. Output is `app/android/build/outputs/apk/release/android-release.apk`; build.sh also copies it to `app/android/build/TV-Remote-RCA.apk`. Without signing variables, direct Gradle release builds are unsigned; build.sh refuses to proceed. No replacement key is generated automatically.

Gradle debug builds retain the workstation's default Android debug key independently. A build made elsewhere will have another key. Keep the release keystore and its credentials privately backed up: losing or replacing them breaks updates to existing installs. Increase the phone versionCode for future releases. Never commit or upload a keystore, ADB key or pairing file.

The original installed test APK's SHA256 was `f7919ef9b5c415f071081ffd6f50fe607009be551e275dffe18704f0242eca99`. That identifies the prior private test artifact, not every future build: the build includes a date and signatures depend on the builder. The source prepared for publication additionally moves the fork label into the main manifest so release builds also use the RCA name.

## Validation — 2026-11-01

Physical setup: RCA / RT2831 / Android 7.1.1 TV and Samsung Android 16 phone. Network addresses, serials, pairing material, screenshots and raw logs are deliberately excluded.

- `:android:assembleDebug`, `:android:testDebugUnitTest` and `:android:lintDebug` passed: 45 phone tests, no failures; the configured NewApi lint check reported no issues. This does not imply all lint categories were checked.
- Repeated force-stop/relaunch and saved-TV reconnection succeeded without the false ADB-off message in those trials.
- Home changed the TV's focused activity from Settings to its OEM launcher, verified from the TV after closing the phone session.
- Volume up changed the TV speaker stream 25 → 26; volume down restored 25, verified from the TV.
- Final controls screenshot was inspected on the real phone; no TV Setup banner or connection error remained.

Publication preparation additionally checked the merged manifest (RCA package and label), staged patch privacy, workflow YAML and flow checker. The manual GitHub workflow has not run yet. Broader local suites are **not all green**: JavaScript reported 493/508 passing, with the same 15 failures reproduced on a pristine checkout of the upstream base on this Windows PC. Shared JVM tests reported 701/712 passing; the 11 failures concern signed-list fixtures and also reproduced when those tests used pristine upstream fixtures. For example, the local launcher JSON differs from its original Git blob only by Windows CRLF conversion, invalidating its byte signature. These are recorded limitations, not suppressed tests or a claim that the full upstream suite passes. Preserve original LF bytes when checking out signed JSON files, for example by cloning with `git -c core.autocrlf=false clone <fork-url>`.

The PC disconnected from the TV's ADB before each phone test and at the end. The upstream app, atvTools and experimental BT Remote remained installed but stopped. Bluetooth HID control did not become functional and is not part of this fork's fix.

Not validated: hours of continuous use, standby/wake, every key/advanced action, other RCA models, or the entire upstream suite on emulators/desktop. Do not claim full upstream feature parity or universal compatibility.

## Maintaining this fork

### First public release validation

For **0.36.1-rca1**, signed JSON files were restored to their exact upstream Git bytes and `.gitattributes` now preserves LF on JSON and shell scripts. `:android:assembleRelease`, `:android:testDebugUnitTest`, `:android:lintRelease` and `:shared:testDebugUnitTest` passed: **45 phone + 712 shared unit tests, zero failures/errors**, and the configured NewApi release lint check reported no issues. The earlier signed-list failures above describe the preparation state before this correction.

The broad JavaScript suite now reports **494/508 passing, 14 failing**; those remaining cases were already among the failures reproduced on pristine upstream on this Windows PC. They concern upstream documentation generation, web/i18n and media/sleep/wake tests. They were not suppressed, and no claim is made that the entire monorepo is green.

The optimized signed release installed in place over versionCode 103600 without clearing data, retained the saved TV, and reports versionCode 103601 without the DEBUGGABLE flag. Reconnection after force-stop worked, and Home from the phone moved the physical TV from Settings to its OEM launcher. A press of the Settings key did not show a Settings transition on this firmware; that button is not claimed validated. Standby/wake and all advanced actions remain unverified. No claim that Bluetooth is fixed.

## Upstream updates

Keep changes on `rca-compat` and the original project as the read-only `upstream` remote. Review upstream changes before merging, particularly session lifecycle and update/install paths. Do not run upstream release/site-deployment scripts for this phone-only fork without reviewing their destinations. The MIT license and attribution must remain with redistributions.
