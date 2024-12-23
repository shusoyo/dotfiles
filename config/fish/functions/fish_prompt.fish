function fish_prompt
    set -l symbol '/> '
    if test "$PWD" = "$HOME"
        set symbol '> '
    end

    set -l color $fish_color_cwd
    if fish_is_root_user
        set symbol ' # '
        set -q fish_color_cwd_root
        and set color $fish_color_cwd_root
    end

    # new line
    echo

    #set_color $color
    echo -n (prompt_pwd --full-length-dirs 2)
    #set_color normal

    echo -n $symbol
end
