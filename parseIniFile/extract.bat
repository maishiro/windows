@echo off

cd /d %~dp0

for /f "tokens=1,2 delims==" %%a in (configuration.ini) do (
  echo %%a %%b
)

