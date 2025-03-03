{
  description = "Ninzalo Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, home-manager }:
  let
    configuration = { pkgs, config, ... }: {
      environment.systemPackages =
        [ 
          pkgs.alacritty
          # pkgs.ghostty
          pkgs.mkalias
          pkgs.neovim
          pkgs.tmux
          pkgs.rectangle
          pkgs.ice-bar
          pkgs.fzf
          pkgs.zoxide
          pkgs.lazygit
          pkgs.gnumake
          pkgs.jq
          pkgs.gnused
          pkgs.yarn
          pkgs.git
          pkgs.ripgrep
          pkgs.gnugrep
          pkgs.stow
          pkgs.home-manager
          pkgs.wget
          pkgs.zsh-powerlevel10k
          pkgs.eza
          pkgs.python313
          pkgs.sshpass
          pkgs.poetry
        ];

      homebrew = {
        enable = true;
        casks = [
          "db-browser-for-sqlite"
          "docker"
          "hyperkey"
          "orbstack"
          "ghostty"
        ];
        taps = [
          "arl/arl"
        ];
        brews = [
          "gitmux"
          "node"
          "npm"
          "nmap"
          "pre-commit"
          "python"
          "go"
          "mas"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
        ];
        masApps = {
          "AdGuard" = 1440147259;
          "SponsorBlock" = 1573461917;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
        pkgs.nerd-fonts.hack
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/Messages.app"
          "/System/Applications/Photos.app"
          "/System/Applications/Notes.app"
          "/Applications/Safari.app"
        ];
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
      };

      # services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 5;
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.ninzalogg.home = "/Users/ninzalogg";
      home-manager.backupFileExtension = "backup";
      # nix.configureBuildUsers = true;
      # nix.useDaemon = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbp
    darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "ninzalogg";
          };
        }
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ninzalogg = import ./home.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."mbp".pkgs;
  };
}
