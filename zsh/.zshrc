# Start profiling
# =======================
# zmodload zsh/zprof
# =======================

DISABLE_UPDATE_PROMPT="true"
ZSH_THEME="clean"
UPDATE_ZSH_DAYS=30
# ZSH tab completion of git commands is very slow
plugins=(git)
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

md2pdf() {
    pandoc "$1" --pdf-engine=xelatex -o "$2" --pdf-engine-opt="-interaction=nonstopmode" --pdf-engine-opt="-file-line-error"
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

[ -n "$TMUX" ] && export COLORTERM=truecolor

# shortcuts
alias zathura='zathura --mode fullscreen'
alias lg="lazygit"
alias py="python -m pdb -c c"
# conda envs
alias ca="conda activate"

# most used paths
alias @dotfiles="cd $HOME/Devspace/projects/dotfiles"
alias @symai="cd $HOME/devspace/projects/symbolicai"
alias @pkgs="cd $HOME/.symai/packages/ExtensityAI"
alias @blog="cd $HOME/Devspace/projects/futurisold.github.io"
export symai="$HOME/Devspace/projects/symbolicai/.venv/bin/activate"

zstyle ':completion:*' menu select
fpath+=~/.zfunc
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export GEM_HOME="$HOME/.gem"

# sourcing
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh

#
# bc we love python!
conda activate base

# End profiling
# =======================
# zprof
# =======================

