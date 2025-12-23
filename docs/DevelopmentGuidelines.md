# Development Guidelines
# Calculator Demo Project

## 개발 원칙

이 프로젝트는 다음 두 가지 핵심 원칙을 따릅니다:

1. **TDD (Test-Driven Development)** - UI를 제외한 모든 코어 로직
2. **SOLID 원칙** - 객체지향 설계 원칙 준수

---

## 1. TDD (Test-Driven Development)

### 1.1 TDD 적용 범위

#### ✅ TDD 필수 적용 (코어 로직)
- 계산 엔진 (`calculator.js`)
- 수식 파서 (`parser.js`)
- 상태 관리 (`state.js`)
- 스토리지 관리 (`storage.js`)
- 히스토리 관리 (`history.js`)
- 유틸리티 함수 (`utils.js`)
- 비즈니스 로직 전반

#### ⚠️ TDD 선택적 적용
- UI 컴포넌트 (`ui.js`)
- DOM 조작 로직
- 이벤트 핸들러
- 애니메이션 로직

### 1.2 TDD 사이클 (Red-Green-Refactor)

```
1. 🔴 RED: 실패하는 테스트 작성
   ↓
2. 🟢 GREEN: 테스트를 통과하는 최소한의 코드 작성
   ↓
3. 🔵 REFACTOR: 코드 개선 및 리팩토링
   ↓
   반복
```

### 1.3 TDD 워크플로우

#### Step 1: 테스트 먼저 작성
```javascript
// tests/unit/calculator.test.js
describe('Calculator', () => {
  test('should add two numbers', () => {
    const calc = new Calculator();
    expect(calc.add(2, 3)).toBe(5);
  });
});
```

#### Step 2: 테스트 실행 (실패 확인)
```bash
npm test
# FAIL: Calculator is not defined
```

#### Step 3: 최소한의 구현
```javascript
// src/calculator.js
export class Calculator {
  add(a, b) {
    return a + b;
  }
}
```

#### Step 4: 테스트 통과 확인
```bash
npm test
# PASS: should add two numbers
```

#### Step 5: 리팩토링
```javascript
// src/calculator.js
export class Calculator {
  /**
   * 두 숫자를 더합니다
   * @param {number} a - 첫 번째 숫자
   * @param {number} b - 두 번째 숫자
   * @returns {number} 덧셈 결과
   */
  add(a, b) {
    this._validateNumber(a);
    this._validateNumber(b);
    return a + b;
  }
  
  _validateNumber(value) {
    if (typeof value !== 'number' || isNaN(value)) {
      throw new TypeError('Invalid number');
    }
  }
}
```

### 1.4 테스트 작성 가이드

#### 테스트 구조 (AAA 패턴)
```javascript
test('description', () => {
  // Arrange (준비): 테스트 환경 설정
  const calc = new Calculator();
  const a = 2;
  const b = 3;
  
  // Act (실행): 테스트할 동작 수행
  const result = calc.add(a, b);
  
  // Assert (검증): 결과 확인
  expect(result).toBe(5);
});
```

#### 테스트 케이스 작성 원칙
1. **하나의 테스트는 하나의 기능만 검증**
2. **테스트 이름은 명확하고 구체적으로**
3. **엣지 케이스 포함** (0, 음수, 큰 수, null, undefined 등)
4. **독립적인 테스트** (다른 테스트에 의존하지 않음)

