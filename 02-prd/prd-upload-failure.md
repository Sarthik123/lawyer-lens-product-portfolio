# PRD: Reliable Document Upload

| Field | Value |
|---|---|
| Owner | TODO |
| Status | TODO (Draft / In review / Shipped) |
| Last updated | TODO |
| Related | [Case study §6.2](../01-case-study/case-study.md#62-upload-reliability-47-failure-rate--fixed) · [Metrics](../03-metrics/metrics.md#upload-failure-rate) |

## 1. Problem

Uploads fail. 8 of 17 upload attempts (47%) failed. One real user tried twice within 2 minutes, both uploads got stuck, and they never saw an analysis.

Only about 4 real outside users exist, so the numbers are small. Treat them as an early signal, not proof.

A failed upload means no analysis, so no question and no activation. No outside user has asked a question yet. Retention is too early to measure.

## 2. Goals

| Goal | Metric | Target |
|---|---|---|
| Fewer Upload failures | Upload failure rate | From 47% to under 10% within 2 weeks  |
| Guardrail: keep answers good | Eval score | Stays at 18/20 or higher  |


## 3. Non-goals

- Redesigning the UI/UX. This release fixes upload reliability only.
- Blocking non-legal documents (document-type detection). Tracked as a separate backlog item.

## 4. User stories


| US-1 | user | upload a document and have it finish processing without errors or crashes | I get my analysis, including for long documents 
| US-2 | user | see a clear message and a retry option if an upload fails | I'm not left stuck guessing what happened |

## 5. Requirements

### Functional

| ID | Requirement | Priority |
|---|---|---|
| FR-1 | TODO | TODO (P0/P1/P2) |
| FR-2 | TODO | TODO |

### Non-functional

| ID | Requirement |
|---|---|
| NFR-1 | TODO (e.g. privacy: no file names or content in analytics) |
| NFR-2 | TODO |

## 6. Success metrics

| Metric | Baseline | Target | How measured |
|---|---|---|---|
| Upload failure rate | 47% (8/17) | TODO | `upload_failed` ÷ `upload_started` in PostHog |
| TODO | TODO | TODO | TODO |

## 7. Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| TODO | TODO | TODO | TODO |

## 8. Open questions

- TODO
