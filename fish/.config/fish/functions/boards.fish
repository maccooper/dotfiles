function boards
    set -l board_number $argv[1]

    if test -z "$board_number"
        set -l branch_name (git rev-parse --abbrev-ref HEAD)

        set board_number (echo "$branch_name" | sed -nE 's/^[A-Za-z]+\/[A-Za-z]+-([0-9]+)(-[A-Za-z]+)*$/\1/p')

        if test -z "$board_number"
            echo "Couldn't extract board number from branch name."
            return 1
        end
    end

    set -l url "https://dev.azure.com/EducationPlannerBC/Main/_workitems/edit/$board_number"
    open "$url"  # Use `xdg-open` for Linux or `open` for macOS
end
