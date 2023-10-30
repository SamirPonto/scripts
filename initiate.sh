#! /bin/bash
set -e

# sudo apt update
if [ $UID != '0' ]; then
    sudo apt update
    sudo apt-get install git xclip tmux ninja-build gettext cmake unzip curl gcc-multilib pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 zsh libssl-dev liblzma-dev npm libsqlite3-dev podman zlib1g-dev libbz2-dev libffi-dev libncurses-dev libreadline-dev file -y
else
    apt update
    apt-get install git xclip tmux ninja-build gettext cmake unzip curl gcc-multilib pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 zsh libssl-dev liblzma-dev npm libsqlite3-dev podman zlib1g-dev libbz2-dev libffi-dev libncurses-dev libreadline-dev file -y
fi

# Terminal
# SHELL (ZSH with Zap)
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

# Configuration files
mv $PWD/.zshrc $HOME/.zshrc
mv $PWD/.tmux.conf $HOME/.tmux.conf

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
git clone https://github.com/neovim/neovim $neovim_checkpoint/neovim
cd $neovim_checkpoint/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
if [ $UID != '0' ]; then
    cd $neovim_checkpoint/neovim/build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
else
    cd $neovim_checkpoint/neovim/build && cpack -G DEB && dpkg -i nvim-linux64.deb
fi
rm -rf $neovim_checkpoint

echo "CONFIGURING NVIM"
if [ -n "$XDG_CONFIG_HOME" ]; then
    mkdir -p $XDG_CONFIG_HOME
    nvim_dir="$XDG_CONFIG_HOME/nvim"
    mkdir -p "$nvim_dir"
    
    # Clone the repository into the init.lua directory
    ls $XDG_CONFIG_HOME
    echo 'creating'
    ls $XDG_CONFIG_HOME
    echo 'created'
    cd $XDG_CONFIG_HOME && git clone https://github.com/SamirPonto/init.lua
    echo 'passou'
    
    # Create symbolic links from the contents of init.lua to nvim_dir
    ln -s "$XDG_CONFIG_HOME/init.lua/"* "$nvim_dir/"
fi
