{ pkgs, ... }:

{
  # Ubuntu Mono patched with Nerd Font glyphs for terminal prompts and editors.
  fonts.packages = [ pkgs.nerd-fonts.ubuntu-mono ];

  # Create /etc/zshrc so Zsh loads the nix-darwin system environment.
  programs.zsh.enable = true;

  system.defaults = {
    dock = {
      # Hide the Dock when it is not in use, with a near-instant reveal.
      autohide = true;
      autohide-delay = 0.05;

      # Place the Dock on the left edge of the screen.
      orientation = "left";

      # Four-finger spread shows Desktop.
      showDesktopGestureEnabled = true;
      # Four-finger swipe up opens Mission Control.
      showMissionControlGestureEnabled = true;

      # Declaratively set the applications pinned in the Dock, in this order.
      persistent-apps = [
        { app = "/Applications/Firefox.app"; }
        { app = "/Applications/Brave Browser.app"; }
        { app = "/System/Applications/Messages.app"; }
        { app = "/System/Applications/FaceTime.app"; }
        { app = "/System/Applications/Mail.app"; }
        { app = "/System/Applications/Calendar.app"; }
        { app = "/System/Applications/Notes.app"; }
        { app = "/System/Applications/System Settings.app"; }
      ];

      # Keep Downloads on the right side of the Dock.
      persistent-others = [
        {
          folder = {
            path = "/Users/marcus/Downloads";

            # Sort newest downloads first.
            arrangement = "date-added";

            # Show a stack preview in the Dock; open it using the fan layout.
            displayas = "stack";
            showas = "fan";
          };
        }
      ];
    };

    finder = {
      # Search the currently open folder rather than all of "This Mac".
      FXDefaultSearchScope = "SCcf";

      # Use icon view for new Finder windows.
      FXPreferredViewStyle = "icnv";

      # Show the item count and available disk space at the bottom of Finder.
      ShowStatusBar = true;

      # Show external and removable drives—but not the internal disk—on Desktop.
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = true;

      # Keep folders above files when sorting by name.
      _FXSortFoldersFirst = true;
    };

    screencapture = {
      # Save screenshots as PNG files.
      type = "png";
    };

    loginwindow = {
      # Do not offer a Guest User account on the login screen.
      GuestEnabled = false;
    };

    NSGlobalDomain = {
      # Use Swedish/metric regional conventions.
      AppleICUForce24HourTime = true;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleTemperatureUnit = "Celsius";

      # Always display filename extensions in Finder.
      AppleShowAllExtensions = true;

      # Use Dark appearance and automatically switch with macOS’s schedule.
      AppleInterfaceStyle = "Dark";
      AppleInterfaceStyleSwitchesAutomatically = true;

      # Keyboard repeat speed; lower values repeat faster.
      KeyRepeat = 2;

      # Use medium-sized sidebar icons in Finder.
      NSTableViewDefaultSizeMode = 2;

      # Keep the text substitutions you currently use.
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = true;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Keep the menu bar permanently visible.
      _HIHideMenuBar = false;

      # Enable spring-loaded folders with a 0.5-second activation delay.
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.5;

      # Keep Force Click enabled and use the default trackpad tracking speed.
      "com.apple.trackpad.forceClick" = true;
      "com.apple.trackpad.scaling" = 1.0;
    };

    CustomUserPreferences = {
      # Hide the Recent Tags section in Finder's sidebar.
      "com.apple.finder".ShowRecentTags = false;
    };

    trackpad = {
      # Tap the trackpad rather than physically clicking.
      Clicking = true;
    
      # Two-finger secondary/right click.
      TrackpadRightClick = true;
    
      # Three fingers drag windows and files. Other three-finger gestures stay off.
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerHorizSwipeGesture = 0;
      TrackpadThreeFingerTapGesture = 0;
      TrackpadThreeFingerVertSwipeGesture = 0;
    
      # Four-finger gestures for Spaces, Mission Control, Desktop, and Launchpad.
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
    
      # Two-finger gestures.
      TrackpadPinch = true; # Zoom
      TrackpadRotate = true; # Rotate supported content
      TrackpadTwoFingerDoubleTapGesture = true; # Smart Zoom
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3; # Notification Center
    
      # Preserve your click and drag behaviour.
      Dragging = false;
      DragLock = false;
      TrackpadCornerSecondaryClick = 0;
      FirstClickThreshold = 1; # Medium click pressure
      SecondClickThreshold = 1; # Medium Force Click pressure
      ActuationStrength = 1; # Silent Clicking disabled
      ActuateDetents = false; # Haptic feedback disabled
      TrackpadMomentumScroll = true;
    };
  };
}
