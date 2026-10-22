{ pkgs, ... }:
let
  skillCatalog = pkgs.stdenvNoCC.mkDerivation {
    pname = "agent-skills-catalog";
    version = "1.0.0";
    src = ../../skills;

    installPhase = ''
      mkdir -p $out/share/agent-skills
      if [ -d Claude-skills ]; then
        cp -r Claude-skills/* $out/share/agent-skills/
      fi
      if [ -d Specify/skills ]; then
        cp -r Specify/skills/* $out/share/agent-skills/
      fi
      rm -f $out/share/agent-skills/README.md
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
        echo "  add (default)   Select and link skills into current project"
        echo "  rm, remove      Select and remove linked skills from project"
        echo "  ls, list        List currently linked skills in project"
        echo "  help, --help    Show this help message"
        echo ""
        echo "Options:"
        echo "  --claude        Target .claude/skills instead of .agents/skills"
        echo "  --gemini        Target .gemini/skills instead of .agents/skills"
        echo "  -t, --target DIR Target custom directory"
        echo ""
        echo "Examples:"
        echo "  agent-skill            # Interactively select & link skills"
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

          echo "[*] Scanning catalog from: $CATALOG_DIR"

          SKILLS=$(find -L "$CATALOG_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

          if [ -z "$SKILLS" ]; then
            echo "[!] No skills found in catalog ($CATALOG_DIR)."
            exit 1
          fi

          SELECTED=$(echo "$SKILLS" | fzf \
            --multi \
            --prompt="Link skills > " \
            --header="[TAB]: Multi-select | [Enter]: Confirm link | [ESC]: Cancel" \
            --preview="if [ -f '$CATALOG_DIR/{}/SKILL.md' ]; then bat --style=plain --color=always '$CATALOG_DIR/{}/SKILL.md'; else cat '$CATALOG_DIR/{}/SKILL.md'; fi" \
            --preview-window=right:60%:wrap)

          if [ -z "$SELECTED" ]; then
            echo "Cancelled."
            exit 0
          fi

          while IFS= read -r skill; do
            if [ -n "$skill" ]; then
              ln -sfn "$CATALOG_DIR/$skill" "$TARGET_DIR/$skill"
              echo "[+] Linked: $skill -> $TARGET_SUBDIR/$skill"
            fi
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
            --prompt="Remove skills > " \
            --header="[TAB]: Multi-select | [Enter]: Confirm removal | [ESC]: Cancel" \
            --preview="if [ -f '$TARGET_DIR/{}/SKILL.md' ]; then bat --style=plain --color=always '$TARGET_DIR/{}/SKILL.md'; else cat '$TARGET_DIR/{}/SKILL.md'; fi" \
            --preview-window=right:60%:wrap)

          if [ -z "$SELECTED" ]; then
            echo "Cancelled."
            exit 0
          fi

          while IFS= read -r skill; do
            if [ -n "$skill" ]; then
              rm -f "$TARGET_DIR/$skill"
              echo "[-] Removed: $TARGET_SUBDIR/$skill"
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
