#!/bin/bash

CURRENT_DIR="$PWD"
USER="/home/$USER"
USER_CONFIG="/home/$USER/.config"

echo "Link configuration files"
echo "[1]Link all configuration"
echo "[2]Only neovim"
echo "[3]Only alacritty"
echo "[4]Only tmux"
echo "[5]Only terminator"
echo "[6]Only vifm"
read OPTION

case $OPTION in
    1)
        for DIR  in .config/*; do
            if [[ -d $USER/$DIR ]]; then
                echo "$DIR already exist" 
                echo "Do you want to replace it?"
                echo "[Y]es, current directory will be deleted!"
                echo "[N]o"
                read MAKE
                case $MAKE in
                    Y|y)
                        echo "Removing $DIR"
                        rm -rf -v $USER/$DIR
                        echo "Linking $DIR"
                        ln -s -v $CURRENT_DIR/$DIR $USER/$DIR
                        ;;
                    N|n)
                        continue
                        ;;
                esac
            else
                echo "$DIR"
                ln -s -v $CURRENT_DIR/$DIR $USER/$DIR
            fi
        done;
        ;;
    2)
        if [[ -d $USER_CONFIG/nvim ]]; then
            echo "Neovim directory already exist in .config"
        else
            ln -s -v $CURRENT_DIR/nvim/.config/nvim $USER_CONFIG
        fi
        ;;
    3)
        if [[ -d $USER_CONFIG/alacritty ]]; then
           echo "Alacritty directory already exist in .config" 
        else
            ln -s -v $CURRENT_DIR/alacritty/.config/alacritty $USER_CONFIG
        fi
        ;;
    4)
        if [[ -d $USER_CONFIG/tmux ]]; then
            echo "Tmux directory already exist in .config"
        else
            ln -s -v $USER_CONFIG/tmux/.config/tmux $USER_CONFIG
        fi
        ;;
    5)
        if [[ -d $USER_CONFIG/terminator ]]; then
            echo "Tmux directory already exist in .config"
        else
            ln -s -v $USER_CONFIG/terminator/.config/terminator $USER_CONFIG
        fi
        ;;
    6)
        if [[ -d $USER_CONFIG/vifm ]]; then
            echo "Tmux directory already exist in .config"
        else
            ln -s -v $USER_CONFIG/vifm/.config/vifm $USER_CONFIG
        fi
        ;;

esac
