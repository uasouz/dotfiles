#!/bin/bash

# Dotfiles Installer Script

# Define variables
DOTFILES_DIR="."
VIM_CONFIG="$DOTFILES_DIR/vim"
ALACRITTY_CONFIG="$DOTFILES_DIR/alacritty"
LUNARVIM_REPO="https://github.com/LunarVim/LunarVim.git"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Zsh if not already installed
install_zsh() {
    if ! command_exists zsh; then
        echo "Installing Zsh..."
        # Install Zsh based on your OS package manager
        sudo apt install -y zsh

	chsh -s $(which zsh)
    else
        echo "Zsh is already installed."
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

# Function to install Curl if not already installed
install_curl() {
    if ! command_exists curl; then
        echo "Installing curl..."
        # Install Curl based on your OS package manager
        sudo apt install -y curl
    else
        echo "Curl is already installed."
    fi
}

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

# Function to install Node.js using NVM if not already installed
install_node() {
    if ! command_exists node; then
        echo "Installing Node.js using NVM..."
        
        # Install NVM if not already installed
        if ! command_exists nvm; then
            echo "Installing NVM..."
            # Install NVM
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
            # Activate NVM in the current shell session
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

            # Check if NVM exports are present in .zshrc, if not, add them
            if ! grep -q "NVM_DIR" ~/.zshrc; then
                echo -e '\n# Add NVM and NPM exports\nexport NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"\n[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"\n' >> ~/.zshrc
            fi
        else
            echo "NVM is already installed."
        fi

        # Install Node.js LTS version using NVM
        nvm install --lts
    else
        echo "Node.js is already installed."
    fi
}


# Function to install Vim and set up configurations
install_neovim() {
    if ! command_exists nvim; then
   	 echo "Installing Neovim..."
    	sudo apt-get update
    	sudo apt-get -y install neovim

    	echo "Setting up Vim configurations..."
    	# Copy Vim configurations to appropriate location
    	# cp -r "$VIM_CONFIG" ~/.vim
    	cp "$VIM_CONFIG/.vimrc" ~/
    else
	    echo "Neovim is already installed."
    fi
}

# Function to install Tmux and set up configurations
install_tmux() {
    if ! command_exists tmux; then
        echo "Installing Tmux..."
        # Install Tmux based on your OS package manager
	sudo apt-get install -y tmux
    else
        echo "Tmux is already installed."
    fi
    echo "Setting up Tmux configurations..."
    # Copy Tmux configurations to appropriate location
    cp "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf
}

install_lazygit() {
    if ! command_exists lazygit; then
	echo "Installing lazygit"

	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	rm lazygit.tar.gz
	rm lazygit

    else
	echo "Lazygit is already installed."
    fi
}

# Function to install Alacritty and set up configurations
install_alacritty() {
    echo "Installing Alacritty..."
    # Commands to install Alacritty based on your OS package manager

    echo "Setting up Alacritty configurations..."
    mkdir -p ~/.config/alacritty
    # Copy Alacritty configurations to appropriate location
    cp -r "$ALACRITTY_CONFIG" ~/.config/alacritty
}

install_alacritty_themes() {
    if ! test -d ~/.config/alacritty/themes; then
	echo "Installing Alacritty Themes"
    	# We use Alacritty's default Linux config directory as our storage location here.
    	mkdir -p ~/.config/alacritty/themes
    	git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
    else
	echo "Alacritty themes already installed."
    fi
}

# Function to install Rust if not already installed
install_rust() {
    if ! command_exists rustup; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        echo "Rust is already installed."
    fi
}

# Function to install Go if not already installed
install_golang() {
    if ! command_exists go; then
        echo "Installing Go..."
        # Commands to install Go based on your OS package manager
    else
        echo "Go is already installed."
    fi
}

# Function to install LunarVim
install_lunarvim() {
    echo "Installing LunarVim..."
    # Clone LunarVim repository
    git clone --branch rolling "$LUNARVIM_REPO" ~/.config/nvim
    # Install LunarVim
    bash ~/.config/nvim/utils/installer/install.sh
}

# Main function to execute installation steps
main() {
    install_curl
    install_zsh
    install_nerd_fonts
    install_oh_my_zsh
    install_neovim
    install_tmux
    install_lazygit
    install_alacritty
    install_alacritty_themes
    install_node
    install_rust
    install_golang
    # install_lunarvim
}

# Execute main function
main

