# Start profiling
# =======================
# zmodload zsh/zprof
# =======================

DISABLE_UPDATE_PROMPT="true"
ZSH_THEME="clean"
UPDATE_ZSH_DAYS=30

# ZSH tab completion of git commands is very slow
plugins=(git zsh-syntax-highlighting)
__git_files () {
    _wanted files expl 'local files' _files
}

pym() {
    module_path="${1%.*}"  # Remove file extension, if any
    module_path="${module_path//\//.}"  # Replace slashes with dots
    python -m "$module_path"
}

pyd() {
    module_path="${1%.*}"  # Remove file extension, if any
    module_path="${module_path//\//.}"  # Replace slashes with dots
    python -m pdb -m "$module_path"
}

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Speed up zsh compinit by only checking cache once a day
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

# brew
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# conda initialize
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup

[ -n "$TMUX" ] && export COLORTERM=truecolor

# configure node version manager
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use # This loads nvm
alias node='unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'
alias zathura='zathura --mode fullscreen'

# shortcuts
alias lg="lazygit"
alias py="python -m pdb -c c"
# conda envs
alias csymai="conda activate symai"
alias csymaic="conda activate symai310"
alias cdotfiles="conda activate dotfiles"
# most used paths
alias @nvim="cd $HOME/.config/nvim"
alias @dotfiles="cd $HOME/devspace/my_repos/dotfiles"
alias @symai="cd $HOME/devspace/projects/symbolicai"

zstyle ':completion:*' menu select
fpath+=~/.zfunc
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# We love python!
conda activate base
source $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# End profiling
# =======================
# zprof
# =======================
