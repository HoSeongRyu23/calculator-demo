module.exports = {
    testEnvironment: 'node',

    // 테스트 파일 패턴
    testMatch: [
        '**/tests/**/*.test.js',
        '**/__tests__/**/*.js'
    ],

    // 커버리지 수집 대상
    collectCoverageFrom: [
        'src/**/*.js',
        '!src/ui/**/*.js',        // UI는 커버리지에서 제외
        '!src/main.js',           // 진입점 제외
        '!**/node_modules/**',
        '!**/dist/**'
    ],

    // 커버리지 임계값 (코어 로직)
    coverageThreshold: {
        global: {
            branches: 80,
            functions: 80,
            lines: 80,
            statements: 80
        },
        // 코어 로직은 더 높은 커버리지 요구
        './src/core/**/*.js': {
            branches: 90,
            functions: 90,
            lines: 90,
            statements: 90
        },
        './src/services/**/*.js': {
            branches: 85,
            functions: 85,
            lines: 85,
            statements: 85
        }
    },

    // 커버리지 리포트 형식
    coverageReporters: [
        'text',
        'text-summary',
        'html',
        'lcov'
    ],

    // 모듈 경로 매핑
    moduleNameMapper: {
        '^@/(.*)$': '<rootDir>/src/$1',
        '^@core/(.*)$': '<rootDir>/src/core/$1',
        '^@services/(.*)$': '<rootDir>/src/services/$1',
        '^@utils/(.*)$': '<rootDir>/src/utils/$1'
    },

    // 테스트 전 설정
    setupFilesAfterEnv: ['<rootDir>/tests/setup.js'],

    // 변환 설정 (ES6 모듈 지원)
    transform: {
        '^.+\\.js$': 'babel-jest'
    },

    // 테스트 타임아웃
    testTimeout: 10000,

    // Verbose 출력
    verbose: true
};
