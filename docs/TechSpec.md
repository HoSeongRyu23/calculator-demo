# Technical Specification Document
# Engineering Calculator Web App

## 문서 정보
- **버전**: 1.0
- **작성일**: 2025-12-23
- **관련 문서**: [PRD.md](./PRD.md)
- **상태**: Draft

---

## 1. 시스템 아키텍처

### 1.1 전체 구조
```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (HTML + Tailwind CSS + JavaScript)     │
├─────────────────────────────────────────┤
│         Application Layer               │
│  - Calculator Engine                    │
│  - State Management                     │
│  - Event Handlers                       │
├─────────────────────────────────────────┤
│         Data Layer                      │
│  - Local Storage (History, Settings)    │
│  - Session Storage (Temp State)         │
└─────────────────────────────────────────┘
```

### 1.2 아키텍처 패턴
- **MVC (Model-View-Controller)** 변형
  - **Model**: 계산 상태 및 데이터
  - **View**: DOM 조작 및 UI 렌더링
  - **Controller**: 이벤트 핸들링 및 비즈니스 로직

### 1.3 모듈 구조
```
calculator-demo/
├── index.html              # 메인 HTML
├── css/
│   ├── styles.css         # 커스텀 CSS
│   └── themes.css         # 테마 변수
├── js/
│   ├── main.js           # 앱 초기화
│   ├── calculator.js     # 계산 엔진
│   ├── ui.js             # UI 컨트롤러
│   ├── state.js          # 상태 관리
│   ├── storage.js        # 로컬 스토리지 관리
│   └── utils.js          # 유틸리티 함수
├── assets/
│   └── icons/            # 커스텀 아이콘 (필요시)
└── docs/
    ├── PRD.md
    └── TechSpec.md
```

---

## 2. 기술 스택 상세

### 2.1 프론트엔드 기술

#### HTML5
- **버전**: HTML5 (Living Standard)
- **시맨틱 태그**: `<header>`, `<main>`, `<section>`, `<button>`
- **접근성**: ARIA 속성 적용

#### CSS
- **Tailwind CSS**: v3.4+ (CDN 또는 빌드 버전)
  - 유틸리티 우선 스타일링
  - 다크 모드: `class` 전략 사용
  - 커스텀 컬러 팔레트 정의
  - JIT (Just-In-Time) 모드
  
- **커스텀 CSS**:
  - 애니메이션 키프레임
  - 복잡한 그리드 레이아웃
  - 특수 효과 (그림자, 그라디언트)

#### JavaScript
- **Vanilla JavaScript (ES6+)**
  - 모듈 시스템: ES Modules (`import`/`export`)
  - 비동기 처리: `async`/`await`
  - 최신 문법: Arrow functions, Destructuring, Template literals
  
- **타겟 브라우저**: ES6 지원 브라우저
  - Chrome 60+
  - Firefox 60+
  - Safari 12+
  - Edge 79+

### 2.2 외부 라이브러리

#### 필수 라이브러리
1. **Tailwind CSS** (v3.4.1)
   ```html
   <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
   ```

2. **Google Fonts - Space Grotesk**
   ```html
   <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;700&display=swap" rel="stylesheet">
   ```

3. **Material Symbols Outlined**
   ```html
   <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
   ```

#### 선택적 라이브러리 (Phase 2+)
1. **decimal.js** (v10.4+)
   - 목적: 정밀한 부동소수점 연산
   - 사용처: 금융 계산, 높은 정밀도 요구 시
   ```javascript
   import Decimal from 'decimal.js';
   ```

2. **math.js** (v12.0+)
   - 목적: 복잡한 수학 연산 (행렬, 복소수 등)
   - 사용처: Phase 3-4 고급 기능
   ```javascript
   import { evaluate, sin, cos } from 'mathjs';
   ```

### 2.3 개발 도구

#### 빌드 도구 (선택사항)
- **Vite** (v5.0+): 빠른 개발 서버 및 빌드
  ```bash
  npm create vite@latest calculator-demo -- --template vanilla
  ```

#### 코드 품질
- **ESLint**: JavaScript 린팅
  - 설정: `eslint-config-airbnb-base`
  
- **Prettier**: 코드 포맷팅
  - 설정: `.prettierrc`

#### 버전 관리
- **Git**: 소스 코드 관리
- **GitHub**: 원격 저장소

---

## 3. 데이터 구조 및 상태 관리

### 3.1 상태 객체 정의

