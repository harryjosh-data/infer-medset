@echo off
setlocal enabledelayedexpansion

:: Silent installer and launcher for infer-medset
:: This automatically installs infer-medset and adds it to your PATH

:: Create app directory in user profile
set "APP_DIR=%USERPROFILE%\.infer-medset"
if not exist "%APP_DIR%" mkdir "%APP_DIR%"

:: Create batch launcher in user bin directory
set "BIN_DIR=%USERPROFILE%\bin"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

:: Create the app.js file
(
echo //Automatically generated file
echo import inquirer from 'inquirer';
echo import open from 'open';
echo import { readFileSync } from 'fs';
echo import { fileURLToPath } from 'url';
echo import { dirname, resolve } from 'path';
echo.
echo // Get the package.json path and read version information
echo const __filename = fileURLToPath(import.meta.url^);
echo const __dirname = dirname(__filename^);
echo.
echo // ANSI color codes for console output
echo const colors = {
echo   info(message^) { return `\x1b[32m${message}\x1b[0m`; }, // Green
echo   warn(message^) { return `\x1b[33m${message}\x1b[0m`; }, // Yellow
echo   error(message^) { return `\x1b[31m${message}\x1b[0m`; }, // Red
echo   banner(message^) { return `\x1b[36m${message}\x1b[0m`; } // Cyan
echo };
echo.
echo // Handle command line arguments
echo const args = process.argv.slice(2^);
echo if (args.includes('--version'^) ^|^| args.includes('-v'^)^) {
echo   console.log('infer-medset v1.0.2'^);
echo   process.exit(0^);
echo }
echo.
echo // Function to generate ASCII banner with appropriate terminal size
echo function renderBanner(^) {
echo   const banner = `
echo ███╗   ███╗███████╗██████╗                                        
echo ████╗ ████║██╔════╝██╔══██╗                                       
echo ██╔████╔██║█████╗  ██║  ██║                                       
echo ██║╚██╔╝██║██╔══╝  ██║  ██║                                       
echo ██║ ╚═╝ ██║███████╗██████╔╝                                       
echo ╚═╝     ╚═╝╚══════╝╚═════╝                                        
echo                                                                   
echo ██████╗  █████╗ ████████╗ █████╗ ███████╗███████╗████████╗███████╗
echo ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔════╝
echo ██║  ██║███████║   ██║   ███████║███████╗█████╗     ██║   ███████╗
echo ██║  ██║██╔══██║   ██║   ██╔══██║╚════██║██╔══╝     ██║   ╚════██║
echo ██████╔╝██║  ██║   ██║   ██║  ██║███████║███████╗   ██║   ███████║
echo ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚══════╝
echo `;
echo.
echo   return colors.banner(banner^);
echo }
echo.
echo // Function to prompt user to press Enter to exit or Esc to go back
echo function waitForUserInput(^) {
echo   return new Promise((resolve^) =^> {
echo     process.stdin.setRawMode(true^);
echo     process.stdin.resume(^);
echo     process.stdin.on('data', (data^) =^> {
echo       // Enter key or CTRL+C
echo       if (data[0] === 13 ^|^| data[0] === 3^) {
echo         process.stdin.setRawMode(false^);
echo         process.stdin.pause(^);
echo         resolve(^);
echo       }
echo     }^);
echo     console.log('\nPress Enter to exit...'^);
echo   }^);
echo }
echo.
echo // Clear screen before rendering
echo function clearScreen(^) {
echo   // Clear the terminal screen
echo   process.stdout.write('\x1Bc'^);
echo }
echo.
echo // Main function
echo async function main(^) {
echo   clearScreen(^);
echo   console.log(renderBanner(^)^);
echo.
echo   try {
echo     const answer = await inquirer.prompt([
echo       {
echo         type: 'list',
echo         name: 'action',
echo         message: 'What would you like to do?',
echo         choices: [
echo           {
echo             name: '🔍 Explore Datasets',
echo             value: 'explore'
echo           },
echo           {
echo             name: '📊 Access Datasets',
echo             value: 'access'
echo           },
echo           {
echo             name: '🚪 Exit',
echo             value: 'exit'
echo           }
echo         ]
echo       }
echo     ]^);
echo.
echo     switch (answer.action^) {
echo       case 'explore':
echo         try {
echo           // Open the explore URL in the default browser
echo           await open('https://link.datamaster.tech/main'^);
echo           console.log(colors.info('✓ Opened Explore Datasets in your browser.'^)^);
echo         } catch (error^) {
echo           console.error(colors.error('✗ Failed to open browser.'^)^);
echo           console.error(colors.error('Please visit: https://link.datamaster.tech/main'^)^);
echo         }
echo         break;
echo       case 'access':
echo         try {
echo           // Open the access URL in the default browser
echo           await open('https://link.datamaster.tech/lsqzy'^);
echo           console.log(colors.info('✓ Opened Access Datasets in your browser.'^)^);
echo         } catch (error^) {
echo           console.error(colors.error('✗ Failed to open browser.'^)^);
echo           console.error(colors.error('Please visit: https://link.datamaster.tech/lsqzy'^)^);
echo         }
echo         break;
echo       case 'exit':
echo         break;
echo     }
echo.
echo     if (answer.action !== 'exit'^) {
echo       await waitForUserInput(^);
echo     }
echo     
echo     console.log(colors.info('✨ Thank you for using Med Datasets! ✨'^)^);
echo   } catch (error^) {
echo     console.error(colors.error('✗ An error occurred:'^), error^);
echo   }
echo }
echo.
echo // Run the application
echo main(^);
) > "%APP_DIR%\app.js"

