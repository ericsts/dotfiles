# zsh/path.zsh
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.asdf/shims:$PATH"
export PATH="$HOME/.asdf/installs/rust/1.91.0/bin:$PATH"
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
##export JAVA_HOME=/usr/lib/jvm/java-latest-openjdk
export PATH=$JAVA_HOME/bin:$PATH

export ANDROID_HOME=$HOME/android-sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME

export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/build-tools

export PATH="$HOME/.atuin/bin:$PATH"

##source $HOME/.atuin/bin/env
##. "$HOME/.atuin/bin/env"

