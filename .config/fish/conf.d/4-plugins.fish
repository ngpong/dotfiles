if status is-interactive
  if not type -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    fisher update
    fisher install edc/bass
  end
  bass source /etc/profile
end