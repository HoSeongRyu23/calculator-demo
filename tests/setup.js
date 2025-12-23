// Jest 테스트 환경 설정

// 커스텀 매처 추가 (필요시)
expect.extend({
    toBeWithinRange(received, floor, ceiling) {
        const pass = received >= floor && received <= ceiling;
        if (pass) {
            return {
                message: () =>
                    `expected ${received} not to be within range ${floor} - ${ceiling}`,
                pass: true,
            };
        } else {
            return {
                message: () =>
                    `expected ${received} to be within range ${floor} - ${ceiling}`,
                pass: false,
            };
        }
    },
});

// 전역 테스트 설정
beforeAll(() => {
    // 전역 설정
});

afterAll(() => {
    // 정리 작업
});

// 각 테스트 전후 실행
beforeEach(() => {
    // 각 테스트 전 초기화
});

afterEach(() => {
    // 각 테스트 후 정리
});
