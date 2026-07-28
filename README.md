# direction_for_AI

AI 코딩 에이전트 지침 **원본**. 머신마다 여기서 사본(허브)을 하나 만들고,
Claude Code와 Codex가 그 허브를 보게 한다.

```bash
git clone https://github.com/HOYUN-Y/direction_for_AI.git
cd direction_for_AI
./install.sh          # agents_CORP.md 기반 (기본)
./install.sh ME       # agents_ME.md 기반
```

경로는 스크립트 위치에서 계산하므로 클론 위치나 사용자명이 달라도 된다.

## 구조

```
agents_CORP.md (이 저장소, 원본)
        │ install.sh가 1회 복사
        ▼
~/AGENTS_synergylabs.md  ← 머신별 허브. 이 머신 사정은 여기서 직접 고친다.
        ▲                        ▲
        │ symlink                │ @import
~/.codex/AGENTS.md      ~/.claude/CLAUDE.md
```

허브는 **머신별 사본**이다. 이미 있으면 `install.sh`가 덮지 않으므로 로컬 수정이
보존된다. 원본 쪽 변경을 반영하려면 허브를 지우고 재실행하거나 직접 옮긴다.
허브가 사본이라 원본과 갈라질 수 있는데, 머신마다 지침이 달라지는 걸
허용하려는 의도다. 한 벌로 강제하려면 허브를 사본 대신 심링크로 바꾼다.

허브 이름은 `HUB=~/AGENTS_foo.md ./install.sh`로 바꿀 수 있다.
`~/.claude/CLAUDE.md`는 통째로 덮이고 기존 내용은 `.bak`으로 백업된다.

## 파일

| 파일 | 용도 |
|---|---|
| `agents_CORP.md` | 회사 프로젝트 공통 지침 |
| `agents_ME.md` | 개인 작업 루틴 (문서 관리) |
| `AGENTS.md` | 새 프로젝트에 복사해 쓰는 범용 템플릿 |
| `CLAUDE.md` | 이 저장소용 Claude 레이어 (`@AGENTS.md` import) |

## 왜 도구마다 방식이 다른가

| 경로 | 도구 | 방식 |
|---|---|---|
| `~/.codex/AGENTS.md` | Codex 전역 | 심링크 |
| `~/.claude/CLAUDE.md` | Claude Code 전역 | `@import` 한 줄 |

**Claude Code는 `AGENTS.md`를 읽지 않는다.** 빈 폴더에 코드워드를 심고 확인한
결과 `CLAUDE.md`만 로드됐다. 그래서 Claude 쪽은 `CLAUDE.md`에서 `@import`로 끌어온다.

**Codex는 `@import`가 없다.** `codex-cli 0.145.0`의 설정 키에 `project_doc_max_bytes`,
`project_doc_fallback_filenames`만 있고 다른 파일을 끌어오는 키는 없다. 그래서
`~/.codex/AGENTS.md` 자리에 내용이 물리적으로 있어야 하고, 심링크가 유일한 방법이다.

`~/AGENTS.md`(홈 루트)는 만들지 않는다. cwd가 홈일 때만 적용되는데 그때는
`~/.codex/AGENTS.md`와 내용이 겹쳐 같은 지침이 두 번 로드된다.

## 프로젝트 저장소에 적용

레포별 `AGENTS.md`가 공통 지침보다 우선한다. Claude도 같은 내용을 보게 하려면
레포에 `CLAUDE.md`를 만들고 한 줄만 넣는다. 사본을 만들면 드리프트가 생긴다.

```markdown
공통 지침은 @AGENTS.md 를 따른다. (이 줄이 AGENTS.md 전체를 세션에 로드)
```
