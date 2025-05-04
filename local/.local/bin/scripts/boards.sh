#!/bin/bash

# Define a function to open the URL with a path parameter
open_azure_board() {
    local board_number="$1"

    if [ -z "$board_number" ]; then
        local branch_name
        branch_name=$(git rev-parse --abbrev-ref HEAD)
        
        board_number=$(echo "$branch_name" | sed -nE 's/^[A-Za-z]+\/[A-Za-z]+-([0-9]+)(-[A-Za-z]+)*$/\1/p')

        if [ -z "$board_number" ]; then
            echo "Couldn't extract board number from branch name."
            return 1
        fi
    fi

    local url="https://dev.azure.com/EducationPlannerBC/Main/_workitems/edit/$board_number"
    echo "Tried to open url: $url"
    open "$url"  # Assuming the `open` command opens URLs in your default browser
}

