@echo off
setlocal enabledelayedexpansion

:: Silent global installer for infer-medset (Windows)
:: This installs infer-medset globally so it can be run from anywhere

:: Create installation directory in Program Files
set "INSTALL_DIR=%ProgramFiles%\infer-medset"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Create the infer-medset.js script file
echo @echo off > "%INSTALL_DIR%\infer-medset.bat"
echo node "%INSTALL_DIR%\infer-medset.js" %%* >> "%INSTALL_DIR%\infer-medset.bat"

:: Create the Node.js script
(
echo #!/usr/bin/env node
echo.
echo import inquirer from 'inquirer';
echo import open from 'open';
echo import { readFileSync } from 'fs';
echo import { fileURLToPath } from 'url';
echo import { dirname, resolve } from 'path';
echo.
echo // Get the package.json path and read version information
echo const __filename = fileURLToPath^(import.meta.url^);
echo const __dirname = dirname^(__filename^);
echo.
echo // ANSI color codes for console output
echo const colors = {
echo   info^(message^) { return `\x1b[32m${message}\x1b[0m`; }, // Green
echo   warn^(message^) { return `\x1b[33m${message}\x1b[0m`; }, // Yellow
echo   error^(message^) { return `\x1b[31m${message}\x1b[0m`; }, // Red
echo   banner^(message^) { return `\x1b[36m${message}\x1b[0m`; } // Cyan
echo };
echo.
echo // Handle command line arguments
echo const args = process.argv.slice^(2^);
echo if ^(args.includes^('--version'^) ^|^| args.includes^('-v'^)^) {
echo   console.log^('infer-medset v1.0.2'^);
echo   process.exit^(0^);
echo }
echo.
echo // Function to generate ASCII banner with appropriate terminal size
echo function renderBanner^(^) {
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
echo   return colors.banner^(banner^);
echo }
echo.
echo // Function to prompt user to press Enter to exit or Esc to go back
echo function waitForUserInput^(^) {
echo   return new Promise^(^(resolve^) =^> {
echo     process.stdin.setRawMode^(true^);
echo     process.stdin.resume^(^);
echo     process.stdin.on^('data', ^(data^) =^> {
echo       // Enter key or CTRL+C
echo       if ^(data[0] === 13 ^|^| data[0] === 3^) {
echo         process.stdin.setRawMode^(false^);
echo         process.stdin.pause^(^);
echo         resolve^(^);
echo       }
echo     }^);
echo     console.log^('\nPress Enter to exit...'^);
echo   }^);
echo }
echo.
echo // Clear screen before rendering
echo function clearScreen^(^) {
echo   // Clear the terminal screen
echo   process.stdout.write^('\x1Bc'^);
echo }
echo.
echo // Main function
echo async function main^(^) {
echo   clearScreen^(^);
echo   console.log^(renderBanner^(^)^);
echo.
echo   try {
echo     const answer = await inquirer.prompt^([
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
echo     switch ^(answer.action^) {
echo       case 'explore':
echo         try {
echo           // Open the explore URL in the default browser
echo           await open^('https://link.datamaster.tech/main'^);
echo           console.log^(colors.info^('✓ Opened Explore Datasets in your browser.'^)^);
echo         } catch ^(error^) {
echo           console.error^(colors.error^('✗ Failed to open browser.'^)^);
echo           console.error^(colors.error^('Please visit: https://link.datamaster.tech/main'^)^);
echo         }
echo         break;
echo       case 'access':
echo         try {
echo           // Open the access URL in the default browser
echo           await open^('https://link.datamaster.tech/lsqzy'^);
echo           console.log^(colors.info^('✓ Opened Access Datasets in your browser.'^)^);
echo         } catch ^(error^) {
echo           console.error^(colors.error^('✗ Failed to open browser.'^)^);
echo           console.error^(colors.error^('Please visit: https://link.datamaster.tech/lsqzy'^)^);
echo         }
echo         break;
echo       case 'exit':
echo         break;
echo     }
echo.
echo     if ^(answer.action !== 'exit'^) {
echo       await waitForUserInput^(^);
echo     }
echo     
echo     console.log^(colors.info^('✨ Thank you for using Med Datasets! ✨'^)^);
echo   } catch ^(error^) {
echo     console.error^(colors.error^('✗ An error occurred:'^), error^);
echo   }
echo }
echo.
echo // Run the application
echo main^(^);
) > "%INSTALL_DIR%\infer-medset.js"

:: Install Node.js dependencies
cd "%INSTALL_DIR%"
echo {"type":"module","dependencies":{"inquirer":"^9.2.12","open":"^10.0.3"}} > package.json
call npm install --quiet --no-fund --no-audit

:: Add to PATH
set "PATH_KEY=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
for /f "tokens=2*" %%A in ('reg query "%PATH_KEY%" /v Path ^| findstr Path') do set "CURRENT_PATH=%%B"
if not "!CURRENT_PATH:infer-medset=!" == "!CURRENT_PATH!" (
    echo Path already updated
) else (
    reg add "%PATH_KEY%" /v Path /t REG_EXPAND_SZ /d "%CURRENT_PATH%;%INSTALL_DIR%" /f
)

echo Installation complete. You can now run 'infer-medset' from any terminal!
echo Please restart your terminal for the PATH changes to take effect.