#### 예시: 완전한 테스트 스위트
```javascript
// tests/unit/calculator.test.js
describe('Calculator', () => {
  let calc;
  
  beforeEach(() => {
    calc = new Calculator();
  });
  
  describe('add', () => {
    test('should add two positive numbers', () => {
      expect(calc.add(2, 3)).toBe(5);
    });
    
    test('should add negative numbers', () => {
      expect(calc.add(-2, -3)).toBe(-5);
    });
    
    test('should add zero', () => {
      expect(calc.add(5, 0)).toBe(5);
    });
    
    test('should handle decimal numbers', () => {
      expect(calc.add(0.1, 0.2)).toBeCloseTo(0.3, 5);
    });
    
    test('should throw error for invalid input', () => {
      expect(() => calc.add('2', 3)).toThrow(TypeError);
      expect(() => calc.add(2, null)).toThrow(TypeError);
    });
  });
  
  describe('divide', () => {
    test('should divide two numbers', () => {
      expect(calc.divide(6, 2)).toBe(3);
    });
    
    test('should throw error on division by zero', () => {
      expect(() => calc.divide(5, 0)).toThrow('Division by zero');
    });
  });
});
```

### 1.5 테스트 커버리지 목표

- **코어 로직**: 90% 이상
- **유틸리티**: 85% 이상
- **전체 프로젝트**: 80% 이상

```bash
# 커버리지 확인
npm run test:coverage
```

---

## 2. SOLID 원칙

### 2.1 S - Single Responsibility Principle (단일 책임 원칙)

**"하나의 클래스는 하나의 책임만 가져야 한다"**

#### ❌ 나쁜 예
```javascript
class Calculator {
  add(a, b) { return a + b; }
  
  // 계산과 관련 없는 책임
  saveToLocalStorage(data) { /* ... */ }
  formatDisplay(value) { /* ... */ }
  logHistory(expression) { /* ... */ }
}
```

#### ✅ 좋은 예
```javascript
// 계산 책임만
class Calculator {
  add(a, b) { return a + b; }
  subtract(a, b) { return a - b; }
  multiply(a, b) { return a * b; }
  divide(a, b) { 
    if (b === 0) throw new Error('Division by zero');
    return a / b; 
  }
}

// 스토리지 책임
class StorageManager {
  save(key, value) { /* ... */ }
  load(key) { /* ... */ }
}

// 포맷팅 책임
class DisplayFormatter {
  formatNumber(value) { /* ... */ }
  formatExpression(expr) { /* ... */ }
}

// 히스토리 책임
class HistoryManager {
  add(item) { /* ... */ }
  getAll() { /* ... */ }
}
```

### 2.2 O - Open/Closed Principle (개방-폐쇄 원칙)

**"확장에는 열려있고, 수정에는 닫혀있어야 한다"**

#### ❌ 나쁜 예
```javascript
class Calculator {
  calculate(operation, a, b) {
    if (operation === 'add') return a + b;
    if (operation === 'subtract') return a - b;
    if (operation === 'multiply') return a * b;
    // 새 연산 추가 시 이 클래스를 수정해야 함
  }
}
```

#### ✅ 좋은 예
```javascript
// 연산 인터페이스
class Operation {
  execute(a, b) {
    throw new Error('Must implement execute method');
  }
}

// 구체적인 연산들
class AddOperation extends Operation {
  execute(a, b) { return a + b; }
}

class SubtractOperation extends Operation {
  execute(a, b) { return a - b; }
}

class MultiplyOperation extends Operation {
  execute(a, b) { return a * b; }
}

// 계산기는 수정 없이 새 연산 추가 가능
class Calculator {
  constructor() {
    this.operations = new Map();
  }
  
  registerOperation(name, operation) {
    this.operations.set(name, operation);
  }
  
  calculate(operationName, a, b) {
    const operation = this.operations.get(operationName);
    if (!operation) throw new Error('Unknown operation');
    return operation.execute(a, b);
  }
}

// 사용
const calc = new Calculator();
calc.registerOperation('add', new AddOperation());
calc.registerOperation('subtract', new SubtractOperation());
```

### 2.3 L - Liskov Substitution Principle (리스코프 치환 원칙)

**"자식 클래스는 부모 클래스를 대체할 수 있어야 한다"**

#### ❌ 나쁜 예
```javascript
class Calculator {
  divide(a, b) {
    return a / b;
  }
}

class SafeCalculator extends Calculator {
  divide(a, b) {
    // 부모와 다른 동작 (예외 발생)
    if (b === 0) throw new Error('Division by zero');
    return a / b;
  }
}
```

