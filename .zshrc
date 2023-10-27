# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/vim"

# Load and initialise completion system
autoload -Uz compinit
compinit

# ASDF
. "$HOME/.asdf/asdf.sh"

bindkey "^F" forward-word
bindkey "^B" backward-word
export VI_MODE_ESC_INSERT="<Esc>"
