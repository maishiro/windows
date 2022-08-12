@echo off

for /r C:\inetpub\wwwroot %%f in (*.*) do (
  echo filename = %%f
  cd /d %%~dpf && copy /b %%~nxf+
)

