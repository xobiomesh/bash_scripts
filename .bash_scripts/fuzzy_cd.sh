
fcd() {
    cd "$(fdfind . --type d --hidden| fzf)"
}
