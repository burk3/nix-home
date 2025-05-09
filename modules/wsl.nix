{ pkgs, ... }:
let
  wslInit = ''
    source /etc/profile.d/nix.sh
    export SSH_AUTH_SOCK=''${HOME}/.ssh/agent.sock
    ss -a | grep -q "''${SSH_AUTH_SOCK}"
    if [ $? -ne 0 ]; then
      rm -f "''${SSH_AUTH_SOCK}"
      ( setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:''${SSH_AUTH_SOCK},fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
    fi
  '';
in {
  programs.zsh.profileExtra = wslInit;
  programs.bash.profileExtra = wslInit;
}

