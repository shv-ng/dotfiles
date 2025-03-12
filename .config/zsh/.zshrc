

# Source all config scripts
for script in ~/.config/zsh/configs/*.sh; do
  [[ -f $script ]] && source "$script"
done

# Source all functions scripts
for script in ~/.config/zsh/functions/*.sh; do
  [[ -f $script ]] && source "$script"
done


unset VIMINIT