#### ✅ 좋은 예
```javascript
class Calculator {
  divide(a, b) {
    if (b === 0) throw new Error('Division by zero');
    return a / b;
  }
}

class ScientificCalculator extends Calculator {
  // 부모의 계약을 유지하면서 기능 확장
  divide(a, b) {
    // 부모와 동일한 검증
    return super.divide(a, b);
  }
  
  // 추가 기능
  power(base, exponent) {
    return Math.pow(base, exponent);
  }
}
```

### 2.4 I - Interface Segregation Principle (인터페이스 분리 원칙)

**"클라이언트는 사용하지 않는 인터페이스에 의존하면 안 된다"**

#### ❌ 나쁜 예
```javascript
class ScientificCalculator {
  // 기본 연산
  add(a, b) { /* ... */ }
  subtract(a, b) { /* ... */ }
  
  // 과학 함수
  sin(angle) { /* ... */ }
  cos(angle) { /* ... */ }
  
  // 통계 함수
  mean(numbers) { /* ... */ }
  median(numbers) { /* ... */ }
  
  // 행렬 연산
  matrixMultiply(a, b) { /* ... */ }
}

// 기본 계산만 필요한 클라이언트도 모든 메서드를 가짐
```

#### ✅ 좋은 예
```javascript
// 인터페이스 분리
class BasicCalculator {
  add(a, b) { return a + b; }
  subtract(a, b) { return a - b; }
  multiply(a, b) { return a * b; }
  divide(a, b) { return a / b; }
}

class TrigonometricCalculator {
  constructor(angleMode = 'DEG') {
    this.angleMode = angleMode;
  }
  
  sin(angle) { /* ... */ }
  cos(angle) { /* ... */ }
  tan(angle) { /* ... */ }
}

class StatisticsCalculator {
  mean(numbers) { /* ... */ }
  median(numbers) { /* ... */ }
  standardDeviation(numbers) { /* ... */ }
}

// 필요한 기능만 조합
class ScientificCalculator {
  constructor() {
    this.basic = new BasicCalculator();
    this.trig = new TrigonometricCalculator();
  }
  
  // 위임
  add(a, b) { return this.basic.add(a, b); }
  sin(angle) { return this.trig.sin(angle); }
}
```

### 2.5 D - Dependency Inversion Principle (의존성 역전 원칙)

**"구체화가 아닌 추상화에 의존해야 한다"**

#### ❌ 나쁜 예
```javascript
class Calculator {
  constructor() {
    // 구체적인 클래스에 직접 의존
    this.storage = new LocalStorageManager();
    this.logger = new ConsoleLogger();
  }
  
  calculate(expr) {
    const result = this.evaluate(expr);
    this.storage.save('lastResult', result);
    this.logger.log(`Calculated: ${expr} = ${result}`);
    return result;
  }
}
```

#### ✅ 좋은 예
```javascript
// 추상화 (인터페이스)
class StorageInterface {
  save(key, value) { throw new Error('Not implemented'); }
  load(key) { throw new Error('Not implemented'); }
}

class LoggerInterface {
  log(message) { throw new Error('Not implemented'); }
}

// 구체적인 구현
class LocalStorageManager extends StorageInterface {
  save(key, value) {
    localStorage.setItem(key, JSON.stringify(value));
  }
  load(key) {
    return JSON.parse(localStorage.getItem(key));
  }
}

class ConsoleLogger extends LoggerInterface {
  log(message) {
    console.log(message);
  }
}

// 의존성 주입
class Calculator {
  constructor(storage, logger) {
    this.storage = storage;
    this.logger = logger;
  }
  
  calculate(expr) {
    const result = this.evaluate(expr);
    this.storage.save('lastResult', result);
    this.logger.log(`Calculated: ${expr} = ${result}`);
    return result;
  }
}

// 사용 (의존성 주입)
const storage = new LocalStorageManager();
const logger = new ConsoleLogger();
const calc = new Calculator(storage, logger);

// 테스트 시 Mock 객체 주입 가능
class MockStorage extends StorageInterface {
  constructor() {
    super();
    this.data = {};
  }
  save(key, value) { this.data[key] = value; }
  load(key) { return this.data[key]; }
}
```

