#!/bin/bash

# Stand up tools and apps for Bill's MacOS setup

################################################################
# Install XCode Tools                                          #
################################################################

echo "######### Install xcode-select tools #########" 

# Get xcode tools
xcode-select --install

################################################################
# Install homebrew, setup autoupdates                          #
################################################################

echo "######### Install homebrew, setup auto-updates #########"

# Get homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Create ~/Library/LaunchAgents if it doesn't exist to avoid error with brew autoupdate
mkdir /Users/williamdeitrick/Library/LaunchAgent:

# Add brew autoupdate, notifications (incl. terminal-notifier for notifications)
brew install terminal-notifier
brew tap domt4/autoupdate
brew autoupdate --start --upgrade --cleanup --enable-notifications

################################################################
# Manage App Store Apps with MAS                               #
################################################################

echo "######### Manage App Store Apps with MAS #########"

# Install mas to automate App Store downloads
brew install mas

# Remove GarageBand if it's installed...get that space back
if mas list | grep 682658836 > /dev/null; then
  echo "@#@# Bill: Removing GarageBand."
  sudo rm -rf /Applications/GarageBand.app/
  sudo rm -rf /Library/Application\ Support/GarageBand/
  sudo rm -rf /Library/Application\ Support/Logic/
  sudo rm -rf /Library/Audio/Apple\ Loops/
else
  echo "@#@# Bill: No GarageBand found. Yippee!"
fi

# Remove iMovie if it's installed...get that space back as well
if mas list | grep 408981434 > /dev/null; then
  echo "@#@# Bill: Removing iMovie."
  sudo rm -rf /Library/Applications/iMovie.app/
else
  echo "@#@# Bill: No iMovie found. Yippee!"
fi

# Install desired apps from app store
mas install 409183694 # Keynote
mas install 409201541 # Pages
mas install 409203825 # Numbers
mas install 803453959 # Slack
mas install 1295203466 # MS Remote Desktop 10
mas install 784801555 # MS OneNote
mas install 1333542190 # 1Password 7

################################################################
# Manage Homebrew GUI Apps                                     #
################################################################

echo "######### Install non-mas apps with Homebrew #########"

# Install HomeBrew GUI apps
brew cask install osxfuse
brew cask install cryptomator
brew cask install google-backup-and-sync
brew cask install gnucash
brew cask install visual-studio-code
brew cask install keepassx
brew cask install airtool
brew cask install gimp
brew cask install wireshark
brew cask install xquartz # Required for Inkscape
brew cask install inkscape # Requires xquartz
brew cask install virtualbox # Will need to approve kernel extensions
brew cask install vagrant
brew cask install typora
brew cask install google-chrome
brew cask install iterm2
brew cask install docker

################################################################
# Install vscode extensions                                    #
################################################################

echo "######### Install vscode extensions #########"

/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension skyapps.fish-vscode
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension mikestead.dotenv
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension knisterpeter.vscode-github
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension esbenp.prettier-vscode
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension mohsen1.prettify-json
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension ms-python.python
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension rebornix.ruby
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension samuelcolvin.jinjahtml
/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code --install-extension peterjausovec.vscode-docker

################################################################
# Install CLI tools                                            #
################################################################

echo "######### Install cli tools with Homebrew #########"

brew install coreutils
brew install diffutils
brew install findutils --with-default-names
brew install gawk
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install grep --with-default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget
brew install less
brew install make
brew install nano
brew install file-formula
brew install git
brew install openssh
brew install rsync
brew install unzip
brew install nmap
brew install vim
brew install gpg
brew install telnet

################################################################
# Fish!                                                        #
################################################################

echo "######### Install Fish and Powerline Font #########"

# Install Fish
brew install fish

# Add to /etc/shells (requires new bash with root for redirection to work)
sudo bash -c "echo /usr/local/bin/fish >> /etc/shells"

# Set Fish as default shell (more setup will happen from fish)
chsh -s /usr/local/bin/fish

# Get a nerdfonts for Fish
brew tap caskroom/fonts
brew cask install font-hack-nerd-font

# Get completions for Fish
curl -Lo ~/.config/fish/completions/docker.fish https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish

################################################################
# Python dev stuff basics                                      #
################################################################

echo "######### Install Python Dev Stuff #########"

# Using pyenv to manage Python installations
brew install pyenv

brew install readline xz # dependency for installing Python versions

sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target / # Headers required to build Python on Mojave and ^

# Set a var with the latest stable Python version...we'll use this multiple times (inspired by https://stackoverflow.com/questions/29687140/install-latest-python-version-with-pyenv)
PYTHON_LATEST=$(pyenv install --list | sed 's/^  //' | grep --invert-match '\(-\|a\|b\dev\)' | tail -1)
PYTHON27=$(pyenv install --list | sed 's/^  //' | grep --invert-match '\(-\|a\|b\dev\)' | grep 2[.]7 | tail -1)

# Get the latest stable Python versions from pyenv
pyenv install $PYTHON27
pyenv install $PYTHON_LATEST # Python 3 Latest

# Tell pyenv what our default Python will be
pyenv global $PYTHON_LATEST

# Since pyenv shims won't actually be default yet, we'll call them explicitly to use latest python and get Pipenv
~/.pyenv/shims/pip install -U pipenv

# Done with Python...pipenv handles all other magic

################################################################
# Ruby dev stuff                                               #
################################################################

echo "######### Install Ruby Dev Stuff #########" 

brew install rbenv

# Heroku; apparently this can't be installed via brew anymore
curl https://cli-assets.heroku.com/install.sh | sh

# Set a var with the latest stable Ruby version available from rbenv
RUBY_LATEST=$(rbenv install --list | grep '^\s\+[0-9]\.[0-9]\.[0-9]$' | tail -1)

# Get the latest stable Ruby version from rbenv
rbenv install $RUBY_LATEST

# Tell rbenv what our default Ruby will be
rbenv global $RUBY_LATEST

################################################################
# Node stuff                                                   #
################################################################

echo "######### Install Node Stuff #########" 

# NVM install...not officially "supported" via brew
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

# This allows us to start using NVM immediately in the current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Next, we'll install the current LTS version of node
# See NVM readme for details
nvm install 'lts/*'

################################################################
# Node Modules                                                 #
################################################################

echo "######### Install Node Modules #########" 

npm install -g serverless
npm install -g yo 
npm install -g generator-serverless-policy
npm install -g serverless-azure-functions

################################################################
# Change system settings                                       #
################################################################

echo "######### Change system settings #########"

# Not changing any system settings at the moment
