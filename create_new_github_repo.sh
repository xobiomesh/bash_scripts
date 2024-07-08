#!/bin/bash

# Checking for GitHub CLI installation
echo "Checking for GitHub CLI installation..."

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null
then
    echo "GitHub CLI is not installed."
    echo "Would you like to install GitHub CLI? (yes/no)"
    read install_answer
    if [[ "$install_answer" == "yes" ]]; then
        echo "Running: sudo apt install gh"
        echo "Installing GitHub CLI..."
        # Install GitHub CLI
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh
        echo "GitHub CLI installed successfully."
    else
        echo "GitHub CLI installation skipped. Exiting script."
        exit 1
    fi
else
    echo "GitHub CLI is already installed."
fi

# Check GitHub authentication
echo "Checking GitHub authentication..."
if ! gh auth status 2>&1 | grep -q 'Logged in to github.com'; then
    echo "You are not logged in to GitHub CLI. Running: gh auth login"
    echo "Please log in."
    gh auth login
else
    echo "You are already logged in to GitHub CLI."
fi

# Prompt for repository name
echo "Would you like to use the current directory name as the repository name? (yes/no)"
read use_dir_name
if [[ "$use_dir_name" == "yes" ]]; then
    repo_name=$(basename "$PWD")
    echo "Using current directory name as repository name: $repo_name"
else
    echo "Enter a custom name for your new GitHub repository:"
    read repo_name
fi

# Prompt for repository visibility
echo "Choose the visibility of the repository (public/private):"
read repo_visibility

# Creating the repository
echo "Running: gh repo create $repo_name --${repo_visibility} --source=. --remote=origin"
echo "Creating a new GitHub repository named '$repo_name' with $repo_visibility visibility..."
gh repo create "$repo_name" --${repo_visibility} --source=. --remote=origin

# Initialize Git if necessary
if [ ! -d ".git" ]; then
    echo "Running: git init"
    echo "Initializing a new Git repository..."
    git init
else
    echo "Git repository already initialized."
fi

# Adding all files to staging
echo "Running: git add ."
echo "Adding all files to Git staging area..."
git add .

# Committing files
echo "Running: git commit -m 'Initial commit'"
echo "Committing files to Git..."
git commit -m "Initial commit"

# Pushing to GitHub
echo "Running: git push -u origin main"
echo "Pushing files to the GitHub repository..."
git push -u origin main

echo "Repository '$repo_name' created and pushed successfully."
