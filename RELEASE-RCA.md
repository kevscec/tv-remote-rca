# TV Remote RCA 0.36.1-rca1

First phone-only compatibility release of this independent [TV Remote fork](https://github.com/kevscec/tv-remote-rca), based on upstream [v0.39.0](https://github.com/HoangTran0410/tv-remote/releases/tag/v0.39.0) / phone component 0.36.0. MIT attribution is retained. This is not an upstream official release.

## Download and install

- Download **TV-Remote-RCA.apk** and install it on an **Android phone**, not the TV. Android 5.0 / API 21 or newer; universal APK includes arm64-v8a, armeabi-v7a and x86_64.
- Package: `dev.tvremote.phone.rca`; version: `0.36.1-rca1`; versionCode: `103601`. It can coexist with the original app.
- The signed release retains the initial local RCA test installation's certificate, so it updates that installation without clearing its data. Other builders' debug APKs may have different certificates.
- Connect the phone and TV to the same trusted local network. Enable and authorize the TV's ADB connection. Disconnect PC ADB and other ADB remotes while using this app on the affected RCA firmware.
- Updates are manual from this fork's Releases page. Original Downloader codes and download links in the inherited documentation install upstream instead.

## What changed

- Avoid automatic saved-TV ADB status sessions and background Manage preparation that conflicted with remote control on the tested old RCA / Realtek RT2831 firmware.
- Start with mirroring off, hide the separate mirroring/listening/Manage toolbar buttons, and skip the TV Setup installation prompt.
- Disable upstream phone update checks for this separate package.
- Build a signed, optimized release APK without the DEBUGGABLE flag. Preserve a stable private signing identity for updates; credentials and raw device logs are not distributed.
- Preserve signed JSON files' original LF bytes when checking out on Windows.

## Verification and limits

- Release build, **45 phone + 712 shared unit tests**, and the configured NewApi release lint check passed.
- Physical Samsung Android 16 phone / RCA Realtek RT2831 Android 7.1.1: in-place upgrade retained the saved TV; connection and cold-start reconnection worked; Home moved the TV from Settings to its OEM launcher. Volume up/down was verified on the preceding compatibility test build.
- The broader JavaScript suite is not fully green: 494/508 pass; 14 failures remain from cases reproduced on pristine upstream on this Windows PC. See [LOCAL-RCA.md](LOCAL-RCA.md) for details.
- Long-running stability, standby/wake, every button and advanced action, and other RCA models are not validated. Settings did not show a Settings transition in the release check. Bluetooth HID control was not fixed. This app does not install or replace the TV launcher.
- **picture off** means phone screen mirroring is off; it does not mean the television is off.

## Integrity

**SHA256SUMS** contains the APK's SHA-256. Android signing certificate SHA-256:

```text
5056760554b8b30848b6253ea8de0cbb552dc83763e3504b326db0a07dc4e148
```

This compatibility signer originated with the initial workstation development identity and is intentionally retained for update continuity. The release build itself is not debuggable. No signing keystore or pairing credential is included. Source and signing/build instructions are in [LOCAL-RCA.md](LOCAL-RCA.md); [Spanish instructions](README.es.md) are also available.
