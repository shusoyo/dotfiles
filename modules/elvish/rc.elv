fn ls {|@a| e:ls --color $@a }

fn v {|@a| e:nvim $@a }

fn y {|@a|
    var tmp = (mktemp -t "yazi-cwd.XXXXX")
    yazi $@a --cwd-file $tmp
    cat $tmp | var cwd = (read-line)
    if (and (!=s $cwd "") (!=s (get-env PWD) $cwd)) { 
      cd $cwd
    } 
    rm -f -- $tmp
}


