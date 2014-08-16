##################### 環境変数########################################
######################################################################

export LANG=ja_JP.UTF-8
export JAVA_HOME=`/usr/libexec/java_home`          #Java_HOMEの設定
export M3_HOME=/usr/local/apache-maven-3.2.1/      #mavenのパス省略
M3=$M3_HOME/bin                                    #maven/binのパス省略
export PATH=$M4:$PATH                              #PATHにmavenディレクトリヲ追加
export PATH=/sbin:/usr/sbin:/usr/local/bin:/usr/share/java/apache-ant-1.9.4/bin:~/Dev/VM/packer060/:~/Dev/perl/perl5/perlbrew/bin:$PATH

#export DOCKER_HOST=tcp://192.168.59.103:2375 
export DOCKER_HOST=tcp://localhost:2375


# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
PROMPT=" _$%~_ >"
# 2行表示
#PROMPT="%{${fg[red]}%}[%n@%m]%{${reset_color}%} %~%# "


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit -u

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT=""


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# = の後はパス名として補完する
setopt magic_equal_subst

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# cd+<Tab>でディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt auto_pushd

# pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加されない
setopt pushd_ignore_dups

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# 2つ上、3つ上に移動する
alias ...='cd ../..'
alias ....='cd ../../..'


# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# git treeの表示
alias tree='git log --graph --branches --pretty="format:%C(yellow)%h%Creset %s %Cgreen(%an)%Creset %Cred%d%Creset"'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi



########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        ;;
esac

# vim:set ft=zsh:


# eclipse コマンド設定
eclipse (){
/Users/kitanoatsushishi/Dev/java/eclipse/Eclipse.app/Contents/MacOS/eclipse 
}

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/man:$MANPATH
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8


e (){
/Users/kitanoatsushishi/Applications/Emacs.app/Contents/MacOS/Emacs -nw
}

E (){
/Users/kitanoatsushishi/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -t
}


## create emacs env file

perl -wle \
    'do { print qq/ (setenv "$_" "$ENV{$_}" )/ if exists $ENV{$_}}
for @ARGV' \
    PATH > ~/.emacs.d/shellenv.el

## ruby env初期化
eval "$(rbenv init -)"


PERL_MB_OPT="--install_base \"/Users/kitanoatsushishi/Dev/perl/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/kitanoatsushishi/Dev/perl/perl5"; export PERL_MM_OPT;
