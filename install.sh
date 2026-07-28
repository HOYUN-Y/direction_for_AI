#!/usr/bin/env bash
# 전역 AI 에이전트 지침을 이 저장소로 연결한다. 클론 위치·사용자명 무관.
#   ./install.sh          → agents_CORP.md (기본)
#   ./install.sh ME       → agents_ME.md
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="${1:-CORP}"
SRC="$DIR/agents_${PROFILE}.md"
[ -f "$SRC" ] || { echo "없는 프로필: $SRC" >&2; exit 1; }

# Claude Code의 @import는 ~ 형식이 검증됨. 저장소가 홈 밖이면 절대경로로 폴백.
# ponytail: 홈 밖 절대경로 @import는 미검증. 안 먹으면 저장소를 홈 아래로 클론.
IMPORT="${SRC/#$HOME/~}"

backup() {
  [ -e "$1" ] && [ ! -L "$1" ] || return 0
  cp "$1" "$1.bak" && echo "  백업 $1.bak"
}

# Codex는 @import를 지원하지 않아 심링크로 연결한다.
# ~/AGENTS.md      : cwd가 홈일 때
# ~/.codex/AGENTS.md: Codex 전역
mkdir -p "$HOME/.codex"
for t in "$HOME/AGENTS.md" "$HOME/.codex/AGENTS.md"; do
  backup "$t"; ln -sfn "$SRC" "$t"
done

# Claude Code는 AGENTS.md를 읽지 않으므로 CLAUDE.md에서 @import 한다.
# 주의: 기존 Claude 전용 내용은 .bak으로 밀려난다.
mkdir -p "$HOME/.claude"
backup "$HOME/.claude/CLAUDE.md"
printf '@%s\n' "$IMPORT" > "$HOME/.claude/CLAUDE.md"

for t in "$HOME/AGENTS.md" "$HOME/.codex/AGENTS.md"; do
  [ "$(readlink "$t")" = "$SRC" ] || { echo "실패: $t" >&2; exit 1; }
done
grep -qxF "@$IMPORT" "$HOME/.claude/CLAUDE.md" || { echo "실패: ~/.claude/CLAUDE.md" >&2; exit 1; }

echo "✅ agents_${PROFILE}.md → Codex 2곳 + Claude Code 1곳"
