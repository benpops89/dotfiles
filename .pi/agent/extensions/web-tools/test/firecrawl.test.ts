import { test, beforeEach } from "node:test";
import assert from "node:assert/strict";
import { stripInlineImages, fetchPage } from "../firecrawl.ts";

const ORIG_FETCH = globalThis.fetch;

beforeEach(() => {
  globalThis.fetch = ORIG_FETCH;
  delete process.env.FIRECRAWL_API_KEY;
});

function mockFetchOnce(handler: (url: string, init: RequestInit) => Promise<Response>) {
  globalThis.fetch = async (url, init) => handler(url as string, init as RequestInit);
}

test("stripInlineImages removes markdown image syntax", () => {
  assert.equal(stripInlineImages("a ![alt](img.png) b"), "a  b");
  assert.equal(stripInlineImages("no images here"), "no images here");
  assert.equal(stripInlineImages("![x](y)![z](w)"), "");
});

test("fetchPage returns markdown with images stripped", async () => {
  process.env.FIRECRAWL_API_KEY = "test-key";
  mockFetchOnce(async (url, init) => {
    assert.equal(url, "https://api.firecrawl.dev/v1/scrape");
    assert.equal((init.headers as Record<string, string>).Authorization, "Bearer test-key");
    assert.deepEqual(JSON.parse(init.body as string), {
      url: "https://example.com",
      formats: ["markdown"],
      onlyMainContent: true,
    });
    return new Response(
      JSON.stringify({ success: true, data: { markdown: "# Hi\n\n![pic](a.png)\n\nbody text" } }),
      { status: 200 },
    );
  });

  const md = await fetchPage("https://example.com");
  assert.ok(!md.includes("![pic](a.png)"));
  assert.ok(md.includes("body text"));
});

test("fetchPage truncates to maxLength", async () => {
  process.env.FIRECRAWL_API_KEY = "k";
  mockFetchOnce(async () =>
    new Response(JSON.stringify({ success: true, data: { markdown: "x".repeat(100) } }), { status: 200 }),
  );
  const md = await fetchPage("https://example.com", { maxLength: 10 });
  assert.equal(md.length, 10);
});

test("fetchPage throws when API key missing", async () => {
  await assert.rejects(fetchPage("https://example.com"), /FIRECRAWL_API_KEY/);
});

test("fetchPage throws on non-2xx response", async () => {
  process.env.FIRECRAWL_API_KEY = "k";
  mockFetchOnce(async () => new Response("rate limited", { status: 429 }));
  await assert.rejects(fetchPage("https://example.com"), /429/);
});

test("fetchPage throws when Firecrawl reports failure", async () => {
  process.env.FIRECRAWL_API_KEY = "k";
  mockFetchOnce(async () =>
    new Response(JSON.stringify({ success: false, error: "Page not found" }), { status: 200 }),
  );
  await assert.rejects(fetchPage("https://example.com"), /Page not found/);
});
