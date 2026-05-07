#!/usr/bin/env bash
# Creekmoon Claude Skill Installer (macOS / Linux)
# Equivalent of autoUpdateSkill.cmd

set -u

RAW="https://gitee.com/creekmoon/creekmoon-claude-skill/raw/master"
GIT_URL="https://gitee.com/creekmoon/creekmoon-claude-skill.git"
API_URL="https://gitee.com/api/v5/repos/creekmoon/creekmoon-claude-skill/contents"

REPO=""
REPO_READY="N"
GITOK="N"
TDIR=""
SKILLS=()
REMOTE_VERS=()
LOCAL_VERS=()

# Colors (best-effort)
if [ -t 1 ]; then
    C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
else
    C_RESET=""; C_BOLD=""; C_DIM=""
fi

cleanup() {
    if [ -n "$REPO" ] && [ -d "$REPO" ]; then
        rm -rf "$REPO" 2>/dev/null || true
    fi
}
trap cleanup EXIT

banner() {
    echo
    echo " ================================================================"
    echo "   Creekmoon Claude Skill Installer"
    echo " ================================================================"
}

# ================================================================
# STEP 0 - Connectivity
# ================================================================
step0_connectivity() {
    echo
    echo " [ Step 0 ]  Testing connectivity..."
    echo
    if curl -s --max-time 8 "$RAW/README.md" -o /dev/null; then
        echo "         [OK]  Gitee"
        if command -v git >/dev/null 2>&1; then
            GITOK="Y"
        fi
    else
        echo "         [ERROR]  Cannot reach Gitee. Check your network."
        exit 1
    fi
}

# ================================================================
# STEP 1 - Install location
# ================================================================
step1_location() {
    echo
    echo " ----------------------------------------------------------------"
    echo " [ Step 1 ]  Choose install location"
    echo
    echo "         [1]  Global   ->  $HOME/.claude/skills"
    echo "         [2]  Current  ->  $PWD/.claude/skills"
    echo
    local choice
    while true; do
        read -r -p "         Enter choice (1/2): " choice
        case "$choice" in
            1) TDIR="$HOME/.claude/skills"; break ;;
            2) TDIR="$PWD/.claude/skills"; break ;;
            *) ;;
        esac
    done
}

# ================================================================
# Load skills (prefer git clone, fallback HTTP API)
# ================================================================
add_skill() {
    SKILLS+=("$1")
    REMOTE_VERS+=("N/A")
    LOCAL_VERS+=("---")
}

load_skills_git() {
    REPO="$(mktemp -d -t csk.XXXXXX)"
    if git clone --depth 1 "$GIT_URL" "$REPO" >/dev/null 2>&1; then
        REPO_READY="Y"
        while IFS= read -r d; do
            [ -z "$d" ] && continue
            if [ -f "$REPO/$d/SKILL.md" ]; then
                add_skill "$d"
            fi
        done < <(cd "$REPO" && find . -mindepth 1 -maxdepth 1 -type d | sed 's|^\./||' | sort)
        return 0
    fi
    rm -rf "$REPO" 2>/dev/null || true
    REPO=""
    return 1
}

load_skills_http() {
    local names
    if command -v python3 >/dev/null 2>&1; then
        names=$(curl -fsSL --max-time 15 "$API_URL" 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for i in sorted(data, key=lambda x: x.get('name','')):
        if i.get('type') == 'dir':
            print(i['name'])
except Exception:
    pass
")
    else
        # very rough fallback parser
        names=$(curl -fsSL --max-time 15 "$API_URL" 2>/dev/null \
            | tr ',' '\n' \
            | grep -E '"name"[[:space:]]*:' \
            | sed -E 's/.*"name"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/' \
            | sort -u)
    fi
    while IFS= read -r d; do
        [ -z "$d" ] && continue
        if curl -fsSL --max-time 10 "$RAW/$d/SKILL.md" -o /dev/null 2>/dev/null; then
            add_skill "$d"
        fi
    done <<< "$names"
}

load_skills() {
    if [ "$GITOK" = "Y" ]; then
        load_skills_git || true
    fi
    if [ "${#SKILLS[@]}" -eq 0 ]; then
        load_skills_http
    fi
}

extract_version() {
    # $1 = path to SKILL.md
    [ -f "$1" ] || { echo "---"; return; }
    local v
    v=$(grep -i '^version:' "$1" 2>/dev/null | head -n1 | sed -E 's/^[Vv]ersion:[[:space:]]*//' | tr -d '\r' | tr -d ' ')
    [ -z "$v" ] && v="---"
    echo "$v"
}

fetch_remote_ver() {
    local idx=$1 name="${SKILLS[$1]}" tmp
    tmp="$(mktemp -t csk.XXXXXX)"
    if curl -s --max-time 10 "$RAW/$name/SKILL.md" -o "$tmp" 2>/dev/null; then
        REMOTE_VERS[$idx]=$(extract_version "$tmp")
    fi
    rm -f "$tmp"
}

fetch_local_ver() {
    local idx=$1 name="${SKILLS[$1]}"
    local f="$TDIR/$name/SKILL.md"
    if [ -f "$f" ]; then
        LOCAL_VERS[$idx]=$(extract_version "$f")
    fi
}

# ================================================================
# STEP 2 - list + pick
# ================================================================
step2_list() {
    echo
    echo "         Install to: $TDIR"
    echo
    echo " ----------------------------------------------------------------"
    echo " [ Step 2 ]  Discovering skills and versions (please wait)..."
    echo

    load_skills
    if [ "${#SKILLS[@]}" -eq 0 ]; then
        echo "         [ERROR]  No skills found from remote source."
        exit 1
    fi

    local i
    for i in "${!SKILLS[@]}"; do
        fetch_remote_ver "$i"
        fetch_local_ver "$i"
    done

    echo
    printf " %-4s %-40s %-12s %-12s %s\n" "#" "Skill Name" "Remote" "Installed" "Status"
    echo " ---- ---------------------------------------- ------------ ------------ --------"
    for i in "${!SKILLS[@]}"; do
        local st="[new   ]"
        if [ "${LOCAL_VERS[$i]}" != "---" ]; then
            if [ "${LOCAL_VERS[$i]}" = "${REMOTE_VERS[$i]}" ]; then
                st="[ok    ]"
            else
                st="[update]"
            fi
        fi
        printf " [%-2d] %-40s %-12s %-12s %s\n" \
            "$((i+1))" "${SKILLS[$i]}" "${REMOTE_VERS[$i]}" "${LOCAL_VERS[$i]}" "$st"
    done

    echo
    echo " ----------------------------------------------------------------"
    echo
    echo "         Numbers (comma-separated) | A = all | Q = quit"
    echo "         Example:  1,3,5   or   A"
    echo
}

SELECTED=()
step2_pick() {
    local i
    for i in "${!SKILLS[@]}"; do SELECTED[$i]="N"; done

    local inp
    while true; do
        read -r -p "         >> " inp
        [ -n "$inp" ] && break
    done

    case "$inp" in
        q|Q) exit 0 ;;
        a|A)
            for i in "${!SKILLS[@]}"; do SELECTED[$i]="Y"; done
            return
            ;;
    esac

    local tokens
    IFS=', ' read -r -a tokens <<< "$inp"
    for t in "${tokens[@]}"; do
        [ -z "$t" ] && continue
        if [[ "$t" =~ ^[0-9]+$ ]]; then
            local idx=$((t-1))
            if [ "$idx" -ge 0 ] && [ "$idx" -lt "${#SKILLS[@]}" ]; then
                SELECTED[$idx]="Y"
            fi
        fi
    done
}

