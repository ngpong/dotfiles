# history
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE
setopt SHARE_HISTORY # Share history between all sessions.
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.
setopt INC_APPEND_HISTORY # Write to the history file immediately, not when the shell exits.
setopt EXTENDED_HISTORY # Expire duplicate entries first when trimming history.
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry.

# 部分终端会的光标会 blink，此方法是禁用 blink
printf '\e[?12l'

# brew
if ! [ -d "/home/linuxbrew/.linuxbrew" ] && ! [ -d "$HOME/.linuxbrew" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
function set_win_title() {
  print -Pn "\e]0;%m@%n:%~\a"
}
precmd_functions+=(set_win_title)
# function set_win_title_preexec() {
#   print -Pn "\e]0;%n:%~:$1\a"
# }
# preexec_functions+=(set_win_title_preexec)

# zsh config
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
setopt RM_STAR_SILENT 
# Fix slowness of pastes with zsh-syntax-highlighting.zsh
# https://gist.github.com/magicdude4eva/2d4748f8ef3e6bf7b1591964c201c1ab
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/513
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# path
export PATH=$PATH:\
/mnt/c/Users/NGPONG/AppData/Local/Programs/'Microsoft VS Code'/bin:\
/mnt/c/Users/NGPONG/scoop/shims:\
/mnt/c/Windows/System32/WindowsPowerShell/v1.0:\

# common env
export BASH_ENV=""
export HOST_IP="127.0.0.1" # $(ipconfig.exe | grep IPv4 | head -1 | rev | awk '{print $1}' | rev | tr -d '\r')
export WSL2_IP="127.0.0.1" # $(hostname -I | awk '{print $1}')
export SOCKS5_ADDR="socks5://$HOST_IP:7890"
export HTTP_ADDR="http://$HOST_IP:7890"
export win_home="/mnt/c/Users/NGPONG/"
export VISUAL=nvim
export GIT_EDITOR=nvim
export EDITOR="$VISUAL"
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"

# core file
ulimit -c unlimited

# custom commands
alias ipinfo="curl http://ip-api.com/json/ | jq"
alias explorer="/mnt/c/Windows/explorer.exe"
alias test_font="echo -e \"\e[1mABCDEFG\e[0m\n\e[3mabcdefgABCDEFG\e[0m\n\e[4munderline\e[0m\n\e[9mstrikethrough\e[0m\""
# https://github.com/neovide/neovide/issues/2689
alias nvid='neovide.exe --wsl --frame none --maximized --no-vsync --no-idle'
alias neovide='nvid'

# delete shortcuts
bindkey "^[p" delete-char
bindkey "^[s" delete-char

# proxy
export all_proxy="$HTTP_ADDR"
export http_proxy="$HTTP_ADDR"
export https_proxy="$HTTP_ADDR"
export ALL_PROXY="$HTTP_ADDR"
export HTTP_PROXY="$HTTP_ADDR"
export HTTPS_PROXY="$HTTP_ADDR"

# git
git config --global http.proxy "$HTTP_ADDR"
git config --global https.proxy "$HTTP_ADDR"
# function setproxy() {
#   export all_proxy="$HTTP_ADDR"
#   export http_proxy="$HTTP_ADDR"
#   export https_proxy="$HTTP_ADDR"
#   export ALL_PROXY="$HTTP_ADDR"
#   export HTTP_PROXY="$HTTP_ADDR"
#   export HTTPS_PROXY="$HTTP_ADDR"
#   
#   # git
#   git config --global http.proxy "$HTTP_ADDR"
#   git config --global https.proxy "$HTTP_ADDR"
#   
#   # declare
#   ipinfo
# }
# function unsetproxy() {
#   unset all_proxy
#   unset http_proxy
#   unset https_proxy
#   unset ALL_PROXY
#   unset HTTP_PROXY
#   unset HTTPS_PROXY
#   
#   # git
#   git config --global --unset http.proxy
#   git config --global --unset https.proxy
#   
#   # declare
#   ipinfo
# }

# fzf
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  export ESCDELAY=0
fi

# eza
if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons=auto"
  alias l="ls"
  alias lt="ls --tree"
  alias ll="ls -lh"
  alias la="ls -a"
  alias lla="ls -lah"
fi

# sytax highlight
if [ -f "$(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
    source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# auto-suggestions
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# auto-complete
# if [ -f "$(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]; then
#     source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
#     DISABLE_MAGIC_FUNCTIONS=true
#     ZSH_AUTOSUGGEST_MANUAL_REBIND=1
#     COMPLETION_WAITING_DOTS=true
#     DISABLE_UNTRACKED_FILES_DIRTY=true
# fi

# golang
# export GO111MODULE=""
# export GOROOT=/usr/local/go
# export GOPATH=$HOME/go
# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:/home/ngpong/.local/bin

# x11
# export DISPLAY=$HOST_IP:0.0

# DISABLE_AUTO_TITLE="true"
# 
# case $TERM in xterm*)
#     precmd () {print -Pn "\e]0;%~\a"}
#     ;;
# esac
