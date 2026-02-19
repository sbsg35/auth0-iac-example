import typescript from "@rollup/plugin-typescript";

export default {
  input: ["src/post-login-action.ts", "src/post-registration-action.ts"],
  output: {
    strict: false,
    format: "cjs",
    dir: "dist",
  },
  external: [], // here you can add any external dependencies
  plugins: [typescript({ module: "es6" })],
};
