
#!/bin/bash

# Function to check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI is not installed. Please install it and try again."
        exit 1
    else
        echo "GitHub CLI is already installed."
    fi
}

# Function to check GitHub authentication
check_github_auth() {
    if ! gh auth status &> /dev/null; then
        echo "You are not logged in to GitHub CLI. Please log in and try again."
        exit 1
    else
        echo "You are already logged in to GitHub CLI."
    fi
}

# Function to create a new GitHub repository
create_github_repo() {
    read -p "Would you like to use the current directory name as the repository name? (yes/no) " use_current_dir
    if [ "$use_current_dir" == "yes" ]; then
        repo_name=${PWD##*/}
    else
        read -p "Enter the repository name: " repo_name
    fi
    echo "Using repository name: $repo_name"

    read -p "Choose the visibility of the repository (public/private): " visibility

    echo "Running: gh repo create $repo_name --$visibility --source=. --remote=origin"
    gh repo create "$repo_name" --"$visibility" --source=. --remote=origin

    if [ $? -eq 0 ]; then
        echo "GitHub repository named '$repo_name' with $visibility visibility created successfully."
    else
        echo "Failed to create GitHub repository."
        exit 1
    fi
}

# Function to add and commit files to Git
git_add_commit() {
    if [ -d .git ]; then
        echo "Git repository already initialized."
    else
        git init
    fi

    echo "Running: git add ."
    git add .

    echo "Running: git commit -m 'Initial commit'"
    git commit -m 'Initial commit'
}

# Function to push files to GitHub using the credential store
git_push() {
    if ! git remote | grep -q origin; then
        echo "Setting up remote origin..."
        git remote add origin "https://github.com/$GITHUB_USERNAME/$repo_name.git"
    else
        echo "Remote origin already exists."
    fi

    echo "Running: git push -u origin main"
    git push -u origin main
    if [ $? -ne 0 ]; then
        echo "Failed to push files to GitHub. Please check your network settings and try again."
        exit 1
    fi
}

# Main script execution
check_gh_cli
check_github_auth
create_github_repo
git_add_commit
git_push

