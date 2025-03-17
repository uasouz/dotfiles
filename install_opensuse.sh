#!/bin/bash

# Dotfiles Installer Script for openSUSE

# Function to check if Golang export is in .zshrc or .profile
check_golang_export() {
    local golang_path="/usr/local/go/bin"  # Replace with your Golang installation path

    if [ -f "$HOME/.zshrc" ] && ! grep -q "export PATH=\"\$PATH:$golang_path\"" "$HOME/.zshrc"; then
        echo "Adding Golang export to .zshrc..."
        echo -e "\n# Golang export\nexport PATH=\"\$PATH:$golang_path\"" >> "$HOME/.zshrc"
    elif [ -f "$HOME/.profile" ] && ! grep -q "export PATH=\"\$PATH:$golang_path\"" "$HOME/.profile"; then
        echo "Adding Golang export to .profile..."
        echo -e "\n# Golang export\nexport PATH=\"\$PATH:$golang_path\"" >> "$HOME/.profile"
    else
        echo "Golang export is already present in .zshrc or .profile."
    fi
}

# Define variables
DOTFILES_DIR="."
VIM_CONFIG="$DOTFILES_DIR/vim"
ALACRITTY_CONFIG="$DOTFILES_DIR/alacritty"
NEOVIM_CONFIG="$DOTFILES_DIR/neovim"
TMUX_CONFIG="$DOTFILES_DIR/tmux"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Zsh if not already installed
install_zsh() {
    if ! command_exists zsh; then
        echo "Installing Zsh..."
        sudo zypper install -y zsh
    fi
}

# Function to install necessary packages
install_packages() {
    echo "Installing required packages..."
    sudo zypper install -y vim neovim alacritty git curl wget zsh nodejs go tmux lazygit python3 ripgrep
}

# Function to install Oh My Zsh
install_oh_my_zsh(){
    if [ -d ~/.oh-my-zsh ]; then
	echo "OhMyZSH! already installed!"
    else
	echo "Installing Oh-My-ZSH!"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	cp $DOTFILES_DIR/.zshrc ~/.zshrc
    fi
}

install_nerd_fonts(){
    if fc-list | grep -q JetBrainsMono; then
    	echo "Font already installed."
    else
    	echo "Installing Nerd Font..."

    	mkdir -p ~/.fonts

    	curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz

    	tar -xvf JetBrainsMono.tar.xz -C ~/.fonts

    	rm JetBrainsMono.tar.xz
    fi
}

# Function to install Alacritty CityLights theme
install_alacritty_theme() {
    if [ -d ~/.config/alacritty/citylights.yml ]; then
        echo "Installing Alacritty CityLights theme..."
        mkdir -p "$HOME/.config/alacritty"
        curl -o "$HOME/.config/alacritty/citylights.yml" \
            https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/citylights.yml
        echo "import:
      - ~/.config/alacritty/citylights.yml" >> "$HOME/.config/alacritty/alacritty.yml"
    fi
}

# Function to apply dotfiles
apply_dotfiles() {
    echo "Applying dotfiles..."
    # cp "$VIM_CONFIG/.vimrc" "$HOME/.vimrc"
    mkdir -p "$HOME/.config/alacritty"
    cp "$ALACRITTY_CONFIG/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

    # Copy Neovim configuration
    mkdir -p "$HOME/.config/nvim/lua"
    cp "$NEOVIM_CONFIG/init.lua" "$HOME/.config/nvim/init.lua"
    cp -r "$NEOVIM_CONFIG/lua" "$HOME/.config/nvim/"

    # Copy Tmux configuration
    cp "$TMUX_CONFIG/tmux.conf" "$HOME/.tmux.conf"

    git config --global user.name "Vinícius Lopes"
    git config --global user.email vlopes45@gmail.com
    git config --global pull.rebase true
}

# Main execution
install_packages
install_zsh
install_oh_my_zsh
install_nerd_fonts
install_alacritty_theme
apply_dotfiles

echo "Installation completed!"
