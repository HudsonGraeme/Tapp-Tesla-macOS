# Tapp
[![Build Status](https://travis-ci.org/HudsonGraeme/Tapp-Tesla-macOS.svg?branch=master)](https://travis-ci.org/HudsonGraeme/Tapp-Tesla-macOS)

Having troubles?

1. "Application downloaded from an unknown source"
Go to System Preferences -> Security [General], and click on "Open Anyway" in the bottom section of the pane.

2. No data or messed up data
  
  This can be caused by: 
    
   A: Your access token has expired. Solution: Press Logout, then log back in.
    
   B: You have more than one Tesla vehicle. Solution: Yell at the developer to include multi vehicle support.
    
   C: Network connection issues. Solution: Connect to the internet.
    
   D: If none of those apply, open an issue.

3. Views reloading every millisecond/strobe effect in applications.

  Close the app right away, I'm in the midst of getting to the bottom of this.

4. "Move 'Tapp.app' to the trash"

This is due to codesigning issues.
Open Terminal

Type `sudo xattr -cr /path/to/tapp.app`
    
After `-cr`, drag and drop Tapp.app into the terminal window for an instant path.

Hit enter and type in your password if propmted.

[Update 1.5]
Login, Logout, new features, bug fixes


All commands currently use https json requests - updated to V1.2 which adds some fun easter eggs and bug fixes. Should be pretty self explanatory.

UserDefaults now saves the access_token for later use. V1.3 will include full Login/Logout features and more battery controls.

Depending upon the amount of updates to the application, the V1.3 release date will likely be in the last week of April. As far as V1.5 and even V2.0, May and June will be the target release dates.
