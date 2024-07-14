

#!/bin/bash

git-repo-list() {


if [ -z "$GITHUB_TOKEN" ]; then
    echo "GITHUB_TOKEN is not set. Please export your token."
    exit 1
fi

function list_user_repos {
    curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/users/$1/repos | jq -r '.[] | "\(.name) - \(.html_url)"'
}

function list_repo_dirs {
    curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/$1/$2/contents | jq -r '.[].name'
}

function view_repo_tree {
    curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/$1/$2/git/trees/main?recursive=1 | jq -r '.tree | .[] | select(.type == "tree" or .type == "blob") | .path'
}

# Choose GitHub username
username=$(echo -e "xobiomesh\nAnother username" | fzf --prompt="Choose a GitHub username: ")

if [ "$username" == "Another username" ]; then
    read -p "Enter GitHub username: " username
fi

# Choose action
action=$(echo -e "List all repositories for the user\nList directories in a specific repository" | fzf --prompt="Choose an option: ")

if [ "$action" == "List all repositories for the user" ]; then
    repo_selection=$(list_user_repos $username | fzf --prompt="Select a repository: ")
    repo_name=$(echo $repo_selection | awk -F " - " '{print $1}')
    repo_url=$(echo $repo_selection | awk -F " - " '{print $2}')
    echo "Selected repository: $repo_name"
    echo "Repository URL: $repo_url"
    echo $repo_url | xclip -selection clipboard
    echo "The URL has been copied to the clipboard."

    # Choose next action
    next_action=$(echo -e "View repository tree\nExit" | fzf --prompt="Choose an option: ")
    if [ "$next_action" == "View repository tree" ]; then
        view_repo_tree $username $repo_name
    else
        echo "Exiting."
    fi
elif [ "$action" == "List directories in a specific repository" ]; then
    read -p "Enter repository name: " repo
    list_repo_dirs $username $repo
else
    echo "Invalid choice"
fi
}