---

## 3. 프로젝트 구조 (SOLID 적용)

```
src/
├── core/                      # 코어 로직 (TDD 필수)
│   ├── calculator/
│   │   ├── Calculator.js      # SRP: 기본 계산만
│   │   ├── ScientificCalculator.js  # OCP: 확장
│   │   └── operations/        # OCP: 연산 전략
│   │       ├── Operation.js
│   │       ├── AddOperation.js
│   │       ├── SubtractOperation.js
│   │       └── TrigOperation.js
│   │
│   ├── parser/
│   │   ├── ExpressionParser.js  # SRP: 파싱만
│   │   └── Tokenizer.js         # SRP: 토큰화만
│   │
│   ├── state/
│   │   ├── StateManager.js      # SRP: 상태 관리만
│   │   └── StateValidator.js    # SRP: 검증만
│   │
│   └── storage/
│       ├── StorageInterface.js  # DIP: 추상화
│       ├── LocalStorageAdapter.js
│       └── SessionStorageAdapter.js
│
├── services/                  # 비즈니스 로직 (TDD 필수)
│   ├── HistoryService.js      # SRP: 히스토리 관리
│   ├── FormatterService.js    # SRP: 포맷팅
│   └── ValidationService.js   # SRP: 검증
│
├── ui/                        # UI 레이어 (TDD 선택)
│   ├── UIController.js
│   ├── DisplayManager.js
│   └── EventHandler.js
│
└── utils/                     # 유틸리티 (TDD 필수)
    ├── mathUtils.js
    └── formatUtils.js
```

---

## 4. 코드 리뷰 체크리스트

### TDD 체크리스트
- [ ] 테스트가 먼저 작성되었는가?
- [ ] 모든 테스트가 통과하는가?
- [ ] 테스트 커버리지가 목표치를 달성했는가?
- [ ] 엣지 케이스가 테스트되었는가?
- [ ] 테스트가 독립적인가?

### SOLID 체크리스트
- [ ] **SRP**: 각 클래스가 하나의 책임만 가지는가?
- [ ] **OCP**: 새 기능 추가 시 기존 코드 수정이 필요한가?
- [ ] **LSP**: 자식 클래스가 부모를 대체할 수 있는가?
- [ ] **ISP**: 사용하지 않는 메서드에 의존하지 않는가?
- [ ] **DIP**: 구체화가 아닌 추상화에 의존하는가?

---

## 5. 개발 워크플로우

### 새 기능 개발 프로세스

```
1. 요구사항 분석
   ↓
2. 테스트 케이스 작성 (TDD Red)
   ↓
3. 최소 구현 (TDD Green)
   ↓
4. SOLID 원칙 검토
   ↓
5. 리팩토링 (TDD Refactor)
   ↓
6. 코드 리뷰
   ↓
7. 커밋 & 푸시
```

### 예시: 새 연산 추가

```bash
# 1. 테스트 작성
# tests/unit/operations/PowerOperation.test.js

# 2. 테스트 실행 (실패 확인)
npm test

# 3. 구현
# src/core/calculator/operations/PowerOperation.js

# 4. 테스트 통과 확인
npm test

# 5. SOLID 원칙 검토 및 리팩토링

# 6. 커밋
git add .
git commit -m "feat: Add power operation with TDD"
```

---

## 6. 참고 자료

### TDD
- [Test-Driven Development by Example - Kent Beck](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- [Jest Documentation](https://jestjs.io/docs/getting-started)

### SOLID
- [Clean Code - Robert C. Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

---

**문서 버전**: 1.0  
**최종 수정일**: 2025-12-23  
**작성자**: Development Team
