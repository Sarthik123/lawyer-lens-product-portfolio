# Case Study: Lawyer Lens

## 1. Context

Lawyer Lens ([lawyerlens.in](https://lawyerlens.in)) is an AI assistant that helps non-lawyers understand legal documents. I own the product end to end: discovery, requirements, analytics, AI evaluation, and shipping.

## 2. Problem

Individuals, startup founders, and small-business owners sign leases, NDAs, and service agreements without fully understanding them. They face three options, all poor:

1. **Pay a lawyer** for every routine document — slow and expensive.
2. **Read it themselves** — time-consuming, and easy to miss risks.
3. **Use a general chatbot** — fast, but answers can be invented and can't be traced back to the document.

Existing legal AI tools (enterprise legal research and drafting platforms) target law firms and are priced accordingly. The gap: an **affordable, self-service reviewer whose answers can be trusted and checked**.

## 3. Users

| Persona | Job to be done | Biggest fear |
|---|---|---|
| Small-business owner | "Tell me who pays for what and how I can exit this lease." | Hidden costs or one-sided clauses |
| Startup founder | "Review this NDA or service agreement before I sign today." | Unlimited liability, lock-in |
| Individual | "Explain my rental or employment agreement in plain language." | Being misled by a confident wrong answer |

## 4. Solution

### What the user gets

1. **Upload** a PDF, including scanned documents, which are read with OCR.
2. **Automatic review:** a summary, key points, risks, and missing information.
3. **Chat:** ask questions; every answer cites the page it came from.
4. **Control:** documents are private to the user and can be deleted at any time, which removes the file, its contents, and its chats.

### Product principle: trust over fluency

Legal answers are only useful if they are checkable. Three rules shape the product:

- **Grounded:** answers come only from the uploaded document, never from general knowledge.
- **Cited:** every answer shows its page and supporting text.
- **Honest abstention:** if the document doesn't contain the answer, the assistant says so. Blank fields in templates are reported as blank, not filled in.

### How it works (high level)

| Stage | What happens |
|---|---|
| Ingest | PDF text is extracted page by page; scanned pages go through OCR |
| Chunk | Text is split into overlapping, page-tagged chunks so citations can point to a page |
| Embed and store | Chunks are embedded and stored in Postgres with pgvector |
| Retrieve | Hybrid search: semantic similarity plus keyword overlap, typo-tolerant. Short documents are used whole |
| Answer | Precise questions are answered by quoting the matching sentence; otherwise an LLM answers from the retrieved chunks only and returns structured JSON with source numbers |
| Verify | Citations must match the answer's evidence; unsupported answers and leftover placeholders are replaced with an abstention or "left blank" message |

**Stack:** Next.js on Vercel · FastAPI on Render · Postgres + pgvector on Neon · Cloudflare R2 (files) · Cloudflare Workers AI (LLM, embeddings, OCR) · Brevo (account email) · PostHog (privacy-safe product analytics).

## 5. Key decisions

| Decision | Options considered | Choice and why |
|---|---|---|
| Analytics vs. privacy | Full event capture with AI inputs and outputs, or strict minimal events | **Strict minimal.** Users upload sensitive legal documents. PostHog receives no document text, file names, questions, or AI answers; users are identified only by an internal ID. A test fails the build if AI inputs or outputs are ever sent. |
| Event set | Autocapture, or a defined funnel | **A defined funnel:** `$pageview`, `logged_in`, `upload_started`, `upload_failed`, `analysis_completed`, `results_viewed`, `question_asked`. Autocapture and session recording are off. |
| Fixing wrong answers | Bigger model, or targeted rules plus evaluation | **Targeted rules, measured by an eval.** Failures clustered into two fixable patterns: cut-off quotes and blank template fields. |
| Upload failures | Backend investigation, or tracing the browser | **Trace the browser first.** Server logs showed that failed uploads never arrived, so the backend wasn't the cause. |

## 6. Results

### 6.1 AI answer quality: 8/20 → 16/20 → 18/20

The first evaluation (20 questions on a sample lease deed) scored **8/20**. The failures had two clear patterns:

- **Cut-off quotes:** answers ended mid-sentence ("…charged thereon in") because PDF line breaks split sentences.
- **Placeholders returned as answers:** template blanks such as `upto __________ years` or `(Name of the Owner)` were presented as facts.

Fixes shipped: answer-first formatting with complete quotes, routing cut-off or blank lines to the LLM, explicit placeholder rules, and a final check that replaces any leftover placeholder with "This is left blank in the document." The second evaluation scored **16/20**. A third run (v3) re-tested the 4 questions that failed in v2; 2 of 4 now pass, for **18/20 (90%)**. Details: [eval summary](../04-evals/eval-summary.md).

### 6.2 Upload reliability: 47% failure rate → fixed

PostHog showed **8 of 17 upload attempts failed (47%)**, including **both mobile attempts**. Users saw only "Unable to reach the server."

| Step | Finding |
|---|---|
| Server logs | Sign-up, verification, and login arrived, but no upload request did, not even the browser's pre-flight check |
| Browser | The upload is the only request that sends a file plus an authorization header. When the browser can't read the picked file or the network drops, it fails before sending anything |
| Fix (7 Oct 2026) | Copy the file into memory before uploading, retry network errors twice, accept PDFs whose type the phone leaves blank, show the real reason ("Couldn't open this file. Save it to your phone first, then upload."), and log richer, privacy-safe failure details |
| Verification | Automated Pixel 7 browser tests, run against a local copy of the app: before the fix, 1 of 3 upload scenarios passed; after the fix, 3 of 3 |

**Post-fix failure rate:** _TODO — measure from PostHog once there are 1–2 weeks of post-fix data._

### 6.3 Early usage (7–8 Oct 2026)

6 unique visitors and 15 sessions. 3 visitors tried to upload, and 1 reached results and asked questions (70 questions across 7 documents). That one heavy user is almost certainly my own testing, so **real-user activation is not yet established**. See [metrics](../03-metrics/metrics.md).

## 7. What I learned

1. **Instrument before you need it.** The 47% upload failure was invisible until `upload_failed` existed. The first version only logged a coarse error type, which wasn't enough to diagnose the problem, so the event now records the error name, a size bucket, and the file type.
2. **Evals turn "it feels wrong" into a fixable list.** Labeling each failure with a type (missed it, incomplete, wrong section) showed that two patterns explained most errors.
3. **Every quality fix needs a regression test.** One answer fix, a rule that dropped lines not ending in punctuation, broke answers on scanned PDFs, where OCR reads a final period as `_`. The automated OCR test caught it before more users were affected.
4. **Privacy is a product feature.** For legal documents, "we never see your text in analytics" is part of the value proposition, and it is enforced by tests rather than policy alone.

## 8. Next steps

- Measure the post-fix upload failure rate and the real-user activation rate (excluding the founder's own traffic).
- Grow the eval set beyond one lease deed (NDAs, employment and service agreements) and track the score per release.
- See the [roadmap](../06-roadmap/rice-roadmap.md) and [A/B test plan](../07-experiments/ab-test-plan.md).
