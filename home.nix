# home.nix
# home-manager switch 

{ config, pkgs, ... }:

{
  home.username = "ninzalogg";
  home.homeDirectory = "/Users/ninzalogg";
  home.stateVersion = "24.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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
