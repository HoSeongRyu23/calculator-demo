import { defineConfig } from 'vite';

export default defineConfig(({ mode }) => {
  const isProduction = mode === 'production';

  return {
    // GitHub Pages 배포를 위한 base path 설정
    base: isProduction ? '/calculator-demo/' : '/',

    build: {
      outDir: 'dist',
      sourcemap: !isProduction,
      minify: isProduction ? 'esbuild' : false,
      rollupOptions: {
        output: {
          manualChunks: {
            // 필요시 vendor 라이브러리 분리
            // vendor: ['decimal.js']
          }
        }
      }
    },

    server: {
      port: 5173,
      open: true
    }
  };
});
