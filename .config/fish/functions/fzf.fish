function frg --description "rg tui built with fzf and bat"
  # https://news.ycombinator.com/item?id=38471822

  rg --ignore-case --color=always --line-number --no-heading "$argv" |
    fzf --ansi \
        --info 'inline: ' \
        --layout 'reverse' \
        --cycle \
        --scrollbar '┃' \
        --algo 'v1' \
        --highlight-line \
        --multi \
        --keep-right \
        --scroll-off '0' \
        --prompt '  ' \
        --color 'scrollbar:#665c54,info:#504945,marker:#fb4934,border:#504945,spinner:#504945,hl:#fb4934:bold:italic:underline,header:#7c6f64,prompt:#83a598,bg+:#282828,fg+:#ebdbb2,hl+:#fb4934:bold:italic:underline,gutter:#1d2021,pointer:#fb4934' \
        --delimiter ':' \
        --preview "bat --color=always {1} --theme='gruvbox (Dark) (Hard) NDC' --highlight-line {2}" \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
end