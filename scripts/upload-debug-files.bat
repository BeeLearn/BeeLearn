@echo off

for /f "tokens=1,* delims==" %%a in (.env) do (
set "%%a=%%b"
)

REM upload debug files to sentry
sentry-cli debug-files upload debug && sentry-cli upload-proguard
