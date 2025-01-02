function ns --description home-manager
    set -l flakeHome "$HOME/.config/home-manager/"

    switch $argv[1]
        case e
            $EDITOR $flakeHome
        case s
            FLAKE=$flakeHome nh home switch
        case ds
            darwin-rebuild switch --flake $flakeHome
        case cd
            cd $flakeHome
        case "*"
            FLAKE=$flakeHome nh $argv
    end
end
