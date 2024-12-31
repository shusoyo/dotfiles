function ns --description home-manager
    set -l flakeHome "$HOME/.config/home-manager/"

    switch $argv[1]
        case e
            $EDITOR $flakeHome
        case s
            home-manager switch --show-trace
        case ds
            darwin-rebuild switch --flake $flakeHome
        case "*"
            y $flakeHome
    end
end
