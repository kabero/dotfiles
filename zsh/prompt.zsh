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

PROMPT="`left-prompt`"
