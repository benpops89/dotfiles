// Shared helpers for the web-tools providers (DRY).

/** Combine a caller signal with a timeout (node 20+). */
export function withTimeout(signal: AbortSignal | undefined, ms: number): AbortSignal {
  return signal
    ? AbortSignal.any([signal, AbortSignal.timeout(ms)])
    : AbortSignal.timeout(ms);
}

/** Truncate long text with an ellipsis. */
export function truncate(text: string, max: number): string {
  return text.length > max ? `${text.slice(0, max)}…` : text;
}
