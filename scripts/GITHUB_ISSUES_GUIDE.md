# GitHub Issues 생성 가이드

## 방법 1: GitHub CLI 사용 (권장)

### 1. GitHub CLI 설치

관리자 권한으로 PowerShell을 실행한 후:

```powershell
# winget 사용 (Windows 10/11)
winget install --id GitHub.cli

# 또는 직접 다운로드
# https://cli.github.com/ 에서 설치 프로그램 다운로드
```

설치 후 PowerShell을 재시작하세요.

### 2. GitHub 인증

```powershell
gh auth login
```

브라우저를 통해 GitHub 계정으로 로그인하세요.

### 3. 이슈 생성 스크립트 실행

```powershell
cd c:\Users\ab\workspace\calculator-demo
.\scripts\create-github-issues.ps1
```

---

## 방법 2: GitHub REST API 사용

### 1. Personal Access Token 생성

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token (classic)" 클릭
3. 권한 선택: `repo` (전체 체크)
4. 토큰 생성 및 복사 (한 번만 표시됨!)

### 2. 환경 변수 설정

```powershell
$env:GITHUB_TOKEN = "your_token_here"
```

### 3. 스크립트 실행

```powershell
cd c:\Users\ab\workspace\calculator-demo
.\scripts\create-github-issues.ps1
```

---

## 방법 3: 수동으로 GitHub 웹에서 생성

스크립트에 정의된 이슈 템플릿을 참고하여 수동으로 생성할 수 있습니다.

### Phase 1 이슈 목록 (총 13개)

1. **[Phase 1] Project Setup & Infrastructure**
   - Labels: `phase-1`, `setup`, `infrastructure`

2. **[Phase 1] Core Calculation Engine - Basic Arithmetic (TDD)**
   - Labels: `phase-1`, `core-logic`, `tdd`, `calculation`

3. **[Phase 1] Core Calculation Engine - Scientific Functions (TDD)**
   - Labels: `phase-1`, `core-logic`, `tdd`, `scientific`

4. **[Phase 1] Expression Parser - Tokenizer (TDD)**
   - Labels: `phase-1`, `core-logic`, `tdd`, `parser`

5. **[Phase 1] Expression Parser - AST Parser (TDD)**
   - Labels: `phase-1`, `core-logic`, `tdd`, `parser`

6. **[Phase 1] State Management (TDD)**
   - Labels: `phase-1`, `core-logic`, `tdd`, `state`

7. **[Phase 1] Storage & History Management (TDD)**
   - Labels: `phase-1`, `core-logic`, `tdd`, `storage`

8. **[Phase 1] UI Components - HTML Structure**
   - Labels: `phase-1`, `ui`, `html`, `accessibility`

9. **[Phase 1] UI Components - Styling with Tailwind CSS**
   - Labels: `phase-1`, `ui`, `css`, `styling`

10. **[Phase 1] Event Handling & UI Controller**
    - Labels: `phase-1`, `ui`, `javascript`, `events`

11. **[Phase 1] Theme System Implementation**
    - Labels: `phase-1`, `ui`, `theme`, `tdd`

12. **[Phase 1] Manual Testing & Quality Assurance**
    - Labels: `phase-1`, `testing`, `qa`, `manual`

13. **[Phase 1] Documentation & Deployment**
    - Labels: `phase-1`, `documentation`, `deployment`

---

## 이슈 템플릿 구조

각 이슈는 다음 구조를 따릅니다:

```markdown
## 작업 배경
[왜 이 작업이 필요한지 설명]

## 작업 내용
[구체적인 작업 항목들]
- [ ] 체크리스트 형식

## 인수 조건
[완료 기준]
- [ ] 체크리스트 형식

## 참고 문서
[관련 문서 링크]
```

---

## 트러블슈팅

### GitHub CLI 설치 오류
- 관리자 권한으로 PowerShell 실행 필요
- Windows 버전 확인 (Windows 10 1809 이상 권장)

### API 스크립트 오류
- `GITHUB_TOKEN` 환경 변수 확인
- 토큰 권한 확인 (`repo` 권한 필요)
- 저장소 이름 확인 (`HoSeongRyu23/calculator-demo`)

### Rate Limiting
- GitHub API는 시간당 5000 요청 제한
- 스크립트는 각 이슈 생성 사이에 500ms 대기
