# Git aliases.
alias gst='git status'
alias gcm='git checkout master'
alias c=clear
alias gp='git push'
alias gcam='git commit -a -m'
alias gpsup="git push --set-upstream origin $(git symbolic-ref -q HEAD | sed -e 's|^refs/heads/||')"
#alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gcb='git checkout -b'

# Cargo watch
alias cw='cargo watch --no-gitignore -i *.scss -i *.ts -i "package*" -x fmt -x clippy -x run'

# npm
alias nrs='npm run start'

# Database migrations
alias mr='diesel migration run'
alias mre='diesel migration redo'
alias ml='diesel migration list'
alias db='psql $DATABASE_URL'

alias p='sudo chown vscode:vscode /vscode/web-ui/* && sudo chown vscode:vscode /vscode/trillian-personality/*'
# Leave a line below or the files will cat together

