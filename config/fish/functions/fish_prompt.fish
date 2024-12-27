function fish_prompt
    #if fish_is_root_user
    #    set symbol ' # '
    #    set -q fish_color_cwd_root
    #    and set color $fish_color_cwd_root
    #end

    set -l symbol '/> '

    if test "$PWD" = "$HOME" || test "$PWD" = /
        set symbol '> '
    end

    #set -l color $fish_color_cwd
    echo \n(prompt_pwd --full-length-dirs 2)$symbol
end
