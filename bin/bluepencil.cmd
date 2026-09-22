@echo off
setlocal
if defined KUJO_BIN (
  set "KUJO_RUNTIME=%KUJO_BIN%"
) else (
  set "KUJO_RUNTIME=kujo"
)
"%KUJO_RUNTIME%" run "%~dp0..\bluepencil.kujo" -- %*
exit /b %ERRORLEVEL%
