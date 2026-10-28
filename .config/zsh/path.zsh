# zsh/path.zsh
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/bin:$PATH"
# asdf e nvim em /opt eram do Fedora: no Omarchy, o mise cuida das versões (ver omarchy.zsh)
# e o nvim vem do sistema.

# JDK padrão do sistema (troque com: sudo archlinux-java set <versão>)
export JAVA_HOME=/usr/lib/jvm/default
export PATH=$JAVA_HOME/bin:$PATH

export ANDROID_HOME=$HOME/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME

export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools

export PATH="$HOME/.atuin/bin:$PATH"

##source $HOME/.atuin/bin/env
##. "$HOME/.atuin/bin/env"

