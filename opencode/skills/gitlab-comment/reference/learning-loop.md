# Learning Loop Reference

How `gitlab-comment` evolves the user's `ai/comment-principles.md` over time.

## When the loop fires

After every successful `post-comment.sh`, `record-draft.sh` writes a JSONL record and returns:

```json
{ "recorded": true, "edited": true, "char_delta_pct": 23.4, "should_learn": true }
```

Trigger conditions for `should_learn: true`:

- `char_delta_pct > 15`, OR
- `sentence_edits >= 2`.

If `should_learn: true`, the draft mode hands off to this loop. Otherwise the session ends.

## What the loop does (single-draft mode)

1. **Compare** `drafted` vs `posted`. Both are stored verbatim in the JSONL record.
2. **Categorize** the diff into one of six buckets:

| Bucket | What it means | Likely target section |
|---|---|---|
| `tone` | Hedging, formality, warmth | Tone Calibration / Communication Philosophy |
| `length` | User trimmed or expanded | Quick Reply Signals / Pushback Triggers |
| `structure` | Reordered or restructured | Issue/MR Description Templates |
| `vocabulary` | Specific phrase swaps | Tone Calibration → Openings / Closings |
| `addition` | User added domain content | Core Comment Principles (new principle or example) |
| `removal` | User cut content | Anti-patterns |

3. **Identify a single, specific edit** to propose. NEVER propose vague changes ("be less formal"). Always:
   - Name the section to update.
   - Provide a before/after snippet.
   - Cite the supporting evidence — the verbatim posted text from this draft.
   - Justify in one sentence.

4. **Ask the user** to accept, reject, or modify. Default: reject if unsure (false positives are worse than false negatives — they pollute the principles file).

5. **On accept:** edit `ai/comment-principles.md`, commit + push:
   ```
   Refine comment principles: <one-line summary>
   ```

## What the loop does NOT do

- It does **not** auto-edit principles without user approval.
- It does **not** propose multiple changes at once in single-draft mode (one signal = one proposal). Batch mode (`/gitlab-comment learn`) handles multiple signals.
- It does **not** attempt to detect meta-patterns from a single edit (need ≥3 corroborating drafts for that). The single-draft loop is for adding examples / quotes, not for inventing new principles.

## Anti-pattern: "thrashing"

If the loop proposes a change that contradicts a recent change (i.e., reverting an edit from <30 days ago), pause and warn the user. This usually means:

- The dataset has high tonal variance (some threads need formal voice, some informal).
- The principles file needs a *contextual* rule, not a global rule.

Suggest extracting the rule into a context-aware variant (e.g., "for security threads, use formal voice; for casual MRs, prefer brevity").

## Quote management

When adding a quote to a principle, follow the same rules as bootstrap:

- Verbatim from `posted` text in `drafts.jsonl`.
- ≤300 chars (split if longer).
- Strip trailing whitespace and obvious markdown clutter.
- If the principle already has 6+ quotes, **replace** the weakest existing one rather than appending. Do not let any single principle balloon past 8 quotes.

## Telemetry

`data/drafts.jsonl` is the source of truth for measuring drift. Useful one-liners:

```bash
# Average char-delta over last 50 drafts
jq -s '[.[-50:][].char_delta_pct] | add/length' data/drafts.jsonl

# How often --auto succeeded vs fell back
jq -s '[.[] | .auto] | group_by(.) | map({key: .[0], count: length})' data/drafts.jsonl

# Drafts that triggered learning but weren't yet processed
jq 'select(.should_learn == true)' data/drafts.jsonl | wc -l
```
