#!/usr/bin/env pwsh
# GitHub Issues Creation Script
# This script creates GitHub issues from the task list

# Configuration
$REPO_OWNER = "HoSeongRyu23"
$REPO_NAME = "calculator-demo"
$GITHUB_TOKEN = $env:GITHUB_TOKEN

if (-not $GITHUB_TOKEN) {
    Write-Host "Error: GITHUB_TOKEN environment variable is not set" -ForegroundColor Red
    Write-Host "Please set your GitHub Personal Access Token:" -ForegroundColor Yellow
    Write-Host '  $env:GITHUB_TOKEN = "your_token_here"' -ForegroundColor Cyan
    exit 1
}

$headers = @{
    "Authorization" = "Bearer $GITHUB_TOKEN"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$baseUrl = "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/issues"

# Issue templates
$issues = @(
    @{
        title = "[Phase 1] Project Setup & Infrastructure"
        labels = @("phase-1", "setup", "infrastructure")
        body = @"
## 작업 배경
Engineering Calculator 프로젝트의 개발 환경을 구축하고 기본 인프라를 설정합니다. 이는 모든 후속 개발 작업의 기반이 되는 필수 단계입니다.

## 작업 내용

### 1. 프로젝트 구조 초기화
- [ ] 디렉토리 구조 생성 (`src/`, `src/js/`, `src/css/`, `tests/unit/`, `tests/integration/`)
- [ ] Vite 빌드 도구 설정
  - Vite 설치 및 설정 파일 생성
  - GitHub Pages용 base path 설정
  - 빌드 스크립트 추가
- [ ] Jest 테스트 프레임워크 설정
  - Jest 및 Babel 설치
  - 설정 파일 생성
  - 테스트 스크립트 추가
- [ ] 코드 품질 도구 설정
  - ESLint (Airbnb config)
  - Prettier
  - Lint 스크립트 추가

### 2. 버전 관리 설정
- [ ] Git 초기화
- [ ] `.gitignore` 생성
- [ ] GitHub 저장소 연결

### 3. 배포 파이프라인 구성
- [ ] GitHub Actions 워크플로우 생성
- [ ] GitHub Pages 배포 설정
- [ ] 배포 테스트

## 인수 조건
- [ ] 모든 디렉토리 구조가 생성되어 있음
- [ ] `npm run dev`로 개발 서버가 정상 실행됨
- [ ] `npm run build`로 프로덕션 빌드가 성공함
- [ ] `npm test`로 테스트가 실행됨 (초기에는 테스트 없음)
- [ ] `npm run lint`로 린팅이 실행됨
- [ ] GitHub Actions 워크플로우가 성공적으로 실행됨
- [ ] GitHub Pages에 배포가 완료됨

## 참고 문서
- [PRD.md](../docs/PRD.md)
- [TechSpec.md](../docs/TechSpec.md)
- [task.md](../.gemini/antigravity/brain/36bd392d-297e-47e0-87a3-51ad41db3b23/task.md)
"@
    },
    @{
        title = "[Phase 1] Core Calculation Engine - Basic Arithmetic (TDD)"
        labels = @("phase-1", "core-logic", "tdd", "calculation")
        body = @"
## 작업 배경
계산기의 핵심 기능인 기본 산술 연산(덧셈, 뺄셈, 곱셈, 나눗셈)을 TDD 방식으로 구현합니다. 이는 모든 계산 기능의 기초가 됩니다.

## 작업 내용

### 1. Calculator 클래스 설계
- [ ] `src/js/calculator.js` 파일 생성
- [ ] Calculator 클래스 기본 구조 작성

### 2. TDD로 기본 연산 구현
각 연산마다 **테스트 작성 → 구현 → 리팩토링** 순서를 따릅니다.

#### 덧셈 (Addition)
- [ ] 테스트 작성: 두 양수 덧셈
- [ ] 테스트 작성: 음수 포함 덧셈
- [ ] 테스트 작성: 소수점 덧셈
- [ ] `add(a, b)` 메서드 구현

#### 뺄셈 (Subtraction)
- [ ] 테스트 작성: 기본 뺄셈
- [ ] 테스트 작성: 음수 결과
- [ ] 테스트 작성: 소수점 뺄셈
- [ ] `subtract(a, b)` 메서드 구현

#### 곱셈 (Multiplication)
- [ ] 테스트 작성: 기본 곱셈
- [ ] 테스트 작성: 0 곱셈
- [ ] 테스트 작성: 음수 곱셈
- [ ] `multiply(a, b)` 메서드 구현

#### 나눗셈 (Division)
- [ ] 테스트 작성: 기본 나눗셈
- [ ] 테스트 작성: 0으로 나누기 (에러)
- [ ] 테스트 작성: 소수점 결과
- [ ] `divide(a, b)` 메서드 구현

## 인수 조건
- [ ] 모든 테스트가 통과함 (`npm test`)
- [ ] 코드 커버리지 100% (기본 연산 부분)
- [ ] ESLint 에러 없음
- [ ] 0으로 나누기 시 적절한 에러 발생
- [ ] 부동소수점 연산이 정확함 (허용 오차 범위 내)

## 테스트 예시
\`\`\`javascript
describe('Calculator - Basic Operations', () => {
  let calc;
  
  beforeEach(() => {
    calc = new Calculator();
  });
  
  test('should add two positive numbers', () => {
    expect(calc.add(2, 3)).toBe(5);
  });
  
  test('should throw error on division by zero', () => {
    expect(() => calc.divide(5, 0)).toThrow('Division by zero');
  });
});
\`\`\`

## 참고 문서
- [TDD Rules](../.agent/rules/tdd.md)
- [SOLID Principles](../.agent/rules/solid.md)
"@
    },
    @{
        title = "[Phase 1] Core Calculation Engine - Scientific Functions (TDD)"
        labels = @("phase-1", "core-logic", "tdd", "scientific")
        body = @"
## 작업 배경
공학용 계산기의 핵심 기능인 삼각함수와 각도 변환 기능을 TDD 방식으로 구현합니다.

## 작업 내용

### 1. 삼각함수 구현 (TDD)
- [ ] 테스트 작성: sin 함수 (DEG 모드)
- [ ] 테스트 작성: sin 함수 (RAD 모드)
- [ ] `sin(angle)` 메서드 구현
- [ ] 테스트 작성: cos 함수 (DEG/RAD)
- [ ] `cos(angle)` 메서드 구현
- [ ] 테스트 작성: tan 함수 (DEG/RAD)
- [ ] `tan(angle)` 메서드 구현

### 2. 각도 변환 (TDD)
- [ ] 테스트 작성: DEG to RAD 변환
- [ ] 테스트 작성: RAD to DEG 변환
- [ ] `toRadians(angle)` 메서드 구현
- [ ] `toDegrees(radians)` 메서드 구현
- [ ] 각도 모드 설정 (`angleMode` 속성)

### 3. 로그 함수 (TDD)
- [ ] 테스트 작성: log (상용로그)
- [ ] 테스트 작성: ln (자연로그)
- [ ] `log(x)` 메서드 구현
- [ ] `ln(x)` 메서드 구현

### 4. 거듭제곱 및 루트 (TDD)
- [ ] 테스트 작성: 거듭제곱 (x^y)
- [ ] 테스트 작성: 제곱근 (√x)
- [ ] `power(x, y)` 메서드 구현
- [ ] `sqrt(x)` 메서드 구현

## 인수 조건
- [ ] 모든 테스트가 통과함
- [ ] DEG 모드에서 sin(30) = 0.5 (오차 범위 내)
- [ ] RAD 모드에서 sin(π/6) = 0.5 (오차 범위 내)
- [ ] 각도 모드 전환이 정상 작동함
- [ ] 음수 입력에 대한 로그 함수가 에러 발생
- [ ] 음수의 제곱근이 에러 발생
- [ ] 코드 커버리지 >80%

## 테스트 예시
\`\`\`javascript
test('should calculate sine in degrees', () => {
  calc.angleMode = 'DEG';
  expect(calc.sin(30)).toBeCloseTo(0.5, 5);
});

test('should calculate sine in radians', () => {
  calc.angleMode = 'RAD';
  expect(calc.sin(Math.PI / 6)).toBeCloseTo(0.5, 5);
});
\`\`\`
"@
    },
    @{
        title = "[Phase 1] Expression Parser - Tokenizer (TDD)"
        labels = @("phase-1", "core-logic", "tdd", "parser")
        body = @"
## 작업 배경
사용자가 입력한 수식 문자열을 토큰으로 분리하는 Tokenizer를 구현합니다. 이는 수식 파싱의 첫 단계입니다.

## 작업 내용

### 1. Tokenizer 클래스 설계
- [ ] `src/js/parser/tokenizer.js` 파일 생성
- [ ] Token 타입 정의 (NUMBER, OPERATOR, FUNCTION, LPAREN, RPAREN)

### 2. TDD로 Tokenizer 구현

#### 숫자 토큰화
- [ ] 테스트: 정수 토큰화 ("123" → [NUMBER(123)])
- [ ] 테스트: 소수 토큰화 ("12.5" → [NUMBER(12.5)])
- [ ] 테스트: 음수 토큰화 ("-5" → [NUMBER(-5)])
- [ ] 숫자 토큰화 로직 구현

#### 연산자 토큰화
- [ ] 테스트: 기본 연산자 ("+", "-", "×", "÷")
- [ ] 테스트: 연속 연산자 처리
- [ ] 연산자 토큰화 로직 구현

#### 함수 토큰화
- [ ] 테스트: 함수 이름 인식 ("sin", "cos", "tan")
- [ ] 테스트: 대소문자 처리
- [ ] 함수 토큰화 로직 구현

#### 괄호 토큰화
- [ ] 테스트: 여는 괄호 "("
- [ ] 테스트: 닫는 괄호 ")"
- [ ] 괄호 토큰화 로직 구현

#### 복합 수식 토큰화
- [ ] 테스트: "2 + 3" → [NUMBER(2), OPERATOR(+), NUMBER(3)]
- [ ] 테스트: "sin(45)" → [FUNCTION(sin), LPAREN, NUMBER(45), RPAREN]
- [ ] 테스트: "(2 + 3) * 4" 복잡한 수식
- [ ] 공백 처리 로직 구현
- [ ] 잘못된 문자 처리

## 인수 조건
- [ ] 모든 테스트가 통과함
- [ ] 정수, 소수, 음수를 올바르게 토큰화함
- [ ] 모든 연산자를 인식함
- [ ] 과학 함수 이름을 인식함
- [ ] 괄호를 올바르게 처리함
- [ ] 공백을 무시함
- [ ] 잘못된 문자에 대해 에러 발생
- [ ] 코드 커버리지 >80%

## 테스트 예시
\`\`\`javascript
test('should tokenize simple expression', () => {
  const tokens = tokenizer.tokenize('2 + 3');
  expect(tokens).toEqual([
    { type: 'NUMBER', value: 2 },
    { type: 'OPERATOR', value: '+' },
    { type: 'NUMBER', value: 3 }
  ]);
});
\`\`\`
"@
    },
    @{
        title = "[Phase 1] Expression Parser - AST Parser (TDD)"
        labels = @("phase-1", "core-logic", "tdd", "parser")
        body = @"
## 작업 배경
토큰 배열을 Abstract Syntax Tree (AST)로 변환하는 파서를 구현합니다. 연산자 우선순위를 고려한 파싱이 핵심입니다.

## 작업 내용

### 1. AST 노드 타입 정의
- [ ] NumberNode, OperatorNode, FunctionNode 클래스 정의
- [ ] AST 노드 인터페이스 설계

### 2. Parser 클래스 구현 (TDD)

#### 간단한 수식 파싱
- [ ] 테스트: "2 + 3" 파싱
- [ ] 테스트: "5 - 2" 파싱
- [ ] 기본 이항 연산 파싱 구현

#### 연산자 우선순위 (PEMDAS)
- [ ] 테스트: "2 + 3 * 4" → 2 + (3 * 4) = 14
- [ ] 테스트: "10 / 2 + 3" → (10 / 2) + 3 = 8
- [ ] Shunting Yard 알고리즘 구현

#### 괄호 처리
- [ ] 테스트: "(2 + 3) * 4" → (2 + 3) * 4 = 20
- [ ] 테스트: "2 * (3 + 4)" → 2 * (3 + 4) = 14
- [ ] 테스트: 중첩 괄호 "((2 + 3) * 4) / 5"
- [ ] 괄호 우선순위 처리 구현

#### 함수 호출 파싱
- [ ] 테스트: "sin(45)" 파싱
- [ ] 테스트: "sin(30) + cos(60)" 파싱
- [ ] 함수 노드 생성 로직 구현

## 인수 조건
- [ ] 모든 테스트가 통과함
- [ ] 연산자 우선순위가 올바르게 적용됨 (곱셈/나눗셈 > 덧셈/뺄셈)
- [ ] 괄호가 최우선으로 처리됨
- [ ] 함수 호출이 올바르게 파싱됨
- [ ] 잘못된 수식에 대해 구문 에러 발생
- [ ] 괄호 불균형 시 에러 발생
- [ ] 코드 커버리지 >80%

## 테스트 예시
\`\`\`javascript
test('should parse expression with operator precedence', () => {
  const tokens = tokenizer.tokenize('2 + 3 * 4');
  const ast = parser.parse(tokens);
  // AST 구조 검증
  expect(ast.type).toBe('OPERATOR');
  expect(ast.operator).toBe('+');
  expect(ast.right.operator).toBe('*');
});
\`\`\`
"@
    },
    @{
        title = "[Phase 1] State Management (TDD)"
        labels = @("phase-1", "core-logic", "tdd", "state")
        body = @"
## 작업 배경
계산기의 상태를 관리하고 변경사항을 구독할 수 있는 StateManager를 구현합니다. Observer 패턴을 사용합니다.

## 작업 내용

### 1. StateManager 클래스 설계
- [ ] `src/js/state.js` 파일 생성
- [ ] 초기 상태 정의 (display, expression, result, angleMode 등)

### 2. TDD로 StateManager 구현

#### 상태 초기화
- [ ] 테스트: 초기 상태 값 확인
- [ ] 테스트: 기본 각도 모드 (DEG)
- [ ] StateManager 생성자 구현

#### 상태 업데이트
- [ ] 테스트: setState로 상태 업데이트
- [ ] 테스트: 부분 업데이트 (일부 속성만 변경)
- [ ] 테스트: 불변성 유지 (원본 상태 변경 안 됨)
- [ ] setState 메서드 구현

#### 상태 조회
- [ ] 테스트: getState로 현재 상태 조회
- [ ] 테스트: 반환된 상태가 복사본임 (불변성)
- [ ] getState 메서드 구현

#### Observer 패턴
- [ ] 테스트: subscribe로 리스너 등록
- [ ] 테스트: 상태 변경 시 리스너 호출
- [ ] 테스트: 여러 리스너 등록
- [ ] 테스트: unsubscribe로 리스너 제거
- [ ] subscribe/notifyListeners 구현

## 인수 조건
- [ ] 모든 테스트가 통과함
- [ ] 초기 상태가 올바르게 설정됨
- [ ] setState가 상태를 정확히 업데이트함
- [ ] 상태 불변성이 유지됨 (원본 변경 안 됨)
- [ ] 리스너가 상태 변경 시 호출됨
- [ ] 여러 리스너가 동시에 작동함
- [ ] unsubscribe가 정상 작동함
- [ ] 코드 커버리지 >80%

## 테스트 예시
\`\`\`javascript
test('should notify listeners on state change', () => {
  const listener = jest.fn();
  stateManager.subscribe(listener);
  
  stateManager.setState({ display: '123' });
  
  expect(listener).toHaveBeenCalledWith(
    expect.objectContaining({ display: '123' })
  );
});
\`\`\`
"@
    },
    @{
        title = "[Phase 1] Storage & History Management (TDD)"
        labels = @("phase-1", "core-logic", "tdd", "storage")
        body = @"
## 작업 배경
계산 히스토리와 설정을 localStorage에 저장/불러오는 기능을 구현합니다.

## 작업 내용

### 1. StorageManager 구현 (TDD)
- [ ] `src/js/storage.js` 파일 생성
- [ ] 테스트: localStorage에 데이터 저장
- [ ] 테스트: localStorage에서 데이터 읽기
- [ ] 테스트: JSON 직렬화/역직렬화
- [ ] 테스트: 존재하지 않는 키 읽기 (기본값 반환)
- [ ] 테스트: 저장 실패 처리 (quota 초과)
- [ ] StorageManager 클래스 구현

### 2. HistoryManager 구현 (TDD)
- [ ] `src/js/history.js` 파일 생성
- [ ] 테스트: 히스토리 항목 추가
- [ ] 테스트: 히스토리 전체 조회
- [ ] 테스트: 최대 항목 수 제한 (100개)
- [ ] 테스트: 히스토리 전체 삭제
- [ ] 테스트: UUID 생성
- [ ] HistoryManager 클래스 구현

### 3. localStorage 모킹
- [ ] Jest에서 localStorage 모킹 설정
- [ ] 테스트 간 localStorage 초기화

## 인수 조건
- [ ] 모든 테스트가 통과함
- [ ] localStorage에 데이터가 올바르게 저장됨
- [ ] 저장된 데이터를 정확히 읽어옴
- [ ] JSON 직렬화가 정상 작동함
- [ ] 히스토리가 최신순으로 정렬됨
- [ ] 최대 100개 항목 제한이 작동함
- [ ] 에러 처리가 적절함
- [ ] 코드 커버리지 >80%

## 테스트 예시
\`\`\`javascript
test('should add history item', () => {
  const item = historyManager.add('2 + 3', '5', 'DEG');
  
  expect(item).toHaveProperty('id');
  expect(item.expression).toBe('2 + 3');
  expect(item.result).toBe('5');
  
  const history = historyManager.getAll();
  expect(history[0]).toEqual(item);
});
\`\`\`
"@
    },
    @{
        title = "[Phase 1] UI Components - HTML Structure"
        labels = @("phase-1", "ui", "html", "accessibility")
        body = @"
## 작업 배경
계산기의 기본 HTML 구조를 시맨틱하게 작성하고 접근성을 고려합니다.

## 작업 내용

### 1. 기본 HTML 파일 생성
- [ ] `index.html` 생성
- [ ] HTML5 doctype 선언
- [ ] 메타 태그 설정 (viewport, charset, description)
- [ ] 외부 리소스 링크 (Google Fonts, Tailwind CSS, Material Icons)

### 2. 시맨틱 HTML 구조
- [ ] `<header>` 요소로 헤더 영역 생성
- [ ] `<main>` 요소로 메인 콘텐츠 영역 생성
- [ ] `<section>` 요소로 디스플레이, 툴바, 키패드 구분

### 3. 접근성 (ARIA)
- [ ] `lang="ko"` 속성 추가
- [ ] ARIA landmarks 추가 (role="main", role="navigation")
- [ ] ARIA labels 추가 (모든 버튼)
- [ ] `aria-live="polite"` 추가 (결과 디스플레이)

### 4. 컴포넌트별 HTML

#### Header
- [ ] 뒤로가기 버튼 (아이콘)
- [ ] "Scientific" 제목
- [ ] 설정 버튼 (아이콘)

#### Display
- [ ] 수식 표시 영역 (`<div id="expression">`)
- [ ] 결과 표시 영역 (`<div id="result">`)
- [ ] 드래그 핸들

#### Toolbar
- [ ] History 버튼
- [ ] Unit 버튼
- [ ] DEG/RAD 토글

#### Keypad
- [ ] 4×6 그리드 구조
- [ ] 모든 버튼에 `data-value`, `data-type` 속성 추가
- [ ] 숫자 버튼 (0-9, .)
- [ ] 연산자 버튼 (+, -, ×, ÷)
- [ ] 기능 버튼 (AC, (), %, ⌫)
- [ ] 과학 함수 버튼 (sin, cos, tan)
- [ ] 등호 버튼 (2행 span)

## 인수 조건
- [ ] HTML이 유효함 (W3C Validator 통과)
- [ ] 모든 버튼에 적절한 ARIA 레이블이 있음
- [ ] 키보드로 모든 요소에 접근 가능
- [ ] Lighthouse 접근성 점수 95+ 달성
- [ ] 시맨틱 태그가 올바르게 사용됨
- [ ] 모든 인터랙티브 요소에 data 속성이 있음

## 참고 사항
- UI 테스트는 수동으로 진행
- 브라우저에서 직접 확인
"@
    },
    @{
        title = "[Phase 1] UI Components - Styling with Tailwind CSS"
        labels = @("phase-1", "ui", "css", "styling")
        body = @"
## 작업 배경
Tailwind CSS를 사용하여 계산기의 시각적 디자인을 구현합니다. 다크 모드를 기본으로 합니다.

## 작업 내용

### 1. CSS 변수 및 테마 설정
- [ ] `src/css/themes.css` 생성
- [ ] 라이트 모드 색상 변수 정의
- [ ] 다크 모드 색상 변수 정의 (.dark 클래스)
- [ ] Tailwind CSS 커스텀 설정

### 2. 컴포넌트 스타일링

#### Header
- [ ] Flexbox 레이아웃
- [ ] 중앙 정렬 제목
- [ ] 버튼 아이콘 스타일

#### Display
- [ ] 배경색 및 패딩
- [ ] 수식 표시: 20px, 우측 정렬
- [ ] 결과 표시: 60px, 우측 정렬, 볼드
- [ ] 드래그 핸들 스타일

#### Toolbar
- [ ] Flexbox 레이아웃
- [ ] 버튼 간격
- [ ] DEG/RAD 토글 스타일 (segmented control)

#### Keypad
- [ ] CSS Grid 4×6 레이아웃
- [ ] 버튼 기본 스타일
  - 둥근 모서리
  - 그림자
  - 패딩
- [ ] 숫자 버튼 스타일
- [ ] 연산자 버튼 스타일 (파란색 배경)
- [ ] 기능 버튼 스타일
- [ ] AC 버튼 (빨간색 텍스트)
- [ ] 과학 함수 버튼 스타일
- [ ] 등호 버튼 스타일 (파란색, glow 효과, 2행 span)

### 3. 인터랙션 스타일
- [ ] 호버 효과 (brightness 변화)
- [ ] 액티브 효과 (scale 0.95)
- [ ] 트랜지션 (0.3s ease)

### 4. 반응형 디자인
- [ ] 모바일 (320px-480px) 스타일
- [ ] 태블릿 (481px-768px) 스타일
- [ ] 데스크톱 (769px+) 스타일, 최대 너비 제한

## 인수 조건

### 수동 테스트 체크리스트
- [ ] 다크 모드가 기본으로 적용됨
- [ ] 모든 버튼이 올바른 색상을 가짐
- [ ] 호버 시 버튼 색상이 변함
- [ ] 클릭 시 scale 애니메이션이 작동함
- [ ] 등호 버튼에 파란색 glow 효과가 있음
- [ ] 320px 화면에서 레이아웃이 깨지지 않음
- [ ] 1920px 화면에서 최대 너비 제한이 작동함
- [ ] 모든 텍스트가 읽기 쉬움
- [ ] 색상 대비가 WCAG AA 기준을 만족함

## 참고 문서
- [PRD.md - 디자인 시스템](../docs/PRD.md#3-디자인-시스템)
- [Design Files](../docs/design/)
"@
    },
    @{
        title = "[Phase 1] Event Handling & UI Controller"
        labels = @("phase-1", "ui", "javascript", "events")
        body = @"
## 작업 배경
사용자 인터랙션(버튼 클릭, 키보드 입력)을 처리하고 UI를 업데이트하는 로직을 구현합니다.

## 작업 내용

### 1. UIController 클래스 생성
- [ ] `src/js/ui.js` 파일 생성
- [ ] DOM 요소 참조 캐싱
- [ ] 디스플레이 업데이트 메서드 구현
  - `updateExpression(expr)`
  - `updateResult(value)`
  - `showError(message)`
  - `clearDisplay()`

### 2. 숫자 포맷팅 유틸리티 (TDD)
- [ ] `src/js/utils.js` 생성
- [ ] 테스트: 천 단위 쉼표 ("12500" → "12,500")
- [ ] 테스트: 소수점 처리 ("12.5" → "12.5")
- [ ] 테스트: 과학적 표기법 (큰 수)
- [ ] `formatNumber(num)` 함수 구현

### 3. 버튼 이벤트 핸들러
- [ ] 이벤트 위임 (keypad 컨테이너에 단일 리스너)
- [ ] 숫자 버튼 핸들러
  - 연속 입력 처리
  - 소수점 중복 방지
  - 디스플레이 실시간 업데이트
- [ ] 연산자 버튼 핸들러
  - 연산자 유효성 검사
  - 연산자 교체 로직
- [ ] 기능 버튼 핸들러
  - AC (전체 삭제)
  - 괄호 입력
  - 백스페이스
- [ ] 과학 함수 버튼 핸들러
- [ ] 등호 버튼 핸들러
  - 계산 실행
  - 결과 표시
  - 히스토리 저장

### 4. 키보드 이벤트 핸들러
- [ ] 키보드 매핑 객체 생성
- [ ] 숫자 키 (0-9) 처리
- [ ] 연산자 키 (+, -, *, /) 처리
- [ ] Enter 키 (계산 실행)
- [ ] Escape 키 (초기화)
- [ ] Backspace 키 (삭제)

### 5. 메인 앱 통합
- [ ] `src/js/main.js` 생성
- [ ] CalculatorApp 클래스 생성
- [ ] 모든 컴포넌트 초기화
- [ ] 이벤트 리스너 등록

## 인수 조건

### 수동 테스트 체크리스트

#### 버튼 클릭
- [ ] 숫자 버튼 클릭 시 디스플레이 업데이트됨
- [ ] 연산자 버튼 클릭 시 수식에 추가됨
- [ ] AC 버튼으로 전체 삭제됨
- [ ] 백스페이스로 마지막 문자 삭제됨
- [ ] 등호 버튼으로 계산 실행됨
- [ ] 결과가 올바르게 표시됨

#### 키보드 입력
- [ ] 숫자 키로 입력 가능
- [ ] 연산자 키로 입력 가능
- [ ] Enter로 계산 실행됨
- [ ] Escape로 초기화됨
- [ ] Backspace로 삭제됨

#### 에러 처리
- [ ] 0으로 나누기 시 에러 메시지 표시
- [ ] 잘못된 수식 시 에러 메시지 표시

#### 숫자 포맷팅
- [ ] 큰 수에 천 단위 쉼표 표시됨
- [ ] 소수점이 올바르게 표시됨

## 참고 사항
- UI 이벤트 핸들러는 TDD 대상이 아님 (수동 테스트)
- formatNumber 유틸리티는 TDD로 구현
"@
    },
    @{
        title = "[Phase 1] Theme System Implementation"
        labels = @("phase-1", "ui", "theme", "tdd")
        body = @"
## 작업 배경
다크/라이트 모드 전환 기능과 시스템 테마 자동 감지 기능을 구현합니다.

## 작업 내용

### 1. ThemeManager 구현 (TDD)
- [ ] `src/js/theme.js` 파일 생성
- [ ] 테스트: 초기 테마 로드 (localStorage에서)
- [ ] 테스트: 테마 적용 (dark/light)
- [ ] 테스트: 시스템 테마 감지
- [ ] 테스트: 테마 저장 (localStorage)
- [ ] 테스트: 테마 토글
- [ ] ThemeManager 클래스 구현

### 2. CSS 테마 변수
- [ ] `:root`에 라이트 모드 변수 정의
- [ ] `.dark`에 다크 모드 변수 정의
- [ ] 모든 컴포넌트에서 CSS 변수 사용

### 3. 테마 토글 UI
- [ ] 설정 버튼에 테마 토글 기능 연결
- [ ] 테마 전환 애니메이션 추가

### 4. 시스템 테마 감지
- [ ] `prefers-color-scheme` 미디어 쿼리 사용
- [ ] 시스템 테마 변경 시 자동 업데이트

## 인수 조건

### 자동화 테스트
- [ ] 모든 테스트가 통과함
- [ ] 테마 전환 로직이 정확함
- [ ] localStorage 저장/로드가 작동함
- [ ] 코드 커버리지 >80%

### 수동 테스트
- [ ] 설정 버튼 클릭 시 테마가 전환됨
- [ ] 다크 모드 색상이 올바름
- [ ] 라이트 모드 색상이 올바름
- [ ] 테마 전환 애니메이션이 부드러움
- [ ] 페이지 새로고침 후에도 테마가 유지됨
- [ ] 시스템 테마 변경 시 자동으로 반영됨 (system 모드)

## 테스트 예시
\`\`\`javascript
test('should apply dark theme', () => {
  themeManager.applyTheme('dark');
  expect(document.documentElement.classList.contains('dark')).toBe(true);
});

test('should save theme to localStorage', () => {
  themeManager.applyTheme('light');
  expect(localStorage.getItem('calculator_theme')).toBe('light');
});
\`\`\`
"@
    },
    @{
        title = "[Phase 1] Manual Testing & Quality Assurance"
        labels = @("phase-1", "testing", "qa", "manual")
        body = @"
## 작업 배경
Phase 1 MVP의 모든 기능을 수동으로 테스트하여 품질을 보장합니다.

## 작업 내용

### 1. 기능 테스트

#### 기본 계산
- [ ] 덧셈 계산 (2 + 3 = 5)
- [ ] 뺄셈 계산 (10 - 3 = 7)
- [ ] 곱셈 계산 (4 × 5 = 20)
- [ ] 나눗셈 계산 (20 ÷ 4 = 5)
- [ ] 복합 계산 (2 + 3 × 4 = 14)
- [ ] 괄호 계산 ((2 + 3) × 4 = 20)

#### 과학 함수
- [ ] sin(30) = 0.5 (DEG 모드)
- [ ] cos(60) = 0.5 (DEG 모드)
- [ ] tan(45) = 1 (DEG 모드)
- [ ] DEG/RAD 모드 전환 확인

#### 에러 처리
- [ ] 0으로 나누기 에러 표시
- [ ] 잘못된 수식 에러 표시

### 2. UI/UX 테스트

#### 버튼 인터랙션
- [ ] 모든 숫자 버튼 클릭 테스트
- [ ] 모든 연산자 버튼 클릭 테스트
- [ ] 모든 기능 버튼 클릭 테스트
- [ ] 호버 효과 확인
- [ ] 클릭 애니메이션 확인

#### 키보드 입력
- [ ] 숫자 키 (0-9) 테스트
- [ ] 연산자 키 (+, -, *, /) 테스트
- [ ] Enter 키 테스트
- [ ] Escape 키 테스트
- [ ] Backspace 키 테스트

#### 디스플레이
- [ ] 수식 표시 확인
- [ ] 결과 표시 확인
- [ ] 천 단위 쉼표 확인
- [ ] 긴 수식 오버플로우 처리

### 3. 반응형 테스트

#### 모바일 (320px - 480px)
- [ ] iPhone SE (375px) 테스트
- [ ] 버튼 크기 적절성
- [ ] 터치 영역 충분성
- [ ] 레이아웃 깨짐 없음

#### 태블릿 (481px - 768px)
- [ ] iPad (768px) 테스트
- [ ] 레이아웃 조정 확인

#### 데스크톱 (769px+)
- [ ] 1920px 화면 테스트
- [ ] 최대 너비 제한 확인
- [ ] 중앙 정렬 확인

### 4. 테마 테스트
- [ ] 다크 모드 색상 확인
- [ ] 라이트 모드 색상 확인
- [ ] 테마 전환 애니메이션
- [ ] 테마 설정 유지 (새로고침 후)

### 5. 접근성 테스트
- [ ] Lighthouse 접근성 감사 실행 (목표: 95+)
- [ ] 키보드만으로 모든 기능 사용
- [ ] Tab 키로 포커스 이동 확인
- [ ] ARIA 레이블 확인 (스크린 리더)
- [ ] 색상 대비 확인 (WCAG AA)

### 6. 브라우저 호환성 테스트
- [ ] Chrome (최신)
- [ ] Firefox (최신)
- [ ] Safari (최신)
- [ ] Edge (최신)
- [ ] 모바일 Safari (iOS)
- [ ] 모바일 Chrome (Android)

### 7. 성능 테스트
- [ ] Lighthouse 성능 점수 (목표: 90+)
- [ ] First Contentful Paint < 1.5s
- [ ] Time to Interactive < 3s
- [ ] 버튼 클릭 반응 < 50ms

## 인수 조건
- [ ] 모든 기능 테스트 통과
- [ ] 모든 UI/UX 테스트 통과
- [ ] 모든 반응형 테스트 통과
- [ ] Lighthouse 접근성 95+ 달성
- [ ] Lighthouse 성능 90+ 달성
- [ ] 모든 주요 브라우저에서 정상 작동
- [ ] 치명적인 버그 없음

## 테스트 결과 문서화
- [ ] 발견된 버그 리스트 작성
- [ ] 스크린샷 첨부 (각 화면 크기별)
- [ ] Lighthouse 리포트 저장
"@
    },
    @{
        title = "[Phase 1] Documentation & Deployment"
        labels = @("phase-1", "documentation", "deployment")
        body = @"
## 작업 배경
프로젝트 문서를 완성하고 GitHub Pages에 배포합니다.

## 작업 내용

### 1. README.md 업데이트
- [ ] 프로젝트 설명 추가
- [ ] 기능 목록 작성
- [ ] 스크린샷 추가
- [ ] 설치 방법 작성
- [ ] 사용 방법 작성
- [ ] 개발 환경 설정 가이드
- [ ] 기여 가이드라인
- [ ] 라이선스 정보

### 2. API 문서 작성
- [ ] Calculator 클래스 문서
- [ ] StateManager 클래스 문서
- [ ] Parser 클래스 문서
- [ ] 유틸리티 함수 문서

### 3. 사용자 가이드 작성
- [ ] 키보드 단축키 목록
- [ ] 과학 함수 사용법
- [ ] 예제 계산식
- [ ] FAQ

### 4. CHANGELOG.md 작성
- [ ] v1.0.0 변경사항 정리
- [ ] 추가된 기능 목록
- [ ] 알려진 이슈

### 5. 배포 준비
- [ ] 프로덕션 빌드 테스트
- [ ] 번들 크기 확인 및 최적화
- [ ] 소스맵 생성 설정
- [ ] 에러 추적 설정 (선택사항)

### 6. GitHub Pages 배포
- [ ] GitHub Actions 워크플로우 실행
- [ ] 배포 성공 확인
- [ ] 배포된 사이트 테스트
- [ ] 도메인 설정 (선택사항)

### 7. 릴리스 노트 작성
- [ ] GitHub Release 생성
- [ ] v1.0.0 태그 생성
- [ ] 릴리스 노트 작성
- [ ] 바이너리 첨부 (해당 시)

## 인수 조건
- [ ] README.md가 완성되어 있음
- [ ] 모든 주요 클래스에 JSDoc 주석이 있음
- [ ] 사용자 가이드가 작성되어 있음
- [ ] CHANGELOG.md가 업데이트되어 있음
- [ ] GitHub Pages에 성공적으로 배포됨
- [ ] 배포된 사이트가 정상 작동함
- [ ] GitHub Release가 생성되어 있음
- [ ] 모든 문서 링크가 작동함

## 배포 URL
- GitHub Pages: `https://hoseongryu23.github.io/calculator-demo/`

## 참고 사항
- 배포 후 실제 환경에서 최종 테스트 필요
- 사용자 피드백 수집 준비
"@
    }
)

Write-Host "Creating GitHub Issues..." -ForegroundColor Cyan
Write-Host ""

$createdIssues = @()

foreach ($issue in $issues) {
    try {
        $body = @{
            title = $issue.title
            body = $issue.body
            labels = $issue.labels
        } | ConvertTo-Json -Depth 10

        Write-Host "Creating: $($issue.title)" -ForegroundColor Yellow
        
        $response = Invoke-RestMethod -Uri $baseUrl -Method Post -Headers $headers -Body $body -ContentType "application/json"
        
        $createdIssues += @{
            number = $response.number
            title = $response.title
            url = $response.html_url
        }
        
        Write-Host "  ✓ Created #$($response.number)" -ForegroundColor Green
        Write-Host "  URL: $($response.html_url)" -ForegroundColor Gray
        Write-Host ""
        
        # Rate limiting - GitHub API allows 5000 requests per hour
        Start-Sleep -Milliseconds 500
    }
    catch {
        Write-Host "  ✗ Failed: $_" -ForegroundColor Red
        Write-Host ""
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "Created $($createdIssues.Count) out of $($issues.Count) issues" -ForegroundColor Green
Write-Host ""
Write-Host "Created Issues:" -ForegroundColor Cyan
foreach ($created in $createdIssues) {
    Write-Host "  #$($created.number): $($created.title)" -ForegroundColor White
    Write-Host "  $($created.url)" -ForegroundColor Gray
}