```javascript
// state.js
export const initialState = {
  // 현재 디스플레이 값
  display: '0',
  
  // 입력 중인 수식
  expression: '',
  
  // 계산 결과
  result: null,
  
  // 이전 결과 (연속 계산용)
  previousResult: null,
  
  // 현재 연산자
  operator: null,
  
  // 각도 모드 (DEG 또는 RAD)
  angleMode: 'DEG',
  
  // 결과 표시 상태
  isResultDisplayed: false,
  
  // 에러 상태
  error: null,
  
  // 계산 히스토리
  history: [],
  
  // 설정
  settings: {
    theme: 'dark', // 'light' | 'dark' | 'system'
    decimalPlaces: 10,
    thousandsSeparator: true,
    soundEnabled: false
  }
};
```

### 3.2 상태 관리 패턴

```javascript
// state.js
class StateManager {
  constructor(initialState) {
    this.state = { ...initialState };
    this.listeners = [];
  }
  
  // 상태 업데이트
  setState(updates) {
    this.state = { ...this.state, ...updates };
    this.notifyListeners();
  }
  
  // 상태 조회
  getState() {
    return { ...this.state };
  }
  
  // 리스너 등록
  subscribe(listener) {
    this.listeners.push(listener);
    return () => {
      this.listeners = this.listeners.filter(l => l !== listener);
    };
  }
  
  // 리스너 알림
  notifyListeners() {
    this.listeners.forEach(listener => listener(this.state));
  }
}

export const stateManager = new StateManager(initialState);
```

### 3.3 로컬 스토리지 스키마

```javascript
// storage.js
const STORAGE_KEYS = {
  HISTORY: 'calculator_history',
  SETTINGS: 'calculator_settings',
  LAST_STATE: 'calculator_last_state'
};

// 히스토리 항목 구조
interface HistoryItem {
  id: string;              // UUID
  expression: string;      // "12,500 + sin(45)"
  result: string;          // "12,500.707"
  timestamp: number;       // Unix timestamp
  angleMode: 'DEG' | 'RAD';
}

// 설정 구조
interface Settings {
  theme: 'light' | 'dark' | 'system';
  decimalPlaces: number;
  thousandsSeparator: boolean;
  soundEnabled: boolean;
}
```

---

## 4. 계산 엔진 구현

### 4.1 계산기 클래스 구조

```javascript
// calculator.js
export class Calculator {
  constructor() {
    this.angleMode = 'DEG';
  }
  
  // 기본 연산
  add(a, b) { return a + b; }
  subtract(a, b) { return a - b; }
  multiply(a, b) { return a * b; }
  divide(a, b) {
    if (b === 0) throw new Error('Division by zero');
    return a / b;
  }
  
  // 과학 함수
  sin(angle) {
    const radians = this.toRadians(angle);
    return Math.sin(radians);
  }
  
  cos(angle) {
    const radians = this.toRadians(angle);
    return Math.cos(radians);
  }
  
  tan(angle) {
    const radians = this.toRadians(angle);
    return Math.tan(radians);
  }
  
  // 각도 변환
  toRadians(angle) {
    return this.angleMode === 'DEG' ? angle * (Math.PI / 180) : angle;
  }
  
  toDegrees(radians) {
    return this.angleMode === 'RAD' ? radians : radians * (180 / Math.PI);
  }
  
  // 수식 평가
  evaluate(expression) {
    try {
      // 안전한 수식 평가 로직
      return this.safeEval(expression);
    } catch (error) {
      throw new Error('Invalid expression');
    }
  }
  
  // 안전한 eval 구현
  safeEval(expression) {
    // Function constructor를 사용한 안전한 평가
    // 또는 수식 파서 구현
  }
}
```

### 4.2 수식 파싱 전략

#### Option 1: Function Constructor (간단)
```javascript
function evaluateExpression(expr) {
  // 위험한 문자 제거
  const sanitized = expr.replace(/[^0-9+\-*/.()sincotan\s]/g, '');
  
  // 안전한 평가
  const func = new Function('Math', `return ${sanitized}`);
  return func(Math);
}
```

#### Option 2: 토큰 기반 파서 (권장)
```javascript
class ExpressionParser {
  tokenize(expression) {
    // 수식을 토큰으로 분리
    // 예: "12+sin(45)" -> ['12', '+', 'sin', '(', '45', ')']
  }
  
  parse(tokens) {
    // 토큰을 AST로 변환
  }
  
  evaluate(ast) {
    // AST를 평가하여 결과 반환
  }
}
```

### 4.3 에러 처리

```javascript
class CalculatorError extends Error {
  constructor(type, message) {
    super(message);
    this.type = type;
    this.name = 'CalculatorError';
  }
}

// 에러 타입
const ERROR_TYPES = {
  DIVISION_BY_ZERO: 'division_by_zero',
  SYNTAX_ERROR: 'syntax_error',
  OVERFLOW: 'overflow',
  UNDEFINED: 'undefined',
  INVALID_INPUT: 'invalid_input'
};

// 사용 예
function safeDivide(a, b) {
  if (b === 0) {
    throw new CalculatorError(
      ERROR_TYPES.DIVISION_BY_ZERO,
      'Cannot divide by zero'
    );
  }
  return a / b;
}
```

