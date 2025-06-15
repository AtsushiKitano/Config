# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [ -f $HOME/.zsh_main ]; then
	source $HOME/.zsh_main
fi

if [ -f $HOME/.zsh_alias ]; then
	source $HOME/.zsh_alias
fi

if [ -f $HOME/.zsh_oh-my-zsh ]; then
	source $HOME/.zsh_oh-my-zsh
fi

if [ -f $HOME/.zsh_function ]; then
	source $HOME/.zsh_function
fi

if [ -f $HOME/.zsh_option ]; then
	source $HOME/.zsh_option
fi

if [ -f $HOME/.zsh_code ]; then
	source $HOME/.zsh_code
fi

if [ -f $HOME/.zfunc ]; then
	fpath+=$HOME/.zfunc
	autoload -Uz compinit && compinit
fi

# Created by `pipx` on 2025-06-15 04:00:03
export PATH="$PATH:/Users/kitanoatsushi/.local/bin"
