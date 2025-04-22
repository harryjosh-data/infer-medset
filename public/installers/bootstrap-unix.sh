#!/bin/bash

# Silent installer and launcher for infer-medset
# This script checks if infer-medset is installed, and if not,
# installs it silently before running it

# Installation directory 
if [ "$(id -u)" -eq 0 ]; then
  # Running as root
  INSTALL_DIR="/usr/local/bin"
else
  # Running as normal user
  INSTALL_DIR="$HOME/.local/bin"
  mkdir -p "$INSTALL_DIR"
  
  # Add to PATH if needed
  if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    if [ -f "$HOME/.bashrc" ]; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ]; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    export PATH="$INSTALL_DIR:$PATH"
  fi
fi

# Check if infer-medset is already installed
if [ ! -f "$INSTALL_DIR/infer-medset" ]; then
  # Not installed, create app directory
  APP_DIR="$HOME/.infer-medset"
  mkdir -p "$APP_DIR"
  
  # Create the app.js file
  cat > "$APP_DIR/app.js" << 'EOF'
#!/usr/bin/env node

import inquirer from 'inquirer';
import open from 'open';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, resolve } from 'path';

// Get the package.json path and read version information
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// ANSI color codes for console output
const colors = {
  info(message) { return `\x1b[32m${message}\x1b[0m`; }, // Green
  warn(message) { return `\x1b[33m${message}\x1b[0m`; }, // Yellow
  error(message) { return `\x1b[31m${message}\x1b[0m`; }, // Red
  banner(message) { return `\x1b[36m${message}\x1b[0m`; } // Cyan
};

// Handle command line arguments
const args = process.argv.slice(2);
if (args.includes('--version') || args.includes('-v')) {
  console.log('infer-medset v1.0.2');
  process.exit(0);
}

// Function to generate ASCII banner with appropriate terminal size
function renderBanner() {
  const banner = `
███╗   ███╗███████╗██████╗                                        
████╗ ████║██╔════╝██╔══██╗                                       
██╔████╔██║█████╗  ██║  ██║                                       
██║╚██╔╝██║██╔══╝  ██║  ██║                                       
██║ ╚═╝ ██║███████╗██████╔╝                                       
╚═╝     ╚═╝╚══════╝╚═════╝                                        
                                                                  
██████╗  █████╗ ████████╗ █████╗ ███████╗███████╗████████╗███████╗
██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔════╝
██║  ██║███████║   ██║   ███████║███████╗█████╗     ██║   ███████╗
██║  ██║██╔══██║   ██║   ██╔══██║╚════██║██╔══╝     ██║   ╚════██║
██████╔╝██║  ██║   ██║   ██║  ██║███████║███████╗   ██║   ███████║
╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚══════╝
`;

  return colors.banner(banner);
}

// Function to prompt user to press Enter to exit or Esc to go back
function waitForUserInput() {
  return new Promise((resolve) => {
    process.stdin.setRawMode(true);
    process.stdin.resume();
    process.stdin.on('data', (data) => {
      // Enter key or CTRL+C
      if (data[0] === 13 || data[0] === 3) {
        process.stdin.setRawMode(false);
        process.stdin.pause();
        resolve();
      }
    });
    console.log('\nPress Enter to exit...');
  });
}

// Clear screen before rendering
function clearScreen() {
  // Clear the terminal screen
  process.stdout.write('\x1Bc');
}

// Main function
async function main() {
  clearScreen();
  console.log(renderBanner());

  try {
    const answer = await inquirer.prompt([
      {
        type: 'list',
        name: 'action',
        message: 'What would you like to do?',
        choices: [
          {
            name: '🔍 Explore Datasets',
            value: 'explore'
          },
          {
            name: '📊 Access Datasets',
            value: 'access'
          },
          {
            name: '🚪 Exit',
            value: 'exit'
          }
        ]
      }
    ]);

    switch (answer.action) {
      case 'explore':
        try {
          // Open the explore URL in the default browser
          await open('https://link.datamaster.tech/main');
          console.log(colors.info('✓ Opened Explore Datasets in your browser.'));
        } catch (error) {
          console.error(colors.error('✗ Failed to open browser.'));
          console.error(colors.error('Please visit: https://link.datamaster.tech/main'));
        }
        break;
      case 'access':
        try {
          // Open the access URL in the default browser
          await open('https://link.datamaster.tech/lsqzy');
          console.log(colors.info('✓ Opened Access Datasets in your browser.'));
        } catch (error) {
          console.error(colors.error('✗ Failed to open browser.'));
          console.error(colors.error('Please visit: https://link.datamaster.tech/lsqzy'));
        }
        break;
      case 'exit':
        break;
    }

    if (answer.action !== 'exit') {
      await waitForUserInput();
    }
    
    console.log(colors.info('✨ Thank you for using Med Datasets! ✨'));
  } catch (error) {
    console.error(colors.error('✗ An error occurred:'), error);
  }
}

// Run the application
main();
EOF

  # Create package.json
  cat > "$APP_DIR/package.json" << 'EOF'
{
  "name": "infer-medset",
  "version": "1.0.2",
  "description": "CLI tool for accessing Med Datasets",
  "main": "app.js",
  "type": "module",
  "dependencies": {
    "inquirer": "^9.2.12",
    "open": "^10.0.3"
  }
}
EOF

  # Install dependencies silently
  (cd "$APP_DIR" && npm install --quiet --no-fund --no-audit > /dev/null 2>&1)

  # Create launcher script
  cat > "$INSTALL_DIR/infer-medset" << EOF
#!/bin/bash
# Generated launcher for infer-medset
cd "$APP_DIR" && node app.js "\$@"
EOF

  # Make launcher executable
  chmod +x "$INSTALL_DIR/infer-medset"
fi

# Run the application
exec "$INSTALL_DIR/infer-medset" "$@"
