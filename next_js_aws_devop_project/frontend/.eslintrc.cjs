module.exports = {
    root: true,
    env: { browser: true, es2021: true },
    extends: [
        "airbnb",
        "airbnb-typescript",
        "airbnb/hooks",
        "plugin:react/recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:prettier/recommended"
    ],
    ignorePatterns: ['dist', '.eslintrc.cjs'],
    overrides: [{ files: ["*.ts", "*.tsx"] }],
    parser: "@typescript-eslint/parser",
    parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        project: ["*./tsconfig.json"]
    },
    plugins: ["react", "@typescript-eslint", "prettier"],
    settings: {
        "react": {
            "version": "detect"
        }
    },
    rules: {
        '@typescript-eslint/no-unused-vars': 'off',
        'react-refresh/only-export-components': [
            'warn',
            { allowConstantExport: true },
        ],

    },
}
