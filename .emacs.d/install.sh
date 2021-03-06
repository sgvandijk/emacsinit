#!/bin/bash

if [[ ! -e ~/.cask ]]
then
    echo "Cloning Cask repo"
    git clone https://github.com/cask/cask.git ~/.cask
fi

if [[ $(grep "cask/bin" ~/.bash_profile) == "" ]]
then
    echo "Adding \$HOME/.cask/bin to \$PATH in ~/.bash_profile"
    echo '' >> ~/.bash_profile
    echo "# Added by ~/.emacs.d/install.sh" >> ~/.bash_profile
    echo "export PATH=\$HOME/.cask/bin:\$PATH" >> ~/.bash_profile
fi

export PATH=$HOME/.cask/bin:$PATH

cd ~/.emacs.d
cask install

echo "Now make a symbolic link to one of the local .el files, e.g.:"
echo
echo "    ln -s local-inits/linux.el local.el"
