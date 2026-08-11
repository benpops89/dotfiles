// Firecrawl provider — fetches a page's markdown via the Firecrawl API.
// Native implementation: global fetch + process.env only. No SDK.
import { withTimeout, truncate } from "./util.ts";

const FIRECRAWL_API_URL = "https://api.firecrawl.dev/v1/scrape";
const DEFAULT_TIMEOUT_MS = 60_000;
const DEFAULT_MAX_LENGTH = 5000;

export interface FetchPageOptions {
  maxLength?: number;
  signal?: AbortSignal;
}

/** Remove markdown inline image syntax `![alt](url)` from markdown. */
export function stripInlineImages(markdown: string): string {
  return markdown.replace(/!\[[^\]]*\]\([^)]*\)/g, "");
}

/**
 * Fetch a URL and return its markdown (inline images stripped, truncated).
 * @throws {Error} readable message on any failure
 */
export async function fetchPage(
  url: string,
  options: FetchPageOptions = {},
): Promise<string> {
  const apiKey = process.env.FIRECRAWL_API_KEY;
  if (!apiKey) {
    throw new Error("web_fetch requires FIRECRAWL_API_KEY to be set");
  }

  const maxLength = options.maxLength ?? DEFAULT_MAX_LENGTH;
  const signal = withTimeout(options.signal, DEFAULT_TIMEOUT_MS);

  const response = await fetch(FIRECRAWL_API_URL, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      url,
      formats: ["markdown"],
      onlyMainContent: true,
    }),
    signal,
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Firecrawl API error (${response.status}): ${truncate(body, 300)}`);
  }

  const payload = (await response.json()) as {
    success?: boolean;
    data?: { markdown?: string };
    error?: string;
  };

  if (!payload.success || !payload.data?.markdown) {
    throw new Error(`Firecrawl error: ${payload.error ?? "no markdown in response"}`);
  }

  return stripInlineImages(payload.data.markdown).trim().slice(0, maxLength);
}
