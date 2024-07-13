
git-new-repo() {


#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
BLUE='\033[0;34m'  # Blue for success
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if GitHub CLI is installed
check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        echo -e "${RED}GitHub CLI is not installed. Please install it and try again.${NC}"
        exit 1
    else
        echo -e "${BLUE}GitHub CLI is already installed.${NC}"
    fi
}

# Function to check GitHub authentication
check_github_auth() {
    if ! gh auth status &> /dev/null; then
        echo -e "${RED}You are not logged in to GitHub CLI. Please log in and try again.${NC}"
        exit 1
    else
        echo -e "${BLUE}You are already logged in to GitHub CLI.${NC}"
    fi
}

# Function to handle .gitignore file
handle_gitignore() {
    if [ ! -f .gitignore ]; then
        echo -e "${YELLOW}No .gitignore file found.${NC}"
        read -p "Would you like to create a .gitignore file? (yes/no) " create_ignore
        if [ "$create_ignore" == "yes" ]; then
            touch .gitignore
            echo -e "${BLUE}.gitignore file created.${NC}"
            # Optionally add common entries to .gitignore here
            echo "*.log" >> .gitignore
            echo "node_modules/" >> .gitignore
            echo "build/" >> .gitignore
            echo ".DS_Store" >> .gitignore
            echo -e "${YELLOW}Added some common patterns to .gitignore.${NC}"
        fi
    else
        echo -e "${BLUE}.gitignore file already exists.${NC}"
    fi
}

# Function to initialize and create a new GitHub repository
create_github_repo() {
    echo -e "${YELLOW}Repository Configuration:${NC}"
    read -p "Would you like to use the current directory name as the repository name? (yes/no) " use_current_dir
    if [ "$use_current_dir" == "yes" ]; then
        repo_name=${PWD##*/}
    else
        read -p "Enter the repository name: " repo_name
    fi
    echo -e "Using repository name: ${BLUE}$repo_name${NC}"

    read -p "Choose the visibility of the repository (public/private): " visibility

    # Ensure .gitignore handling
    handle_gitignore

    # Ensure Git initialization
    if [ ! -d .git ]; then
        echo -e "${YELLOW}Initializing Git repository...${NC}"
        git init
        git_add_commit  # Call to add and commit an initial file if necessary
    fi

    echo -e "Creating GitHub repository..."
    gh repo create "$repo_name" --"$visibility" --source=. --remote=origin

    if [ $? -eq 0 ]; then
        echo -e "${BLUE}GitHub repository named '$repo_name' with $visibility visibility created successfully.${NC}"
    else
        echo -e "${RED}Failed to create GitHub repository.${NC}"
        exit 1
    fi
}

# Function to add and commit files to Git
git_add_commit() {
    echo -e "Staging files..."
    git add .
    echo -e "Creating initial commit..."
    git commit -m 'Initial commit'
}

# Function to push files to GitHub
git_push() {
    if ! git remote | grep -q origin; then
        echo -e "Setting up remote origin..."
        git remote add origin "https://github.com/$GITHUB_USERNAME/$repo_name.git"
    else
        echo -e "${BLUE}Remote origin already exists.${NC}"
    fi

    echo -e "Pushing files to GitHub..."
    git push -u origin main
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to push files to GitHub. Please check your network settings and try again.${NC}"
        exit 1
    fi
}

# Main script execution
check_gh_cli
check_github_auth
create_github_repo
git_add_commit
git_push
}

