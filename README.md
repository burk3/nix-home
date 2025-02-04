# a home-manager setup for workstations and headless stuff.

As I move more and more dotfiles into home-manager, I want to be able to deploy in lots of places. This is both boxes with a monitor and without.

This is designed to be used in `flakes.nix` for its `homeManagerModules`.

## Modules
Once cloned and put where **home-manager** is expecting, empty files in the `flags` dir will control some features of the configuration. For example, to enable the management of some GUI applications on a machine with a monitor, simply `touch flags/GUI` and some fun programs will be installed/configured!

### gui
Installs some terminals, media programs, and other things that wouldn't be core to a full desktop environment. Options for terminal emulators abound.

### hypr
Mostly configured [hyprland](https://hyprland.org/) setup. You'll need hyprland installed on the system so it shows up as a valid session in your login thing. I use GDM for logging in and session selection. I also tend to have Gnome installed at the OS level as a fallback in case I really need a more "normal" desktop experience for something.

This also includes stuff I generally want working for any desktop environment, like `gnome-keyring` and setup to make it work as an ssh agent. I guess this flag could probably be named "desktop" or something like that.

### wsl
Bring the Windows ssh-agent into here. Expects you to have the following on the Windows side:
1. Remove the ssh client/server installed as a WindowsCapability.
    ```powershell
    Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    ```
2. `winget install Microsoft.OpenSSH.Beta` or whatever the correct OpenSSH is for you.
3. `winget install albertony.npiperelay` to install the magic that forwards the Agent into WSL.
4. Make sure `ssh-agent` service is running in windows
    ```powershell
    Get-service -Name ssh-agent | Set-Service -StartupType Automatic
    Start-Service ssh-agent
    ```

After applying this module and maybe re-logging to get the corrent env, you should be able to `ssh-add -L` and see your keys from your windows ssh-agent.
