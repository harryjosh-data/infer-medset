#!/bin/bash

# Silent global installer for infer-medset
# This script installs infer-medset globally so it can be run from anywhere

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  INSTALL_DIR="/usr/local/bin"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  INSTALL_DIR="/usr/local/bin"
else
  # Windows running Git Bash or similar
  INSTALL_DIR="$HOME/bin"
  mkdir -p "$INSTALL_DIR"
  # Add to PATH if not already there
  if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/bin:$PATH"
  fi
fi

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create the wrapper script
cat > "$INSTALL_DIR/infer-medset" << 'EOF'
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

# Make the wrapper script executable
chmod +x "$INSTALL_DIR/infer-medset"

echo "✅ infer-medset has been installed globally."
echo "You can now run 'infer-medset' from any terminal!"
