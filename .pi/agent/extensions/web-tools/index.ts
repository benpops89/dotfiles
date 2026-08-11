import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { fetchPage } from "./firecrawl.ts";
import { searchWeb } from "./exa.ts";

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "web_fetch",
    label: "Web Fetch",
    description:
      "Fetch a URL and return its content as markdown with inline images removed, " +
      "truncated to maxLength characters (default 5000). Uses the Firecrawl API; " +
      "requires FIRECRAWL_API_KEY.",
    parameters: Type.Object({
      url: Type.String({ description: "The URL to fetch" }),
      maxLength: Type.Optional(
        Type.Number({ description: "Maximum characters of markdown to return (default 5000)" }),
      ),
    }),
    async execute(_toolCallId, params, signal) {
      try {
        const markdown = await fetchPage(params.url, { maxLength: params.maxLength, signal });
        return {
          content: [{ type: "text", text: markdown || "(empty page)" }],
          details: {},
        };
      } catch (err) {
        return {
          content: [{ type: "text", text: err instanceof Error ? err.message : String(err) }],
          isError: true,
          details: {},
        };
      }
    },
  });

  pi.registerTool({
    name: "web_search",
    label: "Web Search",
    description:
      "Search the web and return the top 5 results with title, URL, and a short summary. " +
      "Uses the Exa API; requires EXA_API_KEY.",
    parameters: Type.Object({
      query: Type.String({ description: "The search query" }),
    }),
    async execute(_toolCallId, params, signal) {
      try {
        const results = await searchWeb(params.query, { signal });
        const text = results
          .map((r, i) => `${i + 1}. ${r.title}\n   ${r.url}\n   ${r.summary}`)
          .join("\n\n");
        return {
          content: [{ type: "text", text: text || "No results found." }],
          details: { results },
        };
      } catch (err) {
        return {
          content: [{ type: "text", text: err instanceof Error ? err.message : String(err) }],
          isError: true,
          details: {},
        };
      }
    },
  });
}
