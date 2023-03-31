@echo off

@set CUR_DIR=%CD%

for /r C:\inetpub\wwwroot %%f in (*.*) do (
  echo filename = %%f
  cd /d %%~dpf && copy /b %%~nxf+
)

@cd /d %CUR_DIR%
