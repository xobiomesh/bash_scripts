

fc() {
  local selected=$(history | fzf --tac --height=80% --border --preview 'echo {}' --preview-window=down:wrap:18% --color=16,bg+:#1d1f21,fg+:#c5c8c6,hl+:#f0c674 --prompt="Select command: " | sed "s/^[ ][0-9]\+[ ]//")
  
  if [[ -z "$selected" ]]; then
    echo -e "\033[31mNo command selected. Exiting.\033[0m"
    return
  fi
  
  echo -e "\033[33mSelected command:\033[0m $selected"
  read -p $'\033[36mModify command:\033[0m ' -e -i "$selected" modified
  
  if [[ -z "$modified" ]]; then
    echo -e "\033[31mNo command to execute. Exiting.\033[0m"
    return
  fi
  
  echo -n "$modified" | xclip -selection clipboard
  history -s "$modified"
  eval "$modified"
}

# Add the function to your shell's startup file, such as ~/.bashrc or ~/.zshrc

