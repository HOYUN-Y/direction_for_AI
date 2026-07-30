# direction_for_AI

AI 코딩 에이전트(Claude Code, Codex 등) 지침 문서 **원본 모음**.
쓸 문서를 골라 대상 위치에 복사하거나 `@import`로 끌어온다.

## 파일

| 파일 | 용도 |
|---|---|
| `agents_CORP.md` | 회사 프로젝트 공통 지침 |
| `agents_ME.md` | 개인 작업 루틴 (문서 관리) |
| `AGENTS.md` | 새 프로젝트에 복사해 쓰는 범용 템플릿 |
| `CLAUDE.md` | 이 저장소용 Claude 레이어 (`@AGENTS.md` import) |

## 프로젝트 저장소에 적용

레포별 `AGENTS.md`가 전역 지침보다 우선한다. Claude도 같은 내용을 보게 하려면
레포에 `CLAUDE.md`를 만들고 한 줄만 넣는다. 사본을 만들면 드리프트가 생긴다.

```markdown
공통 지침은 @AGENTS.md 를 따른다. (이 줄이 AGENTS.md 전체를 세션에 로드)
```

**Claude Code는 `AGENTS.md`를 읽지 않는다.** 빈 폴더에 코드워드를 심고 확인한
결과 `CLAUDE.md`만 로드됐다. 그래서 Claude 쪽은 항상 `CLAUDE.md`가 필요하다.

**Codex는 `@import`가 없다.** `codex-cli 0.145.0`의 설정 키에 `project_doc_max_bytes`,
`project_doc_fallback_filenames`만 있고 다른 파일을 끌어오는 키는 없다. 그래서
Codex에 물릴 자리에는 내용이 물리적으로 있어야 한다(복사 또는 심링크).
