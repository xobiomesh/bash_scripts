# GitHub Repository Automation Script Walkthrough

This script automates the process of creating a new GitHub repository, committing local files, and pushing them to GitHub. It ensures secure handling of your GitHub Personal Access Token (PAT) by leveraging Git's credential store.

## Prerequisites

Before using the script, make sure you have the following installed:

1. **Git**: Version control system.
2. **GitHub CLI (gh)**: Command-line interface for GitHub.
3. **A GitHub Personal Access Token (PAT)** with the necessary permissions.

## Initial Setup

1. **Install Git**:
   - Follow the installation instructions for your operating system from the [official Git website](https://git-scm.com/).

2. **Install GitHub CLI (gh)**:
   - Follow the installation instructions from the [official GitHub CLI website](https://cli.github.com/).

3. **Generate a Personal Access Token (PAT)**:
   - Go to [GitHub's Personal Access Tokens page](https://github.com/settings/tokens).
   - Click on "Generate new token".
   - Give your token a descriptive name.
   - Select the scopes you need (at minimum, you'll need `repo`).
   - Click "Generate token".
   - Copy the token and keep it in a safe place.

4. **Configure Git to Use the Credential Store**:
   - Run the following command to configure Git to store credentials securely:
     ```sh
     git config --global credential.helper store
     ```

5. **Perform an Initial Push to Store Your Credentials**:
   - Navigate to any Git repository on your local machine and perform a push operation:
     ```sh
     git push https://github.com/username/repo.git
     ```
   - When prompted, enter your GitHub username.
   - When prompted for a password, enter your PAT.

## Script Usage

1. **Clone the Repository**:
   - Clone this repository to your local machine.

2. **Make the Script Executable**:
   - Navigate to the directory where the script is located and run:
     ```sh
     chmod +x create_new_github_repo.sh
     ```

3. **Run the Script**:
   - Execute the script:
     ```sh
     ./create_new_github_repo.sh
     ```
   - Follow the prompts to create a new GitHub repository, add and commit files, and push them to GitHub.

## Script Details

### Script Functions

1. **check_gh_cli()**:
   - Checks if the GitHub CLI is installed.

2. **check_github_auth()**:
   - Checks if you are authenticated with the GitHub CLI.

3. **create_github_repo()**:
   - Prompts for repository details and creates a new GitHub repository using the GitHub CLI.

4. **git_add_commit()**:
   - Initializes a Git repository (if not already initialized), adds all files to the staging area, and commits them.

5. **git_push()**:
   - Configures the remote origin if not already set and pushes the committed files to GitHub using the stored credentials.

### Notes

- Ensure you replace `$GITHUB_USERNAME` with your actual GitHub username in the script.
- The script securely handles your PAT using Git's credential store.
- The initial setup step ensures your credentials are stored securely and reused for subsequent operations.

## Troubleshooting

- If you encounter issues with authentication, make sure your PAT has the necessary permissions.
- Verify that Git and GitHub CLI are correctly installed and configured on your machine.