---

## 5. UI 컴포넌트 구현

### 5.1 컴포넌트 계층 구조

```
App
├── Header
│   ├── Title
│   └── SettingsButton
├── Display
│   ├── ExpressionDisplay
│   ├── ResultDisplay
│   └── DragHandle
├── Toolbar
│   ├── HistoryButton
│   ├── UnitButton
│   └── AngleModeToggle
└── Keypad
    ├── FunctionRow (AC, (), %, ÷)
    ├── ScientificRow (sin, cos, tan, ×)
    ├── NumberRows (7-9, 4-6, 1-3, 0)
    └── EqualsButton
```

### 5.2 DOM 조작 전략

```javascript
// ui.js
export class UIController {
  constructor() {
    this.elements = {
      display: document.getElementById('display'),
      expression: document.getElementById('expression'),
      result: document.getElementById('result'),
      keypad: document.getElementById('keypad')
    };
  }
  
  // 디스플레이 업데이트
  updateDisplay(value) {
    this.elements.display.textContent = this.formatNumber(value);
  }
  
  // 수식 표시
  updateExpression(expr) {
    this.elements.expression.textContent = expr;
  }
  
  // 숫자 포맷팅 (천 단위 쉼표)
  formatNumber(num) {
    const parts = num.toString().split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return parts.join('.');
  }
  
  // 버튼 이벤트 리스너 등록
  attachEventListeners(handlers) {
    this.elements.keypad.addEventListener('click', (e) => {
      const button = e.target.closest('button');
      if (!button) return;
      
      const value = button.dataset.value;
      const type = button.dataset.type;
      
      if (handlers[type]) {
        handlers[type](value);
      }
    });
  }
}
```

### 5.3 애니메이션 구현

```css
/* styles.css */

/* 페이드인 애니메이션 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn 0.5s ease-out forwards;
}

/* 버튼 클릭 효과 */
.button-press {
  transition: transform 0.1s ease-out;
}

.button-press:active {
  transform: scale(0.95);
}

/* 결과 변경 애니메이션 */
@keyframes resultChange {
  0% {
    opacity: 0.5;
    transform: scale(0.98);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

.result-update {
  animation: resultChange 0.3s ease-out;
}
```

---

## 6. 이벤트 처리

### 6.1 이벤트 핸들러 구조

```javascript
// main.js
class CalculatorApp {
  constructor() {
    this.calculator = new Calculator();
    this.ui = new UIController();
    this.state = stateManager;
    
    this.initEventHandlers();
  }
  
  initEventHandlers() {
    // 숫자 버튼
    this.ui.attachEventListeners({
      number: (value) => this.handleNumber(value),
      operator: (op) => this.handleOperator(op),
      function: (fn) => this.handleFunction(fn),
      equals: () => this.handleEquals(),
      clear: () => this.handleClear(),
      backspace: () => this.handleBackspace()
    });
    
    // 키보드 이벤트
    document.addEventListener('keydown', (e) => this.handleKeyboard(e));
    
    // 테마 토글
    document.getElementById('theme-toggle')?.addEventListener('click', 
      () => this.toggleTheme()
    );
  }
  
  handleNumber(value) {
    const currentDisplay = this.state.getState().display;
    
    // 결과 표시 후 새 숫자 입력 시 초기화
    if (this.state.getState().isResultDisplayed) {
      this.state.setState({ 
        display: value,
        isResultDisplayed: false 
      });
    } else {
      this.state.setState({ 
        display: currentDisplay === '0' ? value : currentDisplay + value 
      });
    }
    
    this.ui.updateDisplay(this.state.getState().display);
  }
  
  handleOperator(operator) {
    // 연산자 처리 로직
  }
  
  handleEquals() {
    try {
      const expression = this.state.getState().expression;
      const result = this.calculator.evaluate(expression);
      
      this.state.setState({
        result,
        display: result.toString(),
        isResultDisplayed: true
      });
      
      this.ui.updateDisplay(result);
      this.addToHistory(expression, result);
    } catch (error) {
      this.handleError(error);
    }
  }
}
```

### 6.2 키보드 매핑

