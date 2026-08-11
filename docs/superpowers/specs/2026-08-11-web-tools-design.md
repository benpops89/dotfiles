# web-tools Extension — Design

Date: 2026-08-11
Status: Approved (pending spec review)

## Overview

A pi extension named **web-tools** that registers two custom tools:

- `web_fetch` — fetch a page's markdown via the Firecrawl API
- `web_search` — search the web via the Exa API, returning the top 5 results with short summaries

Both tools use native implementations: the global `fetch` API and `process.env` for secrets. No SDKs, no npm dependencies. The only imports are `typebox` (for parameter schemas) and pi's `ExtensionAPI` types.

## Location & Structure

The extension lives at `~/.pi/agent/extensions/web-tools/` (global, auto-discovered; `~/.pi` symlinks to `/home/ben/dotfiles/.pi`, so it is version-controlled in dotfiles).

```
~/.pi/agent/extensions/web-tools/
├── index.ts      # entry: registers web_fetch + web_search
├── firecrawl.ts  # fetchPage(url, maxLength) → page markdown (images stripped)
└── exa.ts        # searchWeb(query) → top-5 results with summaries
```

Each module exports one pure async function. `index.ts` owns tool registration, typebox schemas, and formatting of results/errors. No `package.json` is needed — jiti loads the TypeScript directly and typebox is available to extensions.

## Tool: web_fetch (Firecrawl)

- Parameters: `url` (required, string), `maxLength` (optional, number, default 5000).
- Calls `POST https://api.firecrawl.dev/v1/scrape`:
  - Header: `Authorization: Bearer $FIRECRAWL_API_KEY`
  - Body: `{ url, formats: ["markdown"], onlyMainContent: true }`
- On success, takes `data.markdown` and:
  1. **Strips inline images**: removes all markdown image syntax `![alt](url)` (the entire token, including alt text) from the returned markdown.
  2. Truncates to `maxLength` characters.
- Returns the cleaned markdown as a text tool result.
- Firecrawl timeout: 60s. Passes `ctx.signal` to abort on Esc.

## Tool: web_search (Exa)

- Parameters: `query` (required, string). Fixed top-5 results — no other knobs.
- Calls `POST https://api.exa.ai/search`:
  - Header: `x-api-key: $EXA_API_KEY`
  - Body: `{ query, numResults: 5, type: "auto", contents: { summary: true, highlights: true } }`
  - The exact `contents` field that yields a per-result summary will be verified against Exa's current API during implementation; `highlights` serve as the fallback summary source.
- Returns a compact markdown list — per result: title, URL, and a one-to-few-sentence summary. Full page text is never returned (protects context).
- Exa timeout: 30s. Passes `ctx.signal` to abort on Esc.

## Configuration

- `FIRECRAWL_API_KEY` and `EXA_API_KEY` are read from `process.env` at call time (not cached at load).
- Missing key → tool error: `web_fetch requires FIRECRAWL_API_KEY to be set` (similarly for Exa), so the LLM knows exactly what's wrong.

## Error Handling

All failures return `isError: true` tool results with readable messages:

- Non-2xx HTTP response → include status code and the API's error message body (truncated).
- Network failure or timeout → descriptive error.
- Firecrawl `success: false` responses → surface the API's `error` field.
- Unexpected exceptions → caught, logged, returned as a generic tool error (never crash the session).

## Testing

- Load the extension with `pi -e ~/.pi/agent/extensions/web-tools/index.ts` from a scratch directory.
- Verify `web_fetch` on a known URL: markdown returned, no `![...](...)` tokens present, length respects `maxLength`.
- Verify `web_search` on a known query: exactly 5 results, each with title/URL/summary.
- Verify error paths: missing key (unset env var), bad URL (Firecrawl 404), no network (simulated).
- Optional: a small throwaway node script that imports `firecrawl.ts`/`exa.ts` directly for fast iteration on the fetch logic.
