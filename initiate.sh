#! /bin/bash
set -e

# sudo apt update
if [ $UID == '1000' ]; then
    sudo apt update
    sudo apt-get install git xclip tmux ninja-build gettext cmake unzip curl gcc-multilib pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 zsh libssl-dev liblzma-dev npm libsqlite3-dev podman zlib1g-dev libbz2-dev libffi-dev libncurses-dev libreadline-dev -y
else
    apt update
    apt-get install git xclip tmux ninja-build gettext cmake unzip curl gcc-multilib pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 zsh libssl-dev liblzma-dev npm libsqlite3-dev podman zlib1g-dev libbz2-dev libffi-dev libncurses-dev libreadline-dev -y
fi

# RUST (do sistema porque vou precisar de alguns programas vindo do cargo)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly
$HOME/.cargo/bin/cargo install fzf ripgrep exa bat du-dust fd-find procs alacritty

# Lang Tool
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
$HOME/.asdf/bin/asdf plugin add python
$HOME/.asdf/bin/asdf plugin list
$HOME/.asdf/bin/asdf install python latest
$HOME/.asdf/bin/asdf global python latest

# NEOVIM SECTION
neovim_checkpoint=$HOME/checkpoint_initiate
mkdir -p $neovim_checkpoint
if [ -d "$neovim_checkpoint/nvim" ]; then
	git clone https://github.com/neovim/neovim $neovim_checkpoint/neovim
fi
cd $neovim_checkpoint/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
cd $neovim_checkpoint/neovim/build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb


if [ -n "$XDG_CONFIG_HOME" ]; then
    nvim_dir="$XDG_CONFIG_HOME/nvim"
    git clone https://github.com/SamirPonto/init.lua "$XDG_CONFIG_HOME/init.lua"
    
    if [ ! -d "$nvim_dir" ]; then
        mkdir -p "$nvim_dir"
        ln -s "$XDG_CONFIG_HOME/init.lua"/* "$nvim_dir"
        echo "Symbolic link created."
    else
        echo "Directory $nvim_dir already exists. No action taken."
    fi
else
    echo "No XDG_CONFIG_HOME was set. Can we proceed with $HOME/.config folder?"
    read -n 1 answer
    if [ "$answer" == 'Y' ]; then
        git clone https://github.com/SamirPonto/init.lua "$HOME/.config/init.lua"
        nvim_dir="$HOME/.config/nvim"
        mkdir -p "$nvim_dir"
        ln -s "$HOME/.config/init.lua"/* "$nvim_dir"
        echo "Symbolic link created."
    fi
fi

# SHELL (ZSH with Zap)
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

ln -s $PWD/.zshrc $HOME
ln -s $PWD/.tmux.conf $HOME
