# Quick Edit function
edit() {
  typeset -A EDIT_CONFIGS
  EDIT_CONFIGS=(
    [yabai]="$HOME/.config/yabai/yabairc"
    [skhd]="$HOME/.config/skhd/skhdrc"
    [zshrc]="$HOME/.config/zsh/.zshrc"
    [aliases]="$HOME/.config/zsh/aliases.zsh"
  )
  
  local SOURCE_TAGS=(zshrc aliases)
  
  local tag="$1"
  
  if [[ -z "$tag" ]]; then
    echo "Error: No tag specified" >&2
    echo "Available tags: ${(k)EDIT_CONFIGS[@]}" >&2
    return 1
  fi
  
  if [[ "$tag" == "--help" || "$tag" == "-h" ]]; then
    echo "Quick Edit Tool"
    echo "Usage: edit <tag>"
    echo "Available tags: ${(k)EDIT_CONFIGS[@]}"
    return 0
  fi
  
  local filepath="${EDIT_CONFIGS[$tag]}"
  if [[ -z "$filepath" ]]; then
    echo "Error: Unknown tag: $tag" >&2
    echo "Available tags: ${(k)EDIT_CONFIGS[@]}" >&2
    return 1
  fi
  
  if [[ ! -f "$filepath" ]]; then
    echo "File $filepath does not exist."
    echo -n "Create it? (y/N): "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      local dir=$(dirname "$filepath")
      if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
      fi
      touch "$filepath"
      echo "Created file: $filepath"
    else
      echo "Cancelled."
      return 1
    fi
  fi
  
  local editor="${EDITOR:-nvim}"
  "$editor" "$filepath"
  
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    return $exit_code
  fi
  
  # source needed?
  if [[ " ${SOURCE_TAGS[@]} " =~ " ${tag} " ]]; then
    echo "Sourcing $filepath..."
    source "$filepath"
    if [[ $? -eq 0 ]]; then
      echo "✓ Successfully sourced $filepath"
    else
      echo "✗ Failed to source $filepath"
      return 1
    fi
  else
    echo "✓ Successfully saved $filepath"
  fi
}
