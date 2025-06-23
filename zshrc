# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Completions (Fish-like menu comes from fzf-tab)
autoload -Uz compinit && compinit    # loads system completions :contentReference[oaicite:0]{index=0}

# Antidote bootstrap
source ~/.antidote/antidote.zsh
# Generate static bundle the first time or after edits
[[ ! -f ~/.zsh_plugins.zsh ]] && antidote bundle <~/.zsh_plugins.txt >~/.zsh_plugins.zsh
source ~/.zsh_plugins.zsh

# History and performance
HISTSIZE=5000 SAVEHIST=5000
setopt share_history inc_append_history
zcompile ~/.zshrc &>/dev/null  # byte-compile after first load

# Aliases
alias ll='ls -alF' la='ls -A' l='ls -CF'

# Paths
export PATH="$PATH:/usr/local/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- cursor-movement & word-kill bindings (Ctrl+Arrows / Ctrl+Del) ---
bindkey -e                                # emulate-readline map if not already set
zmodload zsh/terminfo 2>/dev/null || true # pull in $terminfo[] names


# portable, terminfo-aware bindings
[[ -n ${terminfo[kLFT5]} ]] && bindkey -M emacs "${terminfo[kLFT5]}" backward-word
[[ -n ${terminfo[kRIT5]} ]] && bindkey -M emacs "${terminfo[kRIT5]}" forward-word
[[ -n ${terminfo[kDEL5]} ]] && bindkey -M emacs "${terminfo[kDEL5]}" kill-word


# universal fall-backs for xterm/VT-like sequences
bindkey -M emacs '^[[1;5D' backward-word      # Ctrl+Left
bindkey -M emacs '^[[1;5C' forward-word       # Ctrl+Right
bindkey -M emacs '^[[3;5~' kill-word # Ctrl+Delete
# Ctrl-Backspace → delete previous word
bindkey -M emacs '^H' backward-kill-word
# --- HOME / END ------------------------------------------------
# portable Varianten
[[ -n ${terminfo[khome]} ]] && bindkey -M emacs "${terminfo[khome]}" beginning-of-line  # Home
[[ -n ${terminfo[kend]}  ]] && bindkey -M emacs "${terminfo[kend]}"  end-of-line        # End

# XTerm-/VT-Escape-Fallbacks (normal + »Application Mode«)
bindkey -M emacs '^[[H'  beginning-of-line   # ESC [ H
bindkey -M emacs '^[[F'  end-of-line         # ESC [ F
bindkey -M emacs '^[OH'  beginning-of-line   # ESC O H
bindkey -M emacs '^[OF'  end-of-line         # ESC O F
bindkey -M emacs '^[[1~' beginning-of-line   # ESC [1~
bindkey -M emacs '^[[4~' end-of-line         # ESC [4~

# Ctrl-Home / Ctrl-End (optional – viele Terminals senden 1;5H / 1;5F)
bindkey -M emacs '^[[1;5H' backward-kill-line
bindkey -M emacs '^[[1;5F' kill-line
# ----------------------------------------------------------------
