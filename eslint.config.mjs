import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
    baseDirectory: __dirname,
});

const eslintConfig = [
    ...compat.config({
        extends: ["next/core-web-vitals", "next/typescript", "prettier"],
        rules: {
            semi: ["error"],
            quotes: ["error", "double"],
            "prefer-arrow-callback": ["error"],
            "no-restricted-syntax": [
                "error",
                "FunctionExpression",
                "FunctionDeclaration",
            ],
            "@typescript-eslint/no-unused-vars": "warn",
            curly: ["error", "all"],
            "no-console": "warn",
        },
    }),
];

export default eslintConfig;