# ================================================================
# STEP 3 - install
# ================================================================
install_from_repo() {
    mkdir -p "$TDIR"
    local i
    for i in "${!SKILLS[@]}"; do
        [ "${SELECTED[$i]}" = "Y" ] || continue
        local name="${SKILLS[$i]}"
        local src="$REPO/$name"
        local dst="$TDIR/$name"
        if [ -f "$src/SKILL.md" ]; then
            rm -rf "$dst"
            mkdir -p "$dst"
            # Mirror src -> dst
            if command -v rsync >/dev/null 2>&1; then
                rsync -a --delete "$src"/ "$dst"/
            else
                cp -R "$src"/. "$dst"/
            fi
            echo "         [OK]   $name"
        else
            echo "         [SKIP] $name  (source incomplete, skipped)"
        fi
    done
}

install_from_http() {
    echo "         Downloading via HTTP (SKILL.md only)..."
    mkdir -p "$TDIR"
    local i
    for i in "${!SKILLS[@]}"; do
        [ "${SELECTED[$i]}" = "Y" ] || continue
        local name="${SKILLS[$i]}"
        local dst="$TDIR/$name"
        mkdir -p "$dst"
        if curl -fsSL --max-time 20 "$RAW/$name/SKILL.md" -o "$dst/SKILL.md" 2>/dev/null; then
            # file-level sync: keep only SKILL.md
            find "$dst" -mindepth 1 ! -name 'SKILL.md' -exec rm -rf {} + 2>/dev/null || true
            echo "         [OK]   $name"
        else
            echo "         [FAIL] $name"
        fi
    done
}

step3_install() {
    local any="N" i
    for i in "${!SKILLS[@]}"; do
        [ "${SELECTED[$i]}" = "Y" ] && any="Y"
    done
    if [ "$any" = "N" ]; then
        echo
        echo "         Nothing selected. Exiting."
        exit 0
    fi
    if [ -z "$TDIR" ]; then
        echo
        echo "         [ERROR]  Install path not set. Aborting."
        exit 1
    fi

    echo
    echo " ----------------------------------------------------------------"
    echo " [ Step 3 ]  Installing..."
    echo
    echo "         Will install:"
    for i in "${!SKILLS[@]}"; do
        [ "${SELECTED[$i]}" = "Y" ] && echo "             - ${SKILLS[$i]}"
    done
    echo

    if [ "$GITOK" = "Y" ]; then
        if [ "$REPO_READY" = "Y" ] && [ -n "$REPO" ] && [ -d "$REPO" ]; then
            install_from_repo
            return
        fi
        REPO="$(mktemp -d -t csk.XXXXXX)"
        echo "         Cloning repository..."
        if git clone --depth 1 "$GIT_URL" "$REPO" >/dev/null 2>&1; then
            REPO_READY="Y"
            install_from_repo
            return
        fi
        rm -rf "$REPO" 2>/dev/null || true
        REPO=""
        echo "         git clone failed, falling back to HTTP..."
        echo
    fi

    install_from_http
}

# ================================================================
# Main
# ================================================================
banner
step0_connectivity
step1_location
step2_list
step2_pick
step3_install

echo
echo " ================================================================"
echo "   Done!  Installed to:"
echo "   $TDIR"
echo " ================================================================"
echo
