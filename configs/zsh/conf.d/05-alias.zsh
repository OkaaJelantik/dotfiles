# Aliases

# Nix Search with fzf preview
# Usage:
#   ns        -> interactive search across packages with details preview
#   ns <query> -> pre-filter search (e.g. ns python)
alias ns='nix-search "*" | fzf --preview "nix-search --details {1}" --preview-window=right:60%:wrap'

nsf() {
  local query="${*:-*}"
  nix-search "$query" | fzf --preview "nix-search --details {1}" --preview-window=right:60%:wrap
}