```javascript
const KEYBOARD_MAP = {
  '0': { type: 'number', value: '0' },
  '1': { type: 'number', value: '1' },
  '2': { type: 'number', value: '2' },
  '3': { type: 'number', value: '3' },
  '4': { type: 'number', value: '4' },
  '5': { type: 'number', value: '5' },
  '6': { type: 'number', value: '6' },
  '7': { type: 'number', value: '7' },
  '8': { type: 'number', value: '8' },
  '9': { type: 'number', value: '9' },
  '.': { type: 'number', value: '.' },
  '+': { type: 'operator', value: '+' },
  '-': { type: 'operator', value: '-' },
  '*': { type: 'operator', value: '×' },
  '/': { type: 'operator', value: '÷' },
  'Enter': { type: 'equals' },
  'Escape': { type: 'clear' },
  'Backspace': { type: 'backspace' },
  '(': { type: 'function', value: '(' },
  ')': { type: 'function', value: ')' }
};

function handleKeyboard(event) {
  const mapping = KEYBOARD_MAP[event.key];
  if (mapping) {
    event.preventDefault();
    // 해당 핸들러 호출
  }
}
```

---

## 7. 테마 시스템

### 7.1 CSS 변수 정의

```css
/* themes.css */
:root {
  /* Light Theme */
  --bg-primary: #f6f6f8;
  --bg-surface: #ffffff;
  --bg-keypad: #ffffff;
  --text-primary: #000000;
  --text-secondary: #6b7280;
  --color-primary: #135bec;
  --button-number-bg: #ffffff;
  --button-function-bg: #f3f4f6;
  --button-operator-bg: #eff6ff;
}

.dark {
  /* Dark Theme */
  --bg-primary: #101622;
  --bg-surface: #1e2532;
  --bg-keypad: #161e2c;
  --text-primary: #ffffff;
  --text-secondary: #9ca3af;
  --color-primary: #135bec;
  --button-number-bg: rgba(30, 37, 50, 0.5);
  --button-function-bg: #1e2532;
  --button-operator-bg: #1f293a;
}
```

### 7.2 테마 전환 로직

```javascript
// themes.js
export class ThemeManager {
  constructor() {
    this.currentTheme = this.getStoredTheme() || 'dark';
    this.applyTheme(this.currentTheme);
  }
  
  applyTheme(theme) {
    if (theme === 'system') {
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      theme = prefersDark ? 'dark' : 'light';
    }
    
    document.documentElement.classList.toggle('dark', theme === 'dark');
    this.currentTheme = theme;
    this.saveTheme(theme);
  }
  
  toggleTheme() {
    const newTheme = this.currentTheme === 'dark' ? 'light' : 'dark';
    this.applyTheme(newTheme);
  }
  
  getStoredTheme() {
    return localStorage.getItem('calculator_theme');
  }
  
  saveTheme(theme) {
    localStorage.setItem('calculator_theme', theme);
  }
}
```

---

## 8. 로컬 스토리지 관리

### 8.1 스토리지 유틸리티

```javascript
// storage.js
export class StorageManager {
  constructor(prefix = 'calculator_') {
    this.prefix = prefix;
  }
  
  // 데이터 저장
  set(key, value) {
    try {
      const serialized = JSON.stringify(value);
      localStorage.setItem(this.prefix + key, serialized);
      return true;
    } catch (error) {
      console.error('Storage error:', error);
      return false;
    }
  }
  
  // 데이터 조회
  get(key, defaultValue = null) {
    try {
      const item = localStorage.getItem(this.prefix + key);
      return item ? JSON.parse(item) : defaultValue;
    } catch (error) {
      console.error('Storage error:', error);
      return defaultValue;
    }
  }
  
  // 데이터 삭제
  remove(key) {
    localStorage.removeItem(this.prefix + key);
  }
  
  // 전체 삭제
  clear() {
    Object.keys(localStorage)
      .filter(key => key.startsWith(this.prefix))
      .forEach(key => localStorage.removeItem(key));
  }
}
```

### 8.2 히스토리 관리

```javascript
// history.js
export class HistoryManager {
  constructor(storage) {
    this.storage = storage;
    this.maxItems = 100;
  }
  
  // 히스토리 추가
  add(expression, result, angleMode) {
    const history = this.getAll();
    const item = {
      id: this.generateId(),
      expression,
      result,
      angleMode,
      timestamp: Date.now()
    };
    
    history.unshift(item);
    
    // 최대 개수 제한
    if (history.length > this.maxItems) {
      history.pop();
    }
    
    this.storage.set('history', history);
    return item;
  }
  
  // 전체 히스토리 조회
  getAll() {
    return this.storage.get('history', []);
  }
  
  // 히스토리 삭제
  clear() {
    this.storage.set('history', []);
  }
  
  // UUID 생성
  generateId() {
    return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
  }
}
```

---

## 9. 성능 최적화

### 9.1 디바운싱 및 쓰로틀링

```javascript
// utils.js

// 디바운스 (연속 입력 최적화)
export function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// 쓰로틀 (이벤트 제한)
export function throttle(func, limit) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

// 사용 예
const debouncedSave = debounce((state) => {
  storage.set('last_state', state);
}, 500);
```

