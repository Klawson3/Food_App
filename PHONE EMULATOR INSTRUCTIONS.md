THIS IS FOR WINDOWS - Sam 
I asked Gemini to help me with this. I modified the instrictions based on what worked for me.

If you have the Github\Food_App folder in OneDrive it will mess everything up. Make sure it is not in that folder.

Phase 1: Android Studio

    Go to the official Android Studio website and download the installer.

    Run the installer. Leave all the default boxes checked (especially the one that says Android Virtual Device).

    When it finishes, open Android Studio. It will walk you through a setup wizard. Again, just click "Next" and accept the standard/default installations. It will take a few minutes to download the Android SDK (Software Development Kit).

Phase 2: Create Your Virtual Phone

Once you are on the main welcome screen of Android Studio, we need to build the actual emulator.

    Click on More Actions and select Virtual Device Manager.

    Click the Create Device button.

    Choose Hardware: Pick a phone from the list. A Pixel 7 or Pixel 8 is a great standard choice. (I had to install the "Small Phone" because the resolution of the Pixel 8 was too large for my screen.) Click Next.

    Choose an OS: You will see a list of Android versions (like API 34 or API 35). Click the little "Download" arrow next to one of the recent ones to download the operating system.

    Once downloaded, select it, click Next, and then click Finish.

You now have a digital Android phone sitting on your computer! You can close Android Studio completely; you don't need it open to code.

Phase 3: Launch it from VS Code

Now we just need to tell VS Code to talk to your new digital phone.

    Restart VS Code so it can refresh and detect the new Android tools you just installed.

    Look at the bottom right corner of the blue status bar, exactly where you clicked to select "Chrome" earlier.

    Click it. In the drop-down menu at the top of the screen, you should now see an option that says something like Start Pixel 7 API 34... (or whatever phone you created).

    Click that option. Be patient—the very first time you boot the emulator, it acts like a brand-new phone turning on for the first time and can take a minute or two. (It took so long to set up that flutter disconnected for me last time. )

    Once the phone is on and on the home screen, go to Run > Start Debugging (or press F5) in VS Code.