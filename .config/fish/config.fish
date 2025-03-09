# fisher
if not type -q fisher
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
  fisher update
  fisher install edc/bass
end
bass source /etc/profile

# brew
if not test -d "/home/linuxbrew/.linuxbrew" && not test -d "$HOME/.linuxbrew"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bass
end
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# PATH
fish_add_path -aP $HOME/.local/bin
fish_add_path -aP /mnt/c/Users/NGPONG/AppData/Local/Programs/'Microsoft VS Code'/bin
fish_add_path -aP /mnt/c/Users/NGPONG/scoop/shims
fish_add_path -aP /mnt/c/Windows/System32/WindowsPowerShell/v1.0

# golang
# set -gx GO111MODULE ""
# set -gx GOROOT /usr/local/go
# set -gx GOPATH $HOME/go
# fish_add_path -aP $GOROOT/bin
# fish_add_path -aP $GOPATH/bin

# utils
set -gx ESCDELAY 0 # fzf <escape> close delay
ulimit -c unlimited # core file

# common env
set -l HOST_IP 127.0.0.1 # $(ipconfig.exe | grep IPv4 | head -1 | rev | awk "{print $1}" | rev | tr -d "\r")
set -l WSL2_IP 127.0.0.1 # $(hostname -I | awk "{print $1}")
set -l SOCKS5_ADDR socks5://$HOST_IP:7890
set -l HTTP_ADDR http://$HOST_IP:7890
set -gx win_home /mnt/c/Users/NGPONG/
set -gx VISUAL nvim
set -gx GIT_EDITOR nvim
set -gx EDITOR $VISUAL

# proxy
set -gx all_proxy $HTTP_ADDR
set -gx http_proxy $HTTP_ADDR
set -gx https_proxy $HTTP_ADDR
set -gx ALL_PROXY $HTTP_ADDR
set -gx HTTP_PROXY $HTTP_ADDR
set -gx HTTPS_PROXY $HTTP_ADDR
if type -q git
  git config --global http.proxy $HTTP_ADDR
  git config --global https.proxy $HTTP_ADDR
end

if status is-interactive
  set -gx COLORTERM truecolor

  # 部分终端会的光标会 blink，此方法是禁用 blink
  printf "\e[?12l"

  # starship
  if type -q starship
    starship init fish | source
  end

  # title
  function fish_title
    echo -n (whoami)@(prompt_hostname) (prompt_pwd)
  end

  # greeting message
  set -U fish_greeting

  # highlight
  set fish_color_command green --bold
  set fish_color_valid_path blue
  set fish_color_param normal
  set fish_color_option normal
  set fish_color_redirection normal
  set fish_color_comment 928374
  set fish_color_keyword red --bold --italics
  set fish_color_end normal
  set fish_color_operator normal
  set fish_color_quote yellow --italics

  # keys
  # https://github.com/fish-shell/fish-shell/blob/master/share/functions/fish_default_key_bindings.fish
  # 1. ctrl+r: 打开历史记录筛选窗
  # 2. ctrl+s: 完成模式下打开搜索窗
  # 3. ctrl+f: 完成 ghost text 或者是选中完成列表中的一项
  # 4. ctrl+a: 光标跳转至行首
  # 5. ctrl+e: 光标跳转至行尾
  # 6. tab/ctrl-n: 选中完成选项的下一项
  # 7. shift-tab/ctrl-p: 选中完成选项的上一项
  # function fish_user_key_bindings
  #   fish_default_key_bindings
  # end
  # 当启用 vi 编辑模式的情况下需要使用到
  # function on_fish_bind_mode --on-variable fish_bind_mode
  #   set --global --export vi_mode_symbol ""
  #   set --local color
  #   set --local char
  #   if test "$fish_key_bindings" = fish_vi_key_bindings
  #     switch $fish_bind_mode
  #       case default
  #         set color red
  #         set symbol N
  #       case insert
  #         set color green
  #         set symbol I
  #       case replace replace_one
  #         set color green
  #         set symbol R
  #       case visual
  #         set color brmagenta
  #         set symbol V
  #       case '*'
  #         set color cyan
  #         set symbol "?"
  #     end
  #     set vi_mode_symbol (set_color --bold $color)"[$symbol]"(set_color normal)
  #   end
  # end

  # custom commands
  alias ipinfo="curl http://ip-api.com/json/ | jq"
  alias explorer="/mnt/c/Windows/explorer.exe"
  alias test_font="echo -e \"\e[1mABCDEFG\e[0m\n\e[3mabcdefgABCDEFG\e[0m\n\e[4munderline\e[0m\n\e[9mstrikethrough\e[0m\""
  # https://github.com/neovide/neovide/issues/2689
  alias nvid="neovide.exe --wsl --frame none --maximized --no-vsync --no-idle"
  alias neovide="nvid"

  # fzf
  if type -q fzf
    fzf --fish | source
  end

  # eza
  if type -q eza
    alias ls="eza --icons=auto"
    alias l="ls"
    alias lt="ls --tree"
    alias ll="ls -lh"
    alias la="ls -a"
    alias lla="ls -lah"
  end

  # x11
  # set -gx DISPLAY $HOST_IP:0.0
end
