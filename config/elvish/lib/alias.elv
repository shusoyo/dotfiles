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

each { |lst| edit:add-var $lst[0]~ $lst[1] } [
  [ls        {|@a| e:ls -v --color $@a     }]
  [ll        {|@a| e:ls -v -l --color $@a  }]
  [la        {|@a| e:ls -v -la --color $@a }]
  [v         {|@a| nvim $@a                }]
  [y         $__yazi_shellwrapper           ]
  [elv       {|@a| elvish $@a              }]
  [lg        {|@a| lazygit $@a             }]
]

