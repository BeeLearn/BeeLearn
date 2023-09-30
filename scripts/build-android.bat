@echo off


REM Load .env file
cmd /c scripts\load-env.bat

REM upload debug files
flutter build apk --obfuscate --split-per-abi --split-debug-info=debug/info --extra-gen-snapshot-options=--save-obfuscation-map=debug/obfuscation
flutter build appbundle --obfuscate --split-debug-info=debug/info --extra-gen-snapshot-options=--save-obfuscation-map=debug/obfuscation
sentry-cli debug-files upload debug && sentry-cli upload-proguard
