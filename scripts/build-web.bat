@echo off

flutter --no-color build web --source-maps

cmd /c scripts/load-env.cmd

dart run sentry_dart_plugin

