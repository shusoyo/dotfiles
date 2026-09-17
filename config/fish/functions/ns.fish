function ns --description "Helper for managing dotfiles with nh"
    set -l flakeHome "$NH_FLAKE"
    if test -z "$flakeHome"
        set flakeHome "$HOME/.config/dotfiles"
    end
    set -x NH_FLAKE $flakeHome

    switch $argv[1]
        case e
            $EDITOR $flakeHome
        case sh
            nh home switch
        case sn
            nh os switch
        case sd
            nh darwin switch
        case cd
            cd $flakeHome
        case "*"
            nh $argv
    end
end

