cgreen='%F{green}'
cmagenta='%F{magenta}'
cred='%F{red}'
cblue='%F{blue}'

uname='%n'
hname='%m'
curdir=`echo %~`
sharp='%%'
rs='%f'
laststatus='%(?.%F{green}.%F{red}[%?] )%f'

function left-prompt {
    echo "${laststatus}${cgreen}${uname}${rs}@${cred}${hname}${rs} ${curdir} ${sharp} "
}

# Git status 
function git-current-branch {
  local branch_name st branch_status

  branch='\ue0a0'
  color='%{\e[38;5;'
  green='114m%}'
  red='001m%}'
  yellow='227m%}'
  blue='033m%}'
  reset='%{\e[0m%}'

  if [ ! -e  ".git" ]; then
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    branch_status="${color}${green}${branch}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    branch_status="${color}${red}${branch}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    branch_status="${color}${red}${branch}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    branch_status="${color}${yellow}${branch}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    echo "${color}${red}${branch}!(no branch)${reset}"
    return
  else
    branch_status="${color}${blue}${branch}"
  fi
  echo "${branch_status}$branch_name${reset}"
}

PROMPT="`left-prompt`"
RPROMPT='`git-current-branch`'
setopt prompt_subst
