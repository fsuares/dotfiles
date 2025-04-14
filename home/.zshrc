source $HOME/.antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

# NixOS
alias ns='sudo nixos-rebuild switch'                      # Apply system config
alias nsu='sudo nixos-rebuild switch --upgrade'          # Apply and upgrade

# Clean up
alias nix-clean='sudo nix-collect-garbage -d'            # Delete old generations
alias nix-du='nix path-info -Sh /run/current-system'     # Show size of current system

# Package search & management
alias nix-search='nix search nixpkgs'                    # Search for packages
alias nix-list='nix-env -qaP'                            # List all available packages
alias nix-user='nix-env --query --installed'             # List user-installed packages
alias nix-remove='nix-env --uninstall'                   # Uninstall a user package

# Config & rebuild
alias nix-conf='sudo nvim /etc/nixos/configuration.nix'  # Edit system config
alias nix-channel-update='sudo nix-channel --update'     # Update channels (non-flakes)

# Purge old & unused
alias nix-purge='sudo nix-collect-garbage -d && nix-env --query --installed | xargs -r nix-env --uninstall' # Clean old gens and unreferenced pkgs

# Home Manager
alias hm='home-manager switch'                           # Apply Home Manager config
alias hmc='nvim ~/.config/home-manager/home.nix'         # Edit Home Manager config

# System & services
alias journal='journalctl -xe'                           # View logs
alias services='systemctl list-units --type=service'     # List running services
alias reboot='systemctl reboot'                          # Reboot system

# Navigation
alias eza="eza --color=always"
alias l='eza -lh --icons'
alias ll='eza -lha --icons'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkcd='function _mkcd(){ mkdir -p "$1" && cd "$1"; }; _mkcd'

# Terminal shortcuts
alias c='clear'
alias vim='nvim'
alias top='bashtop'
alias yt-aud='yt-dlp -x --audio-format mp3 --embed-metadata --embed-thumbnail --add-metadata -P $HOME/Music'
alias yt-vide='yt-dlp --add-metadata --embed-metadata --embed-thumbnail -P $HOME/Videos/'

# Git
alias gcl='git clone'
alias gta='git add'
alias gct='git commit'
alias gl='git log'
alias glo='git log --oneline'
alias gst='git status'

# Path export
export PATH=$PATH:/usr/local/bin
export PATH="$HOME/.local/bin:$PATH"

