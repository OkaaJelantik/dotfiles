# Agent Skill Manager (interactive link/unlink with fzf preview)
alias askill='agent-skill'

# Nix Search with fzf preview
# Usage:
#   ns          -> interactive search across all packages
#   ns <query>  -> search filtered by query (e.g. ns python)
ns() {
  local query="${*:-*}"
  nix-search "$query" | fzf --preview "nix-search --details {1}" --preview-window=right:60%:wrap
}
