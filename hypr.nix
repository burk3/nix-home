# vim: foldmethod=marker
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprsunset
    hyprwall
    hyprshot
    swaybg
    wofi
    brightnessctl
    networkmanagerapplet
  ];

  services.blueman-applet.enable = true;

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
    extraConfig = builtins.readFile ./hyprland.conf;
    # maybe later. this is tedious
    # settings = {
    #   monitor = ",preferred,auto,auto";
    #   "$terminal" = "ghostty";
    #   "$fileManager" = "nautilus";
    #   "$menu" = "wofi --show drun";
    #   "$lock" = "hyprlock";
    #   exec-once = "nm-applet & waybar &";
    #   env = "XCURSOR_SIZE,24";
    #   general = {
    #     gaps_in = 5;
    #     gaps_out = 20;
    #     border_size = 2;
    #     "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    #     "col.inactive_border" = "rgba(595959aa)";
    #     resize_on_border = false;
  };
  # }}}

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
        wallpaper = "/home/burke/Pictures/frieren.jpeg";
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
