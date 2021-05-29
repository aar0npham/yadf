function existsCommand() {
  builtin command -v $1 > /dev/null 2>&1
}

function source-safe() { if [ -f "$1" ]; then source "$1"; fi }


#==============================================================#
## aws completion
#==============================================================#
if existsCommand aws_zsh_completer.sh; then
  source aws_zsh_completer.sh
fi


#==============================================================#
## terraform completion
#==============================================================#
if existsCommand terraform; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/bin/terraform terraform
fi


#==============================================================#
## pip completion
#==============================================================#
if existsCommand pip; then
  eval "$(pip completion --zsh)"
fi


##==============================================================#
### pipenv completion
##==============================================================#
# bug: tab completion with autosuggestion and autocompletion
#if existsCommand pipenv; then
#  eval "$(pipenv --completion)"
#fi


#==============================================================#
## cargo completion
#==============================================================#
if existsCommand cargo; then
  d=$(readlink -f $HOME/.rustup/toolchains/*/share/zsh/site-functions)
  if [ -d "$d" ]; then
    fpath=($d $fpath)
  fi
fi


#==============================================================#
## npm completion
#==============================================================#
_npm_path_hook() {
if [[ -n $NPM_DIR ]]; then
  # remove old dir from path
  path=(${path:#$NPM_DIR})
  unset NPM_DIR
fi

if [[ -d "${XDG_CONFIG_HOME}/npm/node_modules/bin" ]]; then
  NPM_DIR="${XDG_CONFIG_HOME}/npm/node_modules/bin"
  path=($NPM_DIR $path)
fi
}
[[ -z $chpwd_functions ]] && chpwd_functions=()
chpwd_functions=($chpwd_functions _npm_path_hook)


#==============================================================#
## fasd
#==============================================================#
if existsCommand fasd; then
  eval "$(fasd --init auto)"
  alias d='fasd -d'
  alias f='fasd -f'
  alias vf='f -e vim'
fi
