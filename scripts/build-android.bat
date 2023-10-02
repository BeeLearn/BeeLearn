@echo off


REM Load .env file
cmd /c scripts\load-env.bat

REM Build apk file
flutter build apk --obfuscate --split-per-abi --split-debug-info=debug/info --extra-gen-snapshot-options=--save-obfuscation-map=debug/obfuscation

REM Build app bundle
flutter build appbundle --obfuscate --split-debug-info=debug/info --extra-gen-snapshot-options=--save-obfuscation-map=debug/obfuscation

CMD /c scripts\sentry\upload-debug-files.bat