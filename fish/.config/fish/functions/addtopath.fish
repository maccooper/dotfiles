function addToPath
    if not contains $argv[1] $fish_user_paths
        set -Ua fish_user_paths $argv[1]
    end
end

function addToPathFront
    if not contains $argv[1] $fish_user_paths
        set -U fish_user_paths $argv[1] $fish_user_paths
    end
end
