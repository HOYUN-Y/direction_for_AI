# direction_for_AI

AI 코딩 에이전트 지침 원본. 클론한 뒤 `install.sh`로 전역 지침을 연결한다.

```bash
git clone https://github.com/HOYUN-Y/direction_for_AI.git
cd direction_for_AI
./install.sh          # agents_CORP.md (회사 프로젝트, 기본)
./install.sh ME       # agents_ME.md   (개인 작업 루틴)
```

경로는 스크립트 위치에서 계산하므로 클론 위치나 사용자명이 달라도 된다.
기존 파일은 `.bak`으로 백업된다.

## 파일

| 파일 | 용도 |
|---|---|
| `agents_CORP.md` | 회사 프로젝트 공통 지침 |
| `agents_ME.md` | 개인 작업 루틴 (문서 관리) |
| `AGENTS.md` | 새 프로젝트에 복사해 쓰는 범용 템플릿 |
| `CLAUDE.md` | 이 저장소용 Claude 레이어 (`@AGENTS.md` import) |

## install.sh가 연결하는 곳

| 경로 | 도구 | 방식 |
|---|---|---|
| `~/.codex/AGENTS.md` | Codex 전역 | 심링크 |
| `~/AGENTS.md` | Codex (cwd가 홈일 때) | 심링크 |
| `~/.claude/CLAUDE.md` | Claude Code 전역 | `@import` 한 줄 |

**Claude Code는 `AGENTS.md`를 읽지 않는다.** 빈 폴더에 코드워드를 심고 확인한
결과 `CLAUDE.md`만 로드됐다. 그래서 Claude 쪽은 `CLAUDE.md`에서 `@import`로 끌어온다.

Codex는 `@import`가 없어 심링크만 가능하다. 대신 Claude는 `@import`라
`CLAUDE.md` 아래에 도구 전용 규칙을 덧붙일 수 있다.

## 프로젝트 저장소에 적용

레포별 `AGENTS.md`가 공통 지침보다 우선한다. Claude도 같은 내용을 보게 하려면
레포에 `CLAUDE.md`를 만들고 한 줄만 넣는다. 사본을 만들면 드리프트가 생긴다.

```markdown
공통 지침은 @AGENTS.md 를 따른다. (이 줄이 AGENTS.md 전체를 세션에 로드)
```
