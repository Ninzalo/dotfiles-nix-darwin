{ config, pkgs, ... }:

{
  home.username = "ninzalogg";
  home.homeDirectory = "/Users/ninzalogg";
  home.stateVersion = "24.05";

  home.packages = [
  ];

  home.file = {
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/alacritty;
    ".config/nix-darwin".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/nix-darwin;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/nvim;
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/tmux;
    ".config/nix".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/nix;
    ".config/gitmux".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/gitmux;
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/zsh/.zshrc;
    ".p10k.zsh".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/p10k/.p10k.zsh;
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
