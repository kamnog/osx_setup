#!/bin/bash

# install brew
if ! type brew; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  xcode-select --install
else
  echo 'brew update'
  brew update
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

brew_install_with_agents() {
  if ! type $1; then
    echo "installing: $1..."
    brew install $1
    echo 'agents installing...'
    # To have launchd start redis at login:
    ln -sfv /usr/local/opt/$1/*.plist ~/Library/LaunchAgents
    # Then to load redis now:
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.$1.plist
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

brew_install_with_agents postgresql
brew_install_with_agents mysql
brew_install_with_agents redis
brew_install_with_agents mongodb

brew_install caskroom/cask/brew-cask
brew_install qt
brew_install memcached
brew_install imagemagick
brew_install node
brew_install heroku
brew_install bash-completion
brew_install elixir

# Media

cask_install google-chrome
cask_install hipchat
cask_install spotify
cask_install skype
cask_install dropbox
cask_install firefox
cask_install slack
cask_install atom
cask_install vlc
cask_install sublime-text
cask_install iterm2
cask_install harvest
cask_install todoist
cask_install mailbox
cask_install alfred
cask_install bettertouchtool

# Settings
defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock

# You need to install manualy:
# f.lux
# sunrise
# quickcast
# monosnap
# caffeine