:: Create package.json
(
echo {
echo   "name": "infer-medset",
echo   "version": "1.0.2",
echo   "description": "CLI tool for accessing Med Datasets",
echo   "main": "app.js",
echo   "type": "module",
echo   "dependencies": {
echo     "inquirer": "^9.2.12",
echo     "open": "^10.0.3"
echo   }
echo }
) > "%APP_DIR%\package.json"

:: Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Error: Node.js is not installed.
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

:: Install Node.js modules silently
cd "%APP_DIR%" && npm install --quiet --no-fund --no-audit > nul 2>&1

:: Create the launcher batch file
(
echo @echo off
echo cd "%APP_DIR%" ^&^& node app.js %%*
) > "%BIN_DIR%\infer-medset.bat"

:: Add bin directory to PATH if needed
set "PATH_KEY=HKCU\Environment"
for /f "tokens=2*" %%A in ('reg query "%PATH_KEY%" /v Path ^| findstr Path') do set "CURRENT_PATH=%%B"
if not "%CURRENT_PATH:bin=%" == "%CURRENT_PATH%" (
    rem Already in PATH
) else (
    reg add "%PATH_KEY%" /v Path /t REG_EXPAND_SZ /d "%CURRENT_PATH%;%BIN_DIR%" /f > nul 2>&1
    setx PATH "%PATH%;%BIN_DIR%" > nul 2>&1
    set "PATH=%PATH%;%BIN_DIR%"
)

:: Create a desktop shortcut for convenience
(
echo Set WshShell = CreateObject("WScript.Shell"^)
echo strDesktop = WshShell.SpecialFolders("Desktop"^)
echo Set oShellLink = WshShell.CreateShortcut(strDesktop ^& "\Med Datasets.lnk"^)
echo oShellLink.TargetPath = "%BIN_DIR%\infer-medset.bat"
echo oShellLink.WorkingDirectory = "%BIN_DIR%"
echo oShellLink.Description = "Med Datasets CLI"
echo oShellLink.Save
) > "%TEMP%\create_shortcut.vbs"
cscript //nologo "%TEMP%\create_shortcut.vbs"
del "%TEMP%\create_shortcut.vbs"

:: Run the application immediately
echo Installation successful! Running Med Datasets...
call "%BIN_DIR%\infer-medset.bat"
