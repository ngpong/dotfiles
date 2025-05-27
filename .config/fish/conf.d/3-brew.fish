# brew
if not test -d "/home/linuxbrew/.linuxbrew" && not test -d "$HOME/.linuxbrew"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bass
end
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)