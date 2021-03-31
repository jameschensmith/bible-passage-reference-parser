module.exports = {
	extends: ["kentcdodds", "kentcdodds/jest"],
	parserOptions: {
		project: ["./tsconfig.eslint.json"],
	},
	rules: {
		/*
		 * @typescript-eslint/eslint-plugin
		 */

		"@typescript-eslint/no-dynamic-delete": "off",
		"@typescript-eslint/no-explicit-any": "off",
		"@typescript-eslint/no-loop-func": "off",
		"@typescript-eslint/no-non-null-assertion": "off",
		"@typescript-eslint/no-shadow": "off",
		"@typescript-eslint/no-unnecessary-condition": "off",
		"@typescript-eslint/no-unsafe-assignment": "off",
		"@typescript-eslint/no-unsafe-call": "off",
		"@typescript-eslint/no-unsafe-member-access": "off",
		"@typescript-eslint/no-unused-vars": "off",
		"@typescript-eslint/no-var-requires": "off",
		"@typescript-eslint/restrict-plus-operands": "off",
		"@typescript-eslint/sort-type-union-intersection-members": "off",

		/*
		 * eslint-plugin-babel
		 */

		"babel/new-cap": "off",

		/*
		 * eslint
		 */

		complexity: "off",
		"max-depth": "off",
		"max-lines-per-function": "off",
		"max-statements-per-line": "off",
		"no-control-regex": "off",
		"no-irregular-whitespace": "off",
		"no-lonely-if": "off",
		"no-negated-condition": "off",
		"no-shadow": "off",
		"no-template-curly-in-string": "off",
		"no-useless-escape": "off",
		"prefer-const": "off",
		"vars-on-top": "off",
	},
};
