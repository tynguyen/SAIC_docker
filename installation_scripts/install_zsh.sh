# # Install zsh, oh-my-zsh with syntax-hightlight and command autocompletion
# apt-get update
# apt-get install zsh -y

# # Make zsh a default shell
# chsh -s $(which zsh) $(whoami)

# # Install oh-my-zsh
# sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# # Install zsh-autosuggestions and zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# # Add these packages to .zshrc
# sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

apt-get update
apt-get -y install curl zsh git
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" ||true

ln -f /bin/zsh /bin/sh


# NOTE: you can add more plugins to zsh by doing two steps:
# 1. Clone the package to $HOME/.oh-my-zsh/custom/plugins/
# 2. Add the package to $HOME/.zshrc
# For example, install zsh-autosuggestions and zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Add these packages to .zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' $HOME/.zshrc
