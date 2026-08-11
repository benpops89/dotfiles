// Exa provider — web search returning the top 5 results with summaries.
// Native implementation: global fetch + process.env only. No SDK.
import { withTimeout, truncate } from "./util.ts";

const EXA_API_URL = "https://api.exa.ai/search";
const DEFAULT_TIMEOUT_MS = 30_000;
const NUM_RESULTS = 5;

export interface SearchResult {
  title: string;
  url: string;
  summary: string;
}

export interface SearchWebOptions {
  signal?: AbortSignal;
}

/**
 * Search the web via Exa; returns top-5 results with short summaries.
 * @throws {Error} readable message on any failure
 */
export async function searchWeb(
  query: string,
  options: SearchWebOptions = {},
): Promise<SearchResult[]> {
  const apiKey = process.env.EXA_API_KEY;
  if (!apiKey) {
    throw new Error("web_search requires EXA_API_KEY to be set");
  }

  const signal = withTimeout(options.signal, DEFAULT_TIMEOUT_MS);

  const response = await fetch(EXA_API_URL, {
    method: "POST",
    headers: {
      "x-api-key": apiKey,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query,
      numResults: NUM_RESULTS,
      type: "auto",
      contents: { summary: true, highlights: true },
    }),
    signal,
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Exa API error (${response.status}): ${truncate(body, 300)}`);
  }

  const payload = (await response.json()) as {
    results?: Array<{
      title?: string;
      url?: string;
      summary?: string;
      highlights?: string[];
    }>;
  };

  const raw = Array.isArray(payload.results) ? payload.results : [];

  return raw.slice(0, NUM_RESULTS).map((r) => ({
    title: r.title ?? r.url ?? "(untitled)",
    url: r.url ?? "",
    summary: (r.summary ?? r.highlights?.[0] ?? "").trim(),
  }));
}
