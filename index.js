#!/usr/bin/env node

import inquirer from 'inquirer';
import open from 'open';

// Logger utility to replace direct console statements
const logger = {
  info: (message) => process.stdout.write(`${message}\n`),
  success: (message) => process.stdout.write(`\x1b[32m${message}\x1b[0m\n`), // Green
  warn: (message) => process.stdout.write(`\x1b[33m${message}\x1b[0m\n`),    // Yellow
  error: (message) => process.stdout.write(`\x1b[31m${message}\x1b[0m\n`),   // Red
  banner: (message) => process.stdout.write(`\x1b[34m${message}\x1b[0m`)      // Blue
};

// Function to generate ASCII banner with appropriate terminal size
function renderBanner() {
  // Get terminal size
  const terminalWidth = process.stdout.columns || 80;
  
  // Define the full banner as specified by the user
  const fullBanner = `
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
  
  // Split the banner into lines
  const lines = fullBanner.split('\n');
  
  // Calculate the max width of the banner
  const maxLineWidth = Math.max(...lines.map(line => line.length));
  
  // If terminal is wide enough, display full banner
  if (terminalWidth >= maxLineWidth) {
    logger.banner(fullBanner);
  } else {
    // For narrower terminals, create a scaled banner
    // For simplicity, if the terminal is too narrow, we will show a simplified version
    const simpleBanner = `
=== MED ===
===========
== DATASETS ==
==============
`;
    logger.banner(simpleBanner);
  }
}

// Function to prompt user to press Enter to exit or Esc to go back
async function waitForUserInput() {
  logger.info('\nPress Enter to exit or Esc to return to menu...');
  
  // Set up raw mode to capture individual keystrokes
  process.stdin.setRawMode(true);
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  
  return new Promise(resolve => {
    const onKeyPress = (key) => {
      // Ctrl+C or 'q' to force quit
      if (key === '\u0003' || key === 'q') {
        process.stdin.removeListener('data', onKeyPress);
        process.stdin.setRawMode(false);
        process.stdin.pause();
        process.exit(0);
      }
      // Enter key
      else if (key === '\r' || key === '\n') {
        process.stdin.removeListener('data', onKeyPress);
        process.stdin.setRawMode(false);
        process.stdin.pause();
        resolve('exit');
      }
      // Escape key
      else if (key === '\u001b') {
        process.stdin.removeListener('data', onKeyPress);
        process.stdin.setRawMode(false);
        process.stdin.pause();
        resolve('back');
      }
    };
    
    process.stdin.on('data', onKeyPress);
  });
}

// Clear screen before rendering
function clearScreen() {
  process.stdout.write('\x1Bc');
}

async function main() {
  // Clear screen and render adaptive banner
  clearScreen();
  renderBanner();
  while (true) {
    const answer = await inquirer.prompt([
      {
        type: 'list',
        name: 'action',
        message: 'What would you like to do?',
        choices: ['🔍 Explore Datasets', '📂 Access Datasets', '👥 Follow Us', '🚪 Exit']
      }
    ]);
    
    // Remove emojis for switch statement comparison
    const action = answer.action.replace(/^[^\s]+ /, '');

    switch (action) {
      case 'Explore Datasets':
        logger.success('🔍 Opening the data explorer...');
        await open('https://link.datamaster.tech/main');
        const exploreResult = await waitForUserInput();
        if (exploreResult === 'exit') {
          logger.warn('✨ Thank you for using Med Datasets! ✨');
          process.exit(0);
        }
        // If 'back', the loop will continue
        break;
      case 'Access Datasets':
        logger.success('📂 Opening the data access portal...');
        await open('https://link.datamaster.tech/lsqzy');
        const accessResult = await waitForUserInput();
        if (accessResult === 'exit') {
          logger.warn('✨ Thank you for using Med Datasets! ✨');
          process.exit(0);
        }
        // If 'back', the loop will continue
        break;
        
      case 'Follow Us':
        // Display social media submenu
        const socialAnswer = await inquirer.prompt([
          {
            type: 'list',
            name: 'socialPlatform',
            message: 'Connect with us on:',
            choices: ['HuggingFace', 'Kaggle', 'ProductHunt', 'LinkedIn', '↩️ Back to main menu']
          }
        ]);
        
        // Handle social media selection
        const platform = socialAnswer.socialPlatform.replace(/^[^\s]+ /, '');
        
        switch(platform) {
          case 'HuggingFace':
            logger.success('Opening HuggingFace profile...');
            await open('https://link.datamaster.tech/huggingface');
            break;
          case 'Kaggle':
            logger.success('Opening Kaggle profile...');
            await open('https://link.datamaster.tech/kaggle');
            break;
          case 'ProductHunt':
            logger.success('Opening ProductHunt profile...');
            await open('https://link.datamaster.tech/producthunt');
            break;
          case 'LinkedIn':
            logger.success('Opening LinkedIn profile...');
            await open('https://link.datamaster.tech/linkedin');
            break;
          case 'Back to main menu':
            // Do nothing, just go back to main loop
            break;
        }
        
        // If not returning to main menu, wait for input
        if (platform !== 'Back to main menu') {
          const socialResult = await waitForUserInput();
          if (socialResult === 'exit') {
            logger.warn('✨ Thank you for using Med Datasets! ✨');
            process.exit(0);
          }
        }
        break;
      case 'Exit':
        logger.warn('✨ Thank you for using Med Datasets! ✨');
        process.exit(0);
    }
  }
}

// Run the application
main();
