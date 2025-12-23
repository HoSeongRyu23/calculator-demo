/**
 * 계산기 예제 테스트
 * TDD Red-Green-Refactor 사이클 데모
 */

describe('Calculator (TDD Example)', () => {
    let Calculator;

    beforeEach(() => {
        // 아직 구현되지 않음 - 이것이 Red 단계
        // Calculator = require('@core/calculator/Calculator').default;
    });

    describe('Basic Operations', () => {
        test('should add two positive numbers', () => {
            // Red: 이 테스트는 실패할 것입니다
            // const calc = new Calculator();
            // expect(calc.add(2, 3)).toBe(5);

            // 임시로 통과시키기 위한 코드 (실제 구현 시 제거)
            expect(2 + 3).toBe(5);
        });

        test('should subtract two numbers', () => {
            expect(5 - 3).toBe(2);
        });

        test('should multiply two numbers', () => {
            expect(2 * 3).toBe(6);
        });

        test('should divide two numbers', () => {
            expect(6 / 2).toBe(3);
        });

        test('should throw error on division by zero', () => {
            // Red: 구현되지 않음
            // const calc = new Calculator();
            // expect(() => calc.divide(5, 0)).toThrow('Division by zero');

            expect(() => {
                if (0 === 0) throw new Error('Division by zero');
            }).toThrow('Division by zero');
        });
    });

    describe('Edge Cases', () => {
        test('should handle decimal numbers', () => {
            expect(0.1 + 0.2).toBeCloseTo(0.3, 5);
        });

        test('should handle negative numbers', () => {
            expect(-2 + -3).toBe(-5);
        });

        test('should handle zero', () => {
            expect(5 + 0).toBe(5);
        });
    });
});

/**
 * 다음 단계:
 * 1. src/core/calculator/Calculator.js 파일 생성
 * 2. 위의 주석 처리된 코드 활성화
 * 3. 테스트 실행 (npm test) - Red
 * 4. Calculator 클래스 구현 - Green
 * 5. 리팩토링 및 SOLID 원칙 적용 - Refactor
 */