### 9.2 레이지 로딩

```javascript
// 히스토리 패널 레이지 로드
async function loadHistoryPanel() {
  const { HistoryPanel } = await import('./components/HistoryPanel.js');
  return new HistoryPanel();
}

// 사용 시에만 로드
document.getElementById('history-btn').addEventListener('click', async () => {
  if (!this.historyPanel) {
    this.historyPanel = await loadHistoryPanel();
  }
  this.historyPanel.show();
});
```

### 9.3 메모이제이션

```javascript
// 계산 결과 캐싱
class Calculator {
  constructor() {
    this.cache = new Map();
  }
  
  evaluate(expression) {
    // 캐시 확인
    if (this.cache.has(expression)) {
      return this.cache.get(expression);
    }
    
    // 계산 수행
    const result = this.performCalculation(expression);
    
    // 캐시 저장 (최대 100개)
    if (this.cache.size >= 100) {
      const firstKey = this.cache.keys().next().value;
      this.cache.delete(firstKey);
    }
    this.cache.set(expression, result);
    
    return result;
  }
}
```

---

## 10. 테스트 전략

> **중요**: TDD는 **코어 로직에만** 적용됩니다. UI 컴포넌트와 DOM 조작은 자동화 테스트 대상이 아닙니다.

### 10.1 자동화 테스트 범위

#### 테스트 대상 (TDD 적용)
- ✅ 계산 엔진 (Calculator 클래스)
- ✅ 수식 파서 (Tokenizer, Parser, Evaluator)
- ✅ 상태 관리 (StateManager)
- ✅ 스토리지 관리 (StorageManager, HistoryManager)
- ✅ 유틸리티 함수 (formatNumber, debounce 등)
- ✅ 에러 처리 로직

#### 테스트 제외 (수동 테스트)
- ❌ UI 컴포넌트 (HTML, CSS)
- ❌ DOM 조작 (UIController의 DOM 업데이트)
- ❌ 이벤트 핸들러 (버튼 클릭, 키보드 입력)
- ❌ 애니메이션 및 시각적 효과
- ❌ 브라우저 API (localStorage는 모킹하여 테스트)

### 10.2 단위 테스트 (Jest)

```javascript
// calculator.test.js
import { Calculator } from './calculator.js';

describe('Calculator', () => {
  let calc;
  
  beforeEach(() => {
    calc = new Calculator();
  });
  
  describe('Basic Operations', () => {
    test('should add two numbers', () => {
      expect(calc.add(2, 3)).toBe(5);
    });
    
    test('should throw error on division by zero', () => {
      expect(() => calc.divide(5, 0)).toThrow('Division by zero');
    });
  });
  
  describe('Scientific Functions', () => {
    test('should calculate sine in degrees', () => {
      calc.angleMode = 'DEG';
      expect(calc.sin(30)).toBeCloseTo(0.5, 5);
    });
    
    test('should calculate sine in radians', () => {
      calc.angleMode = 'RAD';
      expect(calc.sin(Math.PI / 6)).toBeCloseTo(0.5, 5);
    });
  });
});
```

### 10.3 통합 테스트 (코어 로직만)

```javascript
// integration.test.js
import { Calculator } from './calculator.js';
import { StateManager } from './state.js';
import { ExpressionParser } from './parser.js';

describe('Calculation Flow Integration', () => {
  let calculator;
  let parser;
  let stateManager;
  
  beforeEach(() => {
    calculator = new Calculator();
    parser = new ExpressionParser();
    stateManager = new StateManager();
  });
  
  test('should evaluate complex expression', () => {
    const expression = '2 + 3 * 4';
    const tokens = parser.tokenize(expression);
    const ast = parser.parse(tokens);
    const result = calculator.evaluate(ast);
    
    expect(result).toBe(14); // 연산자 우선순위 확인
  });
  
  test('should handle scientific functions in expression', () => {
    calculator.angleMode = 'DEG';
    const expression = 'sin(30) + cos(60)';
    const result = calculator.evaluate(parser.parse(parser.tokenize(expression)));
    
    expect(result).toBeCloseTo(1.0, 5);
  });
});
```

### 10.4 수동 UI 테스트 가이드

#### 기본 인터랙션 테스트
1. **버튼 클릭 테스트**
   - 각 숫자 버튼 클릭 시 디스플레이 업데이트 확인
   - 연산자 버튼 클릭 시 수식 표시 확인
   - 등호 버튼 클릭 시 결과 계산 확인

2. **키보드 입력 테스트**
   - 숫자 키 (0-9) 입력
   - 연산자 키 (+, -, *, /) 입력
   - Enter 키로 계산 실행
   - Escape 키로 초기화
   - Backspace 키로 삭제

