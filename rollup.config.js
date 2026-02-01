import typescript from "@rollup/plugin-typescript";
import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";
import terser from "@rollup/plugin-terser";

export default [
  // Post-login action bundle
  {
    input: ["src/post-login-action.ts"],
    output: {
      strict: false,
      format: "cjs",
      dir: "dist",
    },
    external: [],
    plugins: [typescript({ module: "es6" })],
  },
  // Lock configuration bundle for Universal Login
  {
    input: "src/lock.ts",
    output: {
      file: "dist/lock.bundle.js",
      format: "iife",
      name: "LockConfig",
    },
    external: ["auth0-lock"], // Load from CDN, don't bundle
    plugins: [resolve(), commonjs(), typescript({ module: "es6" }), terser()],
  },
];
