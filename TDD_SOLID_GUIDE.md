# TDD & SOLID 원칙 적용 가이드

이 프로젝트는 **TDD (Test-Driven Development)**와 **SOLID 원칙**을 따릅니다.

## 📚 주요 문서

- **[Development Guidelines](./docs/DevelopmentGuidelines.md)** - TDD와 SOLID 원칙 상세 가이드
- **[PRD](./docs/PRD.md)** - 제품 요구사항 문서
- **[Tech Spec](./docs/TechSpec.md)** - 기술 명세서

## 🧪 TDD 워크플로우

### 1. Red - 실패하는 테스트 작성
```bash
# 테스트 파일 생성
# tests/unit/calculator.test.js

npm test  # 실패 확인
```

### 2. Green - 최소 구현
```bash
# 구현 파일 생성
# src/core/calculator/Calculator.js

npm test  # 통과 확인
```

### 3. Refactor - SOLID 원칙 적용
```bash
# 코드 개선 및 리팩토링
npm test  # 여전히 통과하는지 확인
```

## 🎯 SOLID 원칙

- **S**ingle Responsibility - 단일 책임
- **O**pen/Closed - 개방/폐쇄
- **L**iskov Substitution - 리스코프 치환
- **I**nterface Segregation - 인터페이스 분리
- **D**ependency Inversion - 의존성 역전

## 📊 테스트 커버리지 목표

- 코어 로직: **90% 이상**
- 서비스: **85% 이상**
- 전체: **80% 이상**

```bash
# 커버리지 확인
npm run test:coverage
```

## 🏗️ 프로젝트 구조 (SOLID 적용)

```
src/
├── core/           # 코어 로직 (TDD 필수, 90% 커버리지)
├── services/       # 비즈니스 로직 (TDD 필수, 85% 커버리지)
├── ui/             # UI 레이어 (TDD 선택)
└── utils/          # 유틸리티 (TDD 필수)
```

## 🚀 시작하기

```bash
# 의존성 설치
npm install

# 테스트 실행
npm test

# 테스트 watch 모드
npm run test:watch

# 커버리지 확인
npm run test:coverage
```

---

자세한 내용은 [Development Guidelines](./docs/DevelopmentGuidelines.md)를 참조하세요.
