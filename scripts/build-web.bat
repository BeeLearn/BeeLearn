@echo off

flutter --no-color build web --source-maps && cmd /c scripts\sentry\upload-source-map.bat

