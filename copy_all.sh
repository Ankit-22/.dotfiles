if [ ! -d ./i3 ]; then
	mkdir i3
fi

cp -f ~/.i3/config ./i3/

cp -f ~/.zshrc .

if [ ! -d ./sublime-settings ]; then
	mkdir sublime-settings
fi

cp -f ~/.config/sublime-text-3/Packages/User/*.sublime-settings ./sublime-settings/