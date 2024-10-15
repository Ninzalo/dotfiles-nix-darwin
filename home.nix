{ config, pkgs, ... }:

{
  home.username = "ninzalogg";
  home.homeDirectory = "/Users/ninzalogg";
  home.stateVersion = "24.05";

  home.packages = [
  ];

  home.file = {
    ".config/alacritty".source = ~/dotfiles/alacritty;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/tmux".source = ~/dotfiles/tmux;
    ".config/neofetch".source = ~/dotfiles/neofetch;
    ".config/nix".source = ~/dotfiles/nix;
    ".config/gitmux".source = ~/dotfiles/gitmux;
    ".zshrc".source = ~/dotfiles/zsh/.zshrc;
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
      "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
