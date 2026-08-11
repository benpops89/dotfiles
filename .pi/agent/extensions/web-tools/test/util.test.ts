import { test } from "node:test";
import assert from "node:assert/strict";
import { truncate } from "../util.ts";

test("truncate leaves short text unchanged", () => {
  assert.equal(truncate("hello", 10), "hello");
});

test("truncate cuts long text with an ellipsis", () => {
  assert.equal(truncate("hello world", 5), "hello…");
});

test("truncate respects the exact length boundary", () => {
  assert.equal(truncate("hello", 5), "hello");
});
