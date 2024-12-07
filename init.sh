brew install zsh
brew install stow
brew install ripgrep
brew install unzip
brew install gcc
brew install make
brew install fzf
brew install tmux
brew install neovim
brew install --cask wezterm

chsh -s $(which zsh)

stow nvim
stow p10k
stow tmux
stow wezterm
stow zsh
