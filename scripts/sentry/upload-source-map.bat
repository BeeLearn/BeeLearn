@echo off
for /f "tokens=1,* delims==" %%a in (.env) do (
    set "%%a=%%b"
)

REM upload source map to sentry
dart run sentry_dart_plugin