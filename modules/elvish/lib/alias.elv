## helper funcion
var __yazi_shellwrapper = {|@a| 
  var tmp = (mktemp -t "yazi-cwd.XXXXX")
  yazi $@a --cwd-file $tmp
  cat $tmp | var cwd = (read-line)
  if (and (!=s $cwd "") (!=s (get-env PWD) $cwd)) { 
    cd $cwd
  } 
  rm -f -- $tmp
}

fn set-alias {|name command|
  put [&fname=$name'~' &f=$command]
}

each {|map| edit:add-var $map[fname] $map[f] } [
  (set-alias    ls      {|@a| e:ls --color $@a})
  (set-alias    ll      {|@a| e:ls -l --color $@a})
  (set-alias    la      {|@a| e:ls -la --color $@a})
  (set-alias    v       {|@a| nvim $@a})
  (set-alias    y       $__yazi_shellwrapper)
]

