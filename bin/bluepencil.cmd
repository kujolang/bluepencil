@echo off
setlocal
if defined KUJO_BIN (
  set "KUJO_RUNTIME=%KUJO_BIN%"
) else if exist "%~dp0..\runtime\kujo.exe" (
  set "KUJO_RUNTIME=%~dp0..\runtime\kujo.exe"
) else (
  set "KUJO_RUNTIME=kujo"
)
"%KUJO_RUNTIME%" run "%~dp0..\bluepencil.kujo" --isolated-imports -- %*
exit /b %ERRORLEVEL%
