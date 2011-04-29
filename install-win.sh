#!/bin/bash
# Windows doesn't like symlinks, so we can't use them for anything outside
# of the cygwin environment.

# Check or create backup directory
if [ -d backup ]; then
    echo "Backup directory exists"
else
    mkdir backup
fi

home=`readlink -f ~`

for file in *
do
    if [ -d $file ]; then
	continue
    elif [[ $file =~ install || $file =~ readme || $file =~ README || $file =~ emacs ]]; then
	continue
    fi
    link_name="$home/.$file"
    target=`readlink -f $file`
    if [ -e $link_name ]; then
	mv $link_name ~/.dotfiles/backup
	#echo "Copy $link_name to backup"
    fi
    ln -ns $target $link_name
    #echo "Filename $file linked from $link_name"
done


# Copy files
cp ~/.dotfiles/user/.location ~/.location

if [ -e ~/.emacs ]; then
    cp ~/.emacs ~/.dotfiles/backup
fi

(
cat <<EOF
(add-to-list 'load-path "~/.dotfiles/emacs.d")
(load "trailbound")
EOF
) > ~/.emacs


# Set environment variables

setx HOME `cygpath -w $home`
