import { test, beforeEach } from "node:test";
import assert from "node:assert/strict";
import { searchWeb } from "../exa.ts";

const ORIG_FETCH = globalThis.fetch;

beforeEach(() => {
  globalThis.fetch = ORIG_FETCH;
  delete process.env.EXA_API_KEY;
});

function mockFetchOnce(handler: (url: string, init: RequestInit) => Promise<Response>) {
  globalThis.fetch = async (url, init) => handler(url as string, init as RequestInit);
}

test("searchWeb returns results with title, url, summary", async () => {
  process.env.EXA_API_KEY = "test-key";
  mockFetchOnce(async (url, init) => {
    assert.equal(url, "https://api.exa.ai/search");
    assert.equal((init.headers as Record<string, string>)["x-api-key"], "test-key");
    const body = JSON.parse(init.body as string);
    assert.equal(body.query, "test query");
    assert.equal(body.numResults, 5);
    assert.equal(body.type, "auto");
    assert.deepEqual(body.contents, { summary: true, highlights: true });
    return new Response(
      JSON.stringify({
        results: [
          { title: "A", url: "https://a.com", summary: "sum a" },
          { title: "B", url: "https://b.com", highlights: ["hl b"] },
        ],
      }),
      { status: 200 },
    );
  });

  const out = await searchWeb("test query");
  assert.equal(out.length, 2);
  assert.deepEqual(out[0], { title: "A", url: "https://a.com", summary: "sum a" });
});

test("searchWeb falls back to first highlight when summary missing", async () => {
  process.env.EXA_API_KEY = "k";
  mockFetchOnce(async () =>
    new Response(
      JSON.stringify({ results: [{ title: "B", url: "https://b.com", highlights: ["hl b"] }] }),
      { status: 200 },
    ),
  );
  const out = await searchWeb("q");
  assert.equal(out[0].summary, "hl b");
});

test("searchWeb caps results at 5", async () => {
  process.env.EXA_API_KEY = "k";
  const results = Array.from({ length: 8 }, (_, i) => ({
    title: `r${i}`,
    url: `https://r${i}.com`,
    summary: "s",
  }));
  mockFetchOnce(async () => new Response(JSON.stringify({ results }), { status: 200 }));
  const out = await searchWeb("q");
  assert.equal(out.length, 5);
});

test("searchWeb throws when API key missing", async () => {
  await assert.rejects(searchWeb("q"), /EXA_API_KEY/);
});

test("searchWeb throws on non-2xx response", async () => {
  process.env.EXA_API_KEY = "k";
  mockFetchOnce(async () => new Response("bad key", { status: 401 }));
  await assert.rejects(searchWeb("q"), /401/);
});
