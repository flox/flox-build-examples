import nodeResolve from "@rollup/plugin-node-resolve";
import json from "@rollup/plugin-json";
import commonjs from "@rollup/plugin-commonjs";

export default {
  input: "./app.js",
  output: {
    file: "dist/index.js",
    format: "cjs",
    name: "bundle",
  },
  plugins: [nodeResolve(), json(), commonjs()],
};
