# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/ankit/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# linuxbrew Settings
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#                                                                     #
#                       User Customization Start                      #
#                                                                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

#Python virtualenv Settings only when we want
if [ -f ~/.myconfigfile ]; then
	export WORKON_HOME=~/.python_virtual_envs
	export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
	export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
	source /usr/local/bin/virtualenvwrapper.sh
	rm ~/.myconfigfile
fi

alias py3=python3
alias py=python

# It can set the volume level. $1 is percent, $2 is '+' or '-'
# Eg. set_audio 10 +       =>    Increases volume by 10%
# Eg. set_audio 10         =>    sets volume to 10%
function set_audio() {
	amixer -D pulse sset Master $1%$2 > /dev/null;
}

# Open a app 
# Eg. open_app nautilus
function open_app() {
	$1 $@ > /dev/null 2>&1 &
}

# Open a file with default app
# Eg. open_file image.png
function open_file() {
	xdg-open $1 > /dev/null 2>&1 &
}

# It can open any archive file
# Eg. openarch ankit.zip ankit.tar ankit.b2z ankit.gz
function openarch() {
	while [ $# -gt 0 ]; do
		if [ ! -f "$1" ]; then
			echo "File Not Found: $1"
			shift;
			continue
		fi
		echo "File Found: $1"
		if [ ! -r "$1" ]; then
			echo "File Not Readable: $1"
			shift;
			continue
		fi
		filename=$(basename "$1")
		extension="${filename##*.}"
		if [ "`command -v tar`" = 0 ]; then
			echo "Please install tar by running sudo apt-get install tar"
			shift;
			continue
		fi
		echo "$extension"
		if [ "$extension" = "tar" ]; then
			tar -xvf $1
		elif [ "$extension" = "gz" ]; then
			tar -xzvf $1
		elif [ "$extension" = "b2z" ]; then
			tar -xjvf $1
		elif [ "$extension" = "zip" ]; then
			if [ "`command -v unzip`" = 0 ]; then
				echo "Please install unzip by running sudo apt-get install unzip"
				shift;
				continue
			fi
			unzip $1
		elif [ "$extension" = "rar" ]; then
			if [ "`command -v unrar`" = 0 ]; then
				echo "Please install unrar by running sudo apt-get install unrar"
				shift;
				continue
			fi
			unrar x -r $1
		else
			echo "Unidentified extension: $extension in file $1"
		fi
		shift;
	done
}

# My implementation of killall
# Eg. kill_app nautilus
function kill_app() {
	if [ $1 = '-f' ]; then
		kill -SIGKILL `ps -A | grep $2 | awk {'printf ("%s ", $1)'}`
	else
		kill `ps -A | grep $1 | awk {'printf ("%s ", $1)'}`
	fi
}

# Run a c file with one command
# Eg. runc hello.c
function runc() {
	$filename = $1
	shift
	gcc $filename -o $filename.out $@
	if [ $? -eq 0 ]
	then
		./$filename.out
		rm -f $filename.out
	fi
}

# Run a cpp file with one command
# Eg. runcpp hello.cpp
function runcpp() {
	$filename = $1
	shift
	gcc $filename -o $filename.out $@
	if [ $? -eq 0 ]
	then
		./$filename.out
		rm -f $filename.out
	fi
}

# Zip all git files in a git directory
# Eg. gitzip name.zip
function gitzip() {
	zip $1 `git ls-tree -r master --name-only | awk {'printf("%s ", $1)'}`
}

# This creates a directory alias (This alias can be used to directly go to that directory.)
# Ex. diralias create myProject ~/Projects/Java/Android/AndroidStudioProjects/myProject
# Now this will create myProject alias.
# If you want to go to '~/Projects/Java/Android/AndroidStudioProjects/myProject' directory just type myProject and ENTER.

# Note: Use absolute path for create command.
function diralias() {

	if [ ! -d ~/.dir_list ]; then
		mkdir ~/.dir_list
	fi

	if [ $1 = "create" ]; then
		if [ $# = 3 ]; then
			echo -n "$3" > ~/.dir_list/$2
			alias $2=`cat ~/.dir_list/$2`
		else
			echo "Create Usage: diralias create <name> <direcrtory>"
		fi
	fi
}

# Load with created aliases
if [ -d ~/.dir_list ]; then
	for file in ~/.dir_list/*; do
		alias $(basename $file)=`cat $file`
	done
fi
