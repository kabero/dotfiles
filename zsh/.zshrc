export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:$HOME/.nodebrew/current/bin
eval "$(zoxide init zsh)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


ZSHHOME="${HOME}/.zsh"
if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi

# Keep this section at the bottom of lines
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