3. **애니메이션 테스트**
   - 버튼 클릭 시 scale 애니메이션 확인
   - 결과 표시 시 fade-in 효과 확인
   - 테마 전환 시 부드러운 전환 확인

#### 반응형 테스트
- **모바일** (320px - 480px): 버튼 크기, 터치 영역 확인
- **태블릿** (481px - 768px): 레이아웃 조정 확인
- **데스크톱** (769px+): 최대 너비 제한 확인

#### 테마 테스트
- 다크 모드 색상 확인
- 라이트 모드 색상 확인
- 시스템 테마 자동 감지 확인
- 테마 설정 localStorage 저장 확인

#### 접근성 테스트
- Lighthouse 접근성 감사 실행
- 키보드만으로 모든 기능 사용 가능 확인
- 스크린 리더로 ARIA 레이블 확인
- 색상 대비 검사 (WCAG AA 기준)

#### 브라우저 호환성 테스트
- Chrome (최신 + 2개 이전 버전)
- Firefox (최신 + 2개 이전 버전)
- Safari (최신, iOS 포함)
- Edge (최신)

### 10.5 테스트 커버리지 목표

- **코어 로직**: >80% 코드 커버리지
- **UI 코드**: 수동 테스트로 검증 (커버리지 측정 안 함)

---

## 11. 빌드 및 배포

### 11.1 배포 전략
- **빌드**: GitHub Actions (자동화된 CI/CD)
- **호스팅**: GitHub Pages (정적 사이트 호스팅)
- **도메인**: `https://<username>.github.io/calculator-demo/`

### 11.2 Vite 설정

```javascript
// vite.config.js
import { defineConfig } from 'vite';

export default defineConfig({
  // GitHub Pages 배포를 위한 base path 설정
  base: '/calculator-demo/',
  
  build: {
    outDir: 'dist',
    sourcemap: true,
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true
      }
    },
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['decimal.js'] // 필요시 추가
        }
      }
    }
  },
  
  server: {
    port: 5173,
    open: true
  }
});
```

### 11.3 package.json 스크립트

```json
{
  "name": "calculator-demo",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "jest",
    "test:e2e": "playwright test",
    "lint": "eslint src/**/*.js",
    "format": "prettier --write src/**/*.js"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "jest": "^29.0.0",
    "@playwright/test": "^1.40.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0"
  }
}
```

### 11.4 GitHub Actions 워크플로우

```yaml
# .github/workflows/deploy.yml
name: Build and Deploy to GitHub Pages

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

# GitHub Pages 배포를 위한 권한 설정
permissions:
  contents: read
  pages: write
  id-token: write

# 동시 배포 방지
concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  # 빌드 작업
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run tests
        run: npm test
        continue-on-error: true
      
      - name: Build project
        run: npm run build
      
      - name: Setup Pages
        uses: actions/configure-pages@v4
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: './dist'
  
  # 배포 작업 (main 브랜치에만)
  deploy:
    if: github.ref == 'refs/heads/main'
    needs: build
    runs-on: ubuntu-latest
    
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 11.5 GitHub Pages 설정 방법

#### 1. 저장소 설정
```bash
# 1. GitHub에 저장소 생성
# 2. 로컬 저장소 초기화 및 푸시
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/<username>/calculator-demo.git
git push -u origin main
```

#### 2. GitHub Pages 활성화
1. GitHub 저장소 → **Settings** 탭
2. 좌측 메뉴에서 **Pages** 선택
3. **Source** 섹션에서:
   - Source: **GitHub Actions** 선택
4. 저장 후 자동 배포 시작

#### 3. 배포 확인
- Actions 탭에서 워크플로우 실행 확인
- 배포 완료 후 `https://<username>.github.io/calculator-demo/` 접속

### 11.6 환경별 설정

```javascript
// vite.config.js - 환경별 설정 추가
import { defineConfig } from 'vite';

export default defineConfig(({ mode }) => {
  const isProduction = mode === 'production';
  
  return {
    base: isProduction ? '/calculator-demo/' : '/',
    
    build: {
      outDir: 'dist',
      sourcemap: !isProduction,
      minify: isProduction ? 'terser' : false,
      terserOptions: isProduction ? {
        compress: {
          drop_console: true,
          drop_debugger: true
        }
      } : undefined
    },
    
    server: {
      port: 5173,
      open: true
    }
  };
});
```

---

## 12. 보안 고려사항

### 12.1 입력 검증

```javascript
// 안전한 입력 검증
function sanitizeInput(input) {
  // 허용된 문자만 통과
  const allowedChars = /^[0-9+\-*/.()sincotan\s]+$/;
  
  if (!allowedChars.test(input)) {
    throw new Error('Invalid characters in expression');
  }
  
  return input;
}

// XSS 방지
function escapeHTML(str) {
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}
```

