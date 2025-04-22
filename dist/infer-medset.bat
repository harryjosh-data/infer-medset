@echo off
setlocal

rem Get the directory where this batch file is located
set SCRIPT_DIR=%~dp0

rem Run the Node.js application
node "%SCRIPT_DIR%\index.js"
