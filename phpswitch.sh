#!/bin/bash

brew_prefix=$(brew --prefix | sed 's#/#\\\/#g')
brew_array=("5.6","7.0","7.1","7.2","7.3","7.4")
php_array=("php@5.6" "php@7.0" "php@7.1" "php@7.2" "php@7.3" "php@7.4")
php_installed_array=()
php_version="php@$1"

# Has the user submitted a version required
if [[ -z "$1" ]]; then
    echo "usage: brew-php-switcher version"
    echo
    echo "    version    one of:" ${brew_array[@]}
    echo
    exit
fi

# What versions of php are installed via brew
for i in ${php_array[*]}; do
    if [[ -n "$(brew ls --versions "$i")" ]]; then
        php_installed_array+=("$i")
    fi
done

# Check that the requested version is supported
if [[ " ${php_array[*]} " == *"$php_version"* ]]; then
    # Check that the requested version is installed
    if [[ " ${php_installed_array[*]} " == *"$php_version"* ]]; then

        # Switch Shell
        echo "Switching to $php_version"
        echo "Switching your shell"
        for i in ${php_installed_array[@]}; do
            brew unlink $i
        done
        brew link --force "$php_version"

        echo "All done!"
    else
        echo "Sorry, but $php_version is not installed via brew. Install by running: brew install $php_version"
    fi
else
    echo "Unknown version of PHP. PHP Switcher can only handle arguments of:" ${brew_array[@]}
fi

