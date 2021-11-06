#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/DotFiles/files                                    # dotfiles directory
olddir=~/DotFilesOld                                    # old dotfiles backup directory
files="bashrc vimrc zshrc Xresources "
files+="gitconfig gitignore committemplate i3"          # list of files/folders to symlink in homedir

##########
echo "##############################################"
echo "Installing dot files..."

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
echo "##############################################"
