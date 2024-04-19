# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
