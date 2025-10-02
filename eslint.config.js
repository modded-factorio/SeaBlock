import js from '@eslint/js'
import vue from 'eslint-plugin-vue'
import importPlugin from 'eslint-plugin-import'
import unusedImports from 'eslint-plugin-unused-imports'

export default [
  // Base configuration
  js.configs.recommended,

  // Vue configuration
  ...vue.configs['flat/recommended'],

  // Global ignores
  {
    ignores: [
      'src/browser-bundle/**',
      'test/**',
      'docs/public/**',
      'data-dumps/**',
      'node_modules/**',
      'dist/**',
      'docs/.vitepress/dist/**',
      'docs/.vitepress/cache/**',
      '*.md',
      'vite.extracted.config.js'
    ]
  },

  // Main configuration
  {
    files: ['**/*.{js,vue}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      globals: {
        browser: true,
        node: true,
        es2021: true,
        process: 'readonly',
        Buffer: 'readonly',
        __dirname: 'readonly'
      }
    },
    plugins: {
      'unused-imports': unusedImports,
      import: importPlugin
    },
    rules: {
      // Vue-specific rules
      'vue/multi-word-component-names': 'off',
      'vue/no-v-html': 'off',
      'vue/no-unused-components': 'error',
      'vue/no-unused-vars': 'error',
      'vue/require-default-prop': 'error',
      'vue/require-prop-types': 'error',
      'vue/no-mutating-props': 'error',
      'vue/no-side-effects-in-computed-properties': 'error',
      'vue/no-template-key': 'error',
      'vue/no-textarea-mustache': 'error',
      'vue/no-unused-refs': 'error',
      'vue/prefer-import-from-vue': 'error',
      'vue/valid-v-slot': 'error',

      // Dead code detection
      'no-unused-vars': 'off', // Turn off base rule as it can report incorrect errors
      'unused-imports/no-unused-imports': 'error',
      'unused-imports/no-unused-vars': [
        'warn',
        {
          vars: 'all',
          varsIgnorePattern: '^_',
          args: 'after-used',
          argsIgnorePattern: '^_'
        }
      ],

      // Import rules
      'import/no-unused-modules': 'error',
      'import/no-duplicates': 'error',
      'import/order': [
        'error',
        {
          groups: ['builtin', 'external', 'internal', 'parent', 'sibling', 'index'],
          'newlines-between': 'always'
        }
      ],

      // Code quality rules
      'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
      'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
      'no-duplicate-imports': 'error',
      'no-unreachable': 'error',
      'no-unused-expressions': 'error',
      'no-useless-return': 'error',
      'no-var': 'error',
      'prefer-const': 'error',
      'prefer-template': 'error',

      // Function rules
      'no-empty-function': 'warn',
      'no-extra-bind': 'error',
      'no-return-await': 'error',

      // Object and array rules
      'no-useless-computed-key': 'error',
      'no-useless-rename': 'error',
      'object-shorthand': 'error',
      'prefer-destructuring': [
        'error',
        {
          array: false,
          object: true
        }
      ],

      // Async/await rules
      'require-await': 'error',
      'no-async-promise-executor': 'error',
      'no-await-in-loop': 'warn',
      'no-promise-executor-return': 'error',
      'prefer-promise-reject-errors': 'error'
    }
  }
]
