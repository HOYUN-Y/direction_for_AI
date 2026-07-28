#!/usr/bin/env bash
# 이 머신의 공통 지침 파일(허브)을 만들고 Claude Code·Codex가 그걸 보게 연결한다.
#   ./install.sh              → agents_CORP.md 기반
#   ./install.sh ME           → agents_ME.md 기반
#   HUB=~/AGENTS_foo.md ./install.sh   → 허브 이름 변경
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${1:-CORP}"
SRC="$DIR/agents_${PROFILE}.md"
HUB="${HUB:-$HOME/AGENTS_synergylabs.md}"
[ -f "$SRC" ] || { echo "없는 프로필: $SRC" >&2; exit 1; }

# 허브는 머신별 사본이다. 이미 있으면 덮지 않는다(머신 로컬 수정 보호).
if [ -e "$HUB" ]; then
  echo "  유지 $HUB — 갱신하려면 직접 편집하거나 지우고 재실행"
else
  cp "$SRC" "$HUB"
  echo "  생성 $HUB ← agents_${PROFILE}.md"
fi

backup() {
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    cp "$1" "$1.bak"
    echo "  백업 $1.bak"
  fi
}

mkdir -p "$HOME/.codex" "$HOME/.claude"

# Codex는 @import가 없어 허브를 심링크로 놓는다.
backup "$HOME/.codex/AGENTS.md"
ln -sfn "$HUB" "$HOME/.codex/AGENTS.md"

# Claude Code는 AGENTS.md를 읽지 않아 CLAUDE.md에서 @import 한다.
# 주의: 기존 Claude 전용 내용은 .bak으로 밀려난다.
# ponytail: 허브가 홈 밖이면 절대경로 @import가 되는데 미검증. 홈 아래 두면 안전.
IMPORT="${HUB/#$HOME/~}"
backup "$HOME/.claude/CLAUDE.md"
printf '@%s\n' "$IMPORT" > "$HOME/.claude/CLAUDE.md"

[ "$(readlink "$HOME/.codex/AGENTS.md")" = "$HUB" ] || { echo "실패: ~/.codex/AGENTS.md" >&2; exit 1; }
grep -qxF "@$IMPORT" "$HOME/.claude/CLAUDE.md" || { echo "실패: ~/.claude/CLAUDE.md" >&2; exit 1; }

echo "✅ $HUB → Codex(심링크) + Claude Code(@import)"
