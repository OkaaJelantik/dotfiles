{ pkgs, ... }:
let
  skillCatalog = pkgs.stdenvNoCC.mkDerivation {
    pname = "agent-skills-catalog";
    version = "1.2.0";
    src = ../../skills;

    # Dynamically discover any pool under skills/, copy skills containing SKILL.md,
    # and pre-compile a manifest.tsv for instant indexed search by keyword & description.
    installPhase = ''
      mkdir -p $out/share/agent-skills
      manifest="$out/share/agent-skills/manifest.tsv"
      touch "$manifest"

      for pool_dir in */; do
        [ -d "$pool_dir" ] || continue
        pool="''${pool_dir%/}"

        for skill_dir in "$pool_dir"*/; do
          [ -d "$skill_dir" ] || continue
          skill_file="$skill_dir/SKILL.md"
          if [ -f "$skill_file" ]; then
            skill_name=$(basename "$skill_dir")
            mkdir -p "$out/share/agent-skills/$pool"
            cp -r "$skill_dir" "$out/share/agent-skills/$pool/$skill_name"

            # Extract frontmatter description for the manifest index
            desc=$(awk '
              BEGIN { in_fm = 0; desc = ""; }
              /^---$/ { if (in_fm == 0) { in_fm = 1; next; } else { exit; } }
              in_fm && /^description:[[:space:]]*/ {
                sub(/^description:[[:space:]]*/, "");
                gsub(/^["\047]|["\047]$/, "");
                desc = $0;
              }
              END {
                if (desc == "") desc = "No description provided";
                gsub(/[\t\r\n]+/, " ", desc);
                print desc;
              }
            ' "$skill_file")

            printf "%s/%s\t%s\n" "$pool" "$skill_name" "$desc" >> "$manifest"
          fi
        done
      done

      sort -o "$manifest" "$manifest"
    '';
  };

  agentSkill = pkgs.writeShellApplication {
    name = "agent-skill";
    runtimeInputs = [
      pkgs.fzf
      pkgs.git
      pkgs.bat
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gawk
    ];
    text = ''
      set -euo pipefail

      CATALOG_DIR="''${HOME}/.nix-profile/share/agent-skills"
      if [ ! -d "$CATALOG_DIR" ]; then
        CATALOG_DIR="${skillCatalog}/share/agent-skills"
      fi

      show_help() {
        echo "Usage: agent-skill [command] [options]"
        echo ""
        echo "Commands:"
        echo "  add (default)   Search (by name or description) and link skills into project"
        echo "  rm, remove      Select and remove linked skills from project"
        echo "  ls, list        List currently linked skills in project"
        echo "  help, --help    Show this help message"
        echo ""
        echo "Options:"
        echo "  --claude        Target .claude/skills instead of .agents/skills"
        echo "  --gemini        Target .gemini/skills instead of .agents/skills"
        echo "  -t, --target DIR Target custom directory"
        echo ""
        echo "Search features:"
        echo "  Type skill name (e.g. 'a11y') OR keywords (e.g. 'python', 'sql', 'docker')"
        echo "  Exact substring matching across skill names and descriptions."
        echo ""
        echo "Examples:"
        echo "  agent-skill            # Unified search by name or keyword & link"
        echo "  agent-skill add        # Same as above"
        echo "  agent-skill rm         # Interactively remove linked skills"
        echo "  agent-skill ls         # View active skills in project"
      }

      TARGET_SUBDIR=".agents/skills"
      TARGET_ENTRY=".agents/"

      # Parse target flags
      ARGS=()
      while [ $# -gt 0 ]; do
        case "$1" in
          --claude)
            TARGET_SUBDIR=".claude/skills"
            TARGET_ENTRY=".claude/skills/"
            shift
            ;;
          --gemini)
            TARGET_SUBDIR=".gemini/skills"
            TARGET_ENTRY=".gemini/skills/"
            shift
            ;;
          -t|--target)
            TARGET_SUBDIR="$2"
            TARGET_ENTRY="$2/"
            shift 2
            ;;
          *)
            ARGS+=("$1")
            shift
            ;;
        esac
      done

      CMD="''${ARGS[0]:-add}"

      GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
      TARGET_DIR="''${GIT_ROOT}/''${TARGET_SUBDIR}"

      seed_gitignore() {
        local gitignore="''${GIT_ROOT}/.gitignore"
        if [ -d "''${GIT_ROOT}/.git" ] || [ -f "''${GIT_ROOT}/.git" ]; then
          if [ ! -f "$gitignore" ]; then
            printf "# Local Agent Skills (managed by agent-skill)\n%s\n" "$TARGET_ENTRY" > "$gitignore"
            echo "[+] Created .gitignore with $TARGET_ENTRY"
          elif ! grep -Fxq "$TARGET_ENTRY" "$gitignore" 2>/dev/null && ! grep -Fxq "''${TARGET_ENTRY%/}" "$gitignore" 2>/dev/null; then
            printf "\n# Local Agent Skills (managed by agent-skill)\n%s\n" "$TARGET_ENTRY" >> "$gitignore"
            echo "[+] Seeded $TARGET_ENTRY to .gitignore"
          fi
        fi
      }

      case "$CMD" in
        add)
          seed_gitignore
          mkdir -p "$TARGET_DIR"

          MANIFEST_FILE="$CATALOG_DIR/manifest.tsv"

          if [ -f "$MANIFEST_FILE" ]; then
            SELECTED=$(awk -F'\t' '{ printf "%-45s  \033[2m│\033[0m %s\t%s\n", $1, $2, $1 }' "$MANIFEST_FILE" | fzf \
              --multi \
              --exact \
              --ansi \
              --delimiter=$'\t' \
              --with-nth="1" \
              --accept-nth="2" \
              --prompt="Search & link skills > " \
              --header="[TAB]: Multi-select | [Enter]: Confirm link | [Ctrl-/]: Toggle Preview | [ESC]: Cancel" \
              --preview="if [ -f '$CATALOG_DIR/{2}/SKILL.md' ]; then bat --style=plain --color=always '$CATALOG_DIR/{2}/SKILL.md'; else cat '$CATALOG_DIR/{2}/SKILL.md'; fi" \
              --preview-window=right:55%:wrap \
              --bind="ctrl-/:toggle-preview" || true)
          else
            echo "[*] Scanning catalog from: $CATALOG_DIR"
            SKILLS=$(cd "$CATALOG_DIR" && find . -mindepth 2 -maxdepth 2 -type d | sed 's|^\./||' | sort)
            SELECTED=$(echo "$SKILLS" | fzf \
              --multi \
              --exact \
              --prompt="Search & link skills > " \
              --header="[TAB]: Multi-select | [Enter]: Confirm link | [Ctrl-/]: Toggle Preview | [ESC]: Cancel" \
              --preview="if [ -f '$CATALOG_DIR/{}/SKILL.md' ]; then bat --style=plain --color=always '$CATALOG_DIR/{}/SKILL.md'; else cat '$CATALOG_DIR/{}/SKILL.md'; fi" \
              --preview-window=right:55%:wrap \
              --bind="ctrl-/:toggle-preview" || true)
          fi

          if [ -z "$SELECTED" ]; then
            echo "Cancelled."
            exit 0
          fi

          PROCESSED_NAMES=""

          while IFS= read -r entry; do
            [ -z "$entry" ] && continue
            skill_name=$(basename "$entry")
            dest="$TARGET_DIR/$skill_name"

            if echo "$PROCESSED_NAMES" | grep -qw "$skill_name"; then
              echo "[!] Warning: Duplicate skill '$skill_name' selected from multiple pools. Skipping '$entry'."
              continue
            fi
            PROCESSED_NAMES="$PROCESSED_NAMES $skill_name"

            if [ -e "$dest" ] && [ ! -L "$dest" ]; then
              echo "[!] Safety warning: '$dest' exists and is NOT a symlink. Skipping to avoid data loss."
              continue
            fi

            ln -sfn "$CATALOG_DIR/$entry" "$dest"
            echo "[+] Linked: $entry -> $TARGET_SUBDIR/$skill_name"
          done <<< "$SELECTED"

          echo ""
          echo "[*] Active skills in $TARGET_SUBDIR:"
          for link in "$TARGET_DIR"/*; do
            if [ -L "$link" ]; then
              echo "  - $(basename "$link") -> $(readlink "$link")"
            fi
          done
          ;;

        rm|remove)
          if [ ! -d "$TARGET_DIR" ]; then
            echo "[!] Directory $TARGET_SUBDIR does not exist in $GIT_ROOT."
            exit 0
          fi

          LINKED=$(find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -type l -exec basename {} \; | sort)
          if [ -z "$LINKED" ]; then
            echo "[i] No skills currently linked in $TARGET_SUBDIR."
            exit 0
          fi

          SELECTED=$(echo "$LINKED" | fzf \
            --multi \
            --exact \
            --prompt="Remove skills > " \
            --header="[TAB]: Multi-select | [Enter]: Confirm removal | [Ctrl-/]: Toggle Preview | [ESC]: Cancel" \
            --preview="if [ -f '$TARGET_DIR/{}/SKILL.md' ]; then bat --style=plain --color=always '$TARGET_DIR/{}/SKILL.md'; else cat '$TARGET_DIR/{}/SKILL.md'; fi" \
            --preview-window=right:55%:wrap \
            --bind="ctrl-/:toggle-preview" || true)

          if [ -z "$SELECTED" ]; then
            echo "Cancelled."
            exit 0
          fi

          while IFS= read -r skill; do
            if [ -n "$skill" ]; then
              if [ -L "$TARGET_DIR/$skill" ]; then
                rm -f "$TARGET_DIR/$skill"
                echo "[-] Removed: $TARGET_SUBDIR/$skill"
              else
                echo "[!] Skipping '$skill': not a symlink (protected)."
              fi
            fi
          done <<< "$SELECTED"
          ;;

        ls|list)
          if [ ! -d "$TARGET_DIR" ]; then
            echo "[i] No skills directory at $TARGET_SUBDIR."
            exit 0
          fi

          echo "[*] Active skills in $TARGET_SUBDIR ($GIT_ROOT):"
          count=0
          for link in "$TARGET_DIR"/*; do
            if [ -L "$link" ]; then
              echo "  - $(basename "$link") -> $(readlink "$link")"
              count=$((count + 1))
            fi
          done
          if [ "$count" -eq 0 ]; then
            echo "  (none)"
          fi
          ;;

        help|--help|-h)
          show_help
          ;;

        *)
          echo "Unknown command: $CMD"
          show_help
          exit 1
          ;;
      esac
    '';
  };
in
{
  home.packages = [
    skillCatalog
    agentSkill
  ];
}