### 12.2 Content Security Policy

```html
<!-- index.html -->
<meta http-equiv="Content-Security-Policy" 
      content="default-src 'self'; 
               script-src 'self' https://cdn.tailwindcss.com; 
               style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; 
               font-src https://fonts.gstatic.com;">
```

---

## 13. 접근성 구현

### 13.1 ARIA 속성

```html
<!-- 계산기 메인 영역 -->
<main role="main" aria-label="Calculator">
  <!-- 디스플레이 -->
  <div role="status" aria-live="polite" aria-atomic="true">
    <div id="expression" aria-label="Current expression">12 + 3</div>
    <div id="result" aria-label="Result">15</div>
  </div>
  
  <!-- 키패드 -->
  <div role="grid" aria-label="Calculator keypad">
    <button role="gridcell" 
            aria-label="Number 7" 
            data-value="7">7</button>
    <button role="gridcell" 
            aria-label="Add" 
            data-value="+" 
            aria-keyshortcuts="+">+</button>
  </div>
</main>
```

### 13.2 키보드 네비게이션

```javascript
// 포커스 관리
class FocusManager {
  constructor() {
    this.focusableElements = [];
    this.currentIndex = 0;
  }
  
  init() {
    this.focusableElements = Array.from(
      document.querySelectorAll('button:not([disabled])')
    );
  }
  
  handleKeyNavigation(event) {
    switch(event.key) {
      case 'ArrowRight':
        this.moveFocus(1);
        break;
      case 'ArrowLeft':
        this.moveFocus(-1);
        break;
      case 'ArrowDown':
        this.moveFocus(4); // 4열 그리드
        break;
      case 'ArrowUp':
        this.moveFocus(-4);
        break;
    }
  }
  
  moveFocus(delta) {
    this.currentIndex = (this.currentIndex + delta + this.focusableElements.length) 
                        % this.focusableElements.length;
    this.focusableElements[this.currentIndex].focus();
  }
}
```

---

## 14. 모니터링 및 로깅

### 14.1 에러 로깅

```javascript
// logger.js
class Logger {
  constructor(level = 'info') {
    this.level = level;
    this.levels = ['debug', 'info', 'warn', 'error'];
  }
  
  log(level, message, data = {}) {
    if (this.levels.indexOf(level) >= this.levels.indexOf(this.level)) {
      console[level](`[${new Date().toISOString()}] ${message}`, data);
      
      // 프로덕션에서는 외부 서비스로 전송
      if (level === 'error' && process.env.NODE_ENV === 'production') {
        this.sendToMonitoring(level, message, data);
      }
    }
  }
  
  debug(message, data) { this.log('debug', message, data); }
  info(message, data) { this.log('info', message, data); }
  warn(message, data) { this.log('warn', message, data); }
  error(message, data) { this.log('error', message, data); }
  
  sendToMonitoring(level, message, data) {
    // Sentry, LogRocket 등으로 전송
  }
}

export const logger = new Logger(
  process.env.NODE_ENV === 'production' ? 'warn' : 'debug'
);
```

### 14.2 성능 모니터링

```javascript
// performance.js
class PerformanceMonitor {
  measureCalculation(expression, calculationFn) {
    const start = performance.now();
    const result = calculationFn();
    const end = performance.now();
    
    const duration = end - start;
    
    if (duration > 100) {
      logger.warn('Slow calculation detected', {
        expression,
        duration: `${duration.toFixed(2)}ms`
      });
    }
    
    return result;
  }
  
  measureRender(componentName, renderFn) {
    performance.mark(`${componentName}-start`);
    const result = renderFn();
    performance.mark(`${componentName}-end`);
    
    performance.measure(
      componentName,
      `${componentName}-start`,
      `${componentName}-end`
    );
    
    return result;
  }
}
```

---

## 15. 개발 워크플로우

### 15.1 개발 환경 설정

```bash
# 1. 프로젝트 초기화
npm create vite@latest calculator-demo -- --template vanilla
cd calculator-demo

# 2. 의존성 설치
npm install

# 3. 개발 도구 설치
npm install -D eslint prettier jest @playwright/test

# 4. Tailwind CSS 설정 (선택사항)
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init

# 5. 개발 서버 실행
npm run dev
```

### 15.2 코드 스타일 가이드

```javascript
// .eslintrc.js
module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: 'eslint:recommended',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module'
  },
  rules: {
    'indent': ['error', 2],
    'quotes': ['error', 'single'],
    'semi': ['error', 'always'],
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off'
  }
};
```

```json
// .prettierrc
{
  "singleQuote": true,
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": true,
  "printWidth": 80
}
```

---

## 16. 브라우저 호환성

### 16.1 Polyfills

