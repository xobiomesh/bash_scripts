git-commit-and-push() {
    # Colors for output
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color

    # Prompt the user for a commit message
    echo -e "\n${BLUE}Enter your commit message:${NC}"
    read commit_message

    # Add a short pause
    sleep 0.5

    # Add all changes and list the files staged
    echo -e "\n${YELLOW}Staging files...${NC}"
    sleep 0.5
    git add . --verbose
    staged_files=$(git status --short)
    echo -e "\n${GREEN}Files staged:${NC}"
    echo -e "${staged_files}"

    # Add a short pause
    sleep 0.5

    # Commit with the provided message
    echo -e "\n${YELLOW}Committing changes...${NC}"
    git commit -m "$commit_message"
    
    # Add a short pause
    sleep 0.5

    # Push to the origin main branch
    echo -e "\n${YELLOW}Pushing to origin main...${NC}"
    push_output=$(git push -u origin main 2>&1)
    push_exit_code=$?

    # Add a short pause
    sleep 0.5

    if [ $push_exit_code -ne 0 ]; then
        if echo "$push_output" | grep -q "src refspec main does not match any"; then
            echo -e "\n${RED}It looks like the 'main' branch doesn't exist.${NC} ${YELLOW}Creating the 'main' branch and pushing...${NC}"
            git branch -M main
            push_output=$(git push -u origin main 2>&1)
        fi
    fi

    # Extract the number of files pushed
    files_pushed=$(echo "$push_output" | grep -oP '^\s+\K[^\s]+')

    echo -e "\n${GREEN}Number of files pushed:${NC} $(echo "$files_pushed" | wc -l)"
    echo -e "\n${GREEN}Push output:${NC}"
    echo -e "$push_output"

    # Add a short pause before finishing
    sleep 0.5
    echo -e "\n${BLUE}Done!${NC}\n"
}

