# vim: foldmethod=marker
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprsunset
    hyprwall
    hyprshot
    swaybg
    wofi
    brightnessctl
    networkmanagerapplet
    posy-cursors
    # fonts
    iosevka
    (nerdfonts.override { fonts = [ "Ubuntu" ]; })
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [
      "Berkeley Mono"
      "Iosevka"
    ];
  };

  services.blueman-applet.enable = true;
  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };
  # set ssh-agent to use the gnome-keyring socket
  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR:-/run/user/$UID}/keyring/ssh";
  };

  home.pointerCursor = {
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;
    x11.enable = true;
    gtk.enable = true;
    # one day
#    hyprcursor.enable = true;
  };

  # {{{ hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
      #   hy3
    ];
    settings = let
      terminal = "ghostty";
      fileManager = "nautilus";
      menu = "wofi --show drun";
      lock = "loginctl lock-session";
    in {
      # {{{ hyprland.settings
      monitor = ",preferred,auto,auto";
      exec-once = [ "nm-applet &" ];
      env = [ "XCURSOR_SIZE,32" "HYPRCURSOR_SIZE,32" "HYPRCURSOR_THEME,Posy_Cursor_Black" ];
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        active_opacity = "1.0";
        inactive_opacity = "1.0";
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = "0.1696";
        };
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      plugin.hyprexpo = {
        enable_gesture = true;
        columns = 3;
        gaps = 5;
        bg_col = "rgb(111111)";
        workspace_method = "center current";
        gesture_fingers = 3; # 3 or 4
        gesture_distance = 300; # how far is the "max"
        gesture_positive = true; # positive = swipe down. Negative = swipe up.
      };
      master = {
        new_status = "master";
      };
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          tap-to-click = false; # thank god
          tap-and-drag = false;
          clickfinger_behavior = true; # click with 2/3 fingers for right/middle
          scroll_factor = "0.5"; # sloooow down
        };
      };
      gestures = {
        workspace_swipe = true; # bless up, fam
      };
      windowrulev2 = [
        # Ignore maximize requests from apps. You'll probably like this.
        "suppressevent maximize, class:.*"
        # Fix some dragging issues with XWayland
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Return, exec, ${terminal}"
        "$mainMod SHIFT, C, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, E, exec, ${fileManager}"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, ${menu}"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, S, togglesplit," # dwindle
        "$mainMod SHIFT, Z, exec, ${lock}"
        "$mainMod, F, fullscreen"
        "$mainMod SHIFT, F, togglefloating"
        "$mainMod SHIFT, S, exec, hyprshot -m region"
        "$mainMod CONTROL, S, exec, hyprshot -m window"
        "$mainMod ALT , S, exec, hyprshot -m output"
        # Move focus with mainMod + vi move keys
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        # Example special workspace (scratchpad)
        "$mainMod, backslash, togglespecialworkspace, magic"
        "$mainMod SHIFT, backslash, movetoworkspace, special:magic"
        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        # go to sleep when shut
        ", switch:on:Lid Switch, exec, systemctl suspend"
      ];
      # }}} hyprland.settings
    };
  };
  # }}} hyprland

  # {{{ hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };
      listener = [
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyperctl dispatch dpms off";
          on-resume = "hyperctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemcctl suspend";
        }
      ];
    };
  };
  # }}}

  # {{{ waybar
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    # {{{ waybar.settings
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-right = [
          "tray"
          "idle_inhibitor"
          "battery"
          "pulseaudio"
          "clock"
        ];
        modules-center = [
          "hyprland/window"
        ];
        clock = {
          format = "  {:%H:%M   %e %b}";
          on-click = "gnome-calendar";
          today-format = "<b>{}</b>";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "hyprland/submap" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "hyprland/window" = {
          format = "{}";
          max-length = 80;
          min-length = 80;
          tooltip = false;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        cpu = {
          interval = 1;
          format = "{max_frequency}GHz <span color=\"darkgray\">| {usage}%</span>";
          max-length = 15;
          min-length = 15;
          on-click = "kitty -e htop --sort-key PERCENT_CPU";
          tooltip = false;
        };
        network = {
          format-disconnected = "";
          format-ethernet = "{ifname} ";
          format-wifi = "{essid} ({signalStrength}%) ";
          max-length = 50;
          #on-click = "kitty -e 'nmtui'";
        };
        battery = {
          full-at = 90;
          states = {
            warning = 30;
            critical = 15;
          };
        };
        pulseaudio = {
          format = "{volume}% {icon} ";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "🔇  {format_source}";
          format-icons = {
            car = "";
            default = [
              ""
              ""
              ""
            ];
            hands-free = "";
            headphone = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = "🔇 ";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
        tray = {
          icon-size = 15;
          spacing = 10;
        };
      };
    };
    # }}} waybar.settings
    # {{{ waybar.style
    style = ''
      * {
        border: none;
        font-family: Ubuntu Nerd Font, Roboto, Arial, sans-serif;
        font-size: 13px;
        color: #ffffff;
        border-radius: 10px;
      }

      window {
        /*font-weight: bold;*/
      }
      window#waybar {
          background: rgba(0, 0, 0, 0);
      }
      /*-----module groups----*/
      .modules-right {
        background-color: rgba(0,43,51,0.85);
        margin: 2px 10px 0 0;
      }
      .modules-center {
        background-color: rgba(0,43,51,0.85);
        margin: 2px 0 0 0;
      }
      .modules-left {
        margin: 2px 0 0 5px;
        background-color: rgba(0,119,179,0.6);
      }
      /*-----modules indv----*/
      #workspaces button {
        padding: 1px 5px;
        background-color: transparent;
      }
      #workspaces button:hover {
        box-shadow: inherit;
        background-color: rgba(0,153,153,1);
      }

      #workspaces button.active {
        background-color: rgba(0,43,51,0.85);
      }

      # workspaces button.urgent {
        background-color: #bf616a;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #submap,
      #custom-power,
      #custom-menu,
      #idle_inhibitor {
          padding: 0 10px;
      }
      #submap, #mode {
          color: #cc3436;
          font-weight: bold;
      }
      /*-----Indicators----*/
      #idle_inhibitor.activated {
          color: #2dcc36;
      }
      #pulseaudio.muted {
          color: #cc3436;
      }
      #battery.charging {
          color: #2dcc36;
      }
      #battery.warning:not(.charging) {
        color: #e6e600;
      }
      #battery.critical:not(.charging) {
          color: #cc3436;
      }
      #temperature.critical {
          color: #cc3436;
      }
      /*-----Colors----*/
      /*
       *rgba(0,85,102,1),#005566 --> Indigo(dye)
       *rgba(0,43,51,1),#002B33 --> Dark Green
       *rgba(0,153,153,1),#009999 --> Persian Green
       *
       */
    '';
    # }}} waybar.style
  };
  # }}} waybar

  # {{{ hyprpaper
  services.hyprpaper = {
    enable = true;
    settings =
      let
        wallpaper = "${pkgs.pantheon.elementary-wallpapers}/share/backgrounds/Photo of Valley.jpg";
      in
      {
        preload = [
          "${wallpaper}"
        ];
        wallpaper = [
          "eDP-1,${wallpaper}"
        ];
        splash = true;
      };
  };
  # }}} hyprpaper

  # {{{ hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      auth = {
        "fingerprint:enabled" = true;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          fade_on_empty = false;
          shadow_passes = 2;
        }
      ];
    };
  };
  # }}} hyprlock

  # {{{ swaync
  services.swaync = {
    enable = true;
    settings = {
      timeout = 5;
      timeout-low = 2;
      timeout-critical = 0;
      notification-window-width = 300;
    };
  };
  # }}} swaync
}