```javascript
// polyfills.js

// Promise (IE11)
if (!window.Promise) {
  import('promise-polyfill');
}

// Array.from (IE11)
if (!Array.from) {
  Array.from = function(arrayLike) {
    return Array.prototype.slice.call(arrayLike);
  };
}

// Object.assign (IE11)
if (typeof Object.assign !== 'function') {
  Object.assign = function(target, ...sources) {
    sources.forEach(source => {
      Object.keys(source).forEach(key => {
        target[key] = source[key];
      });
    });
    return target;
  };
}
```

### 16.2 Feature Detection

```javascript
// feature-detection.js
export function checkFeatures() {
  const features = {
    localStorage: typeof Storage !== 'undefined',
    flexbox: CSS.supports('display', 'flex'),
    grid: CSS.supports('display', 'grid'),
    customProperties: CSS.supports('--custom', 'property')
  };
  
  const unsupported = Object.entries(features)
    .filter(([, supported]) => !supported)
    .map(([feature]) => feature);
  
  if (unsupported.length > 0) {
    console.warn('Unsupported features:', unsupported);
    // 폴백 UI 표시
  }
  
  return features;
}
```

---

## 17. 문서 및 주석

### 17.1 JSDoc 주석

```javascript
/**
 * 계산기 클래스
 * @class Calculator
 * @description 기본 및 공학용 계산 기능을 제공하는 클래스
 */
export class Calculator {
  /**
   * 두 숫자를 더합니다
   * @param {number} a - 첫 번째 숫자
   * @param {number} b - 두 번째 숫자
   * @returns {number} 덧셈 결과
   * @example
   * const calc = new Calculator();
   * calc.add(2, 3); // 5
   */
  add(a, b) {
    return a + b;
  }
  
  /**
   * 각도의 사인 값을 계산합니다
   * @param {number} angle - 각도 (현재 angleMode에 따라 도 또는 라디안)
   * @returns {number} 사인 값 (-1 ~ 1)
   * @throws {Error} 각도가 유효하지 않은 경우
   */
  sin(angle) {
    const radians = this.toRadians(angle);
    return Math.sin(radians);
  }
}
```

---

## 18. 향후 기술 개선 사항

### Phase 2
- **Web Workers**: 복잡한 계산을 백그라운드에서 처리
- **IndexedDB**: 대용량 히스토리 저장
- **Service Worker**: 오프라인 지원 (PWA)

### Phase 3
- **WebAssembly**: 고성능 수학 연산
- **TypeScript**: 타입 안정성 향상
- **React/Vue**: 컴포넌트 기반 리팩토링

### Phase 4
- **Canvas API**: 그래프 플로팅
- **Web Audio API**: 사운드 피드백
- **Vibration API**: 햅틱 피드백 (모바일)

---

## 부록 A: 파일 구조 상세

```
calculator-demo/
├── index.html
├── package.json
├── vite.config.js
├── .eslintrc.js
├── .prettierrc
├── .gitignore
├── README.md
│
├── src/
│   ├── main.js                 # 앱 진입점
│   ├── calculator.js           # 계산 엔진
│   ├── state.js                # 상태 관리
│   ├── ui.js                   # UI 컨트롤러
│   ├── storage.js              # 로컬 스토리지
│   ├── history.js              # 히스토리 관리
│   ├── themes.js               # 테마 관리
│   ├── utils.js                # 유틸리티
│   └── logger.js               # 로깅
│
├── css/
│   ├── styles.css              # 메인 스타일
│   ├── themes.css              # 테마 변수
│   └── animations.css          # 애니메이션
│
├── tests/
│   ├── unit/
│   │   ├── calculator.test.js
│   │   ├── state.test.js
│   │   └── utils.test.js
│   ├── integration/
│   │   └── app.test.js
│   └── e2e/
│       └── calculator.spec.js
│
├── docs/
│   ├── PRD.md
│   ├── TechSpec.md
│   └── API.md
│
└── dist/                       # 빌드 출력 (자동 생성)
```

---

## 부록 B: 참고 자료

### 공식 문서
- [MDN Web Docs](https://developer.mozilla.org/)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Vite](https://vitejs.dev/guide/)
- [Jest](https://jestjs.io/docs/getting-started)
- [Playwright](https://playwright.dev/docs/intro)

### 라이브러리
- [decimal.js](https://github.com/MikeMcl/decimal.js/)
- [math.js](https://mathjs.org/docs/index.html)

### 도구
- [ESLint](https://eslint.org/docs/latest/)
- [Prettier](https://prettier.io/docs/en/)
- [GitHub Actions](https://docs.github.com/en/actions)

---

**문서 버전**: 1.0  
**최종 수정일**: 2025-12-23  
**작성자**: Antigravity AI
