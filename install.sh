#!/bin/bash

# install brew
if ! type brew; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  xcode-select --install
else
  echo 'brew is installed'
fi

# helper functions
brew_install() {
  if ! type $1; then
    echo "installing: $1..."
    brew install $1
    echo 'finished'
  else
    echo "$1 is installed"
  fi
}

cask_install() {
  if !(brew cask list | grep $1); then
    echo "installing: $1..."
    brew cask install $1
    echo 'finished'
  else
    echo "$1 is installed"
  fi
}

if ! type rbenv; then
  brew_install rbenv
  brew_install ruby-build

  # Add rbenv to bash so that it loads every time you open a terminal
  echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
  source ~/.bash_profile

  # Install Ruby
  rbenv install 2.2.2
  rbenv global 2.2.2
  ruby -v
  gem install bundler
else
  echo 'rbenv and ruby installed'
fi

if ! type postgresql; then
  brew install postgresql
  # To have launchd start postgresql at login:
  ln -sfv /usr/local/opt/postgresql/*plist ~/Library/LaunchAgents

  # Then to load postgresql now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
  echo 'postgresql installed'
fi

#media

brew_install caskroom/cask/brew-cask

cask_install google-chrome
cask_install hipchat
cask_install spotify
cask_install skype
cask_install dropbox
cask_install firefox
cask_install slack
cask_install atom
