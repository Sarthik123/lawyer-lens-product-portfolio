# Metrics

**Data window:** 7–8 Oct 2026 (first two days with privacy-safe analytics live)
**Source:** PostHog event export, 302 events. A sanitized copy is in [events-sanitized.csv](events-sanitized.csv) with person and session IDs, URL tokens, and document IDs removed.
**Dashboard:** [Looker Studio](TODO-add-looker-studio-link) · [screenshot](screenshots/analytics-dashboard-2026-10-07.png)

> **Read with care:** the sample is tiny, and one visitor (almost certainly the founder testing) generated 70 of 70 questions and 10 of 15 sessions. These numbers describe the launch window, not product-market fit.

---

## 1. North Star metric

**Documents reviewed with a grounded answer, per week:** documents where the user saw the analysis (`results_viewed`) and asked at least one question (`question_asked`).

**Why this metric:** it captures the moment the product delivers its core value, a trusted answer from the user's own document. Uploads alone can fail or be abandoned, and page views say nothing about value.

**Current value:** not yet meaningful. The only qualifying user in the window is the founder.

## 2. Event tracking plan

| Event | Fires when | Properties (privacy-safe only) |
|---|---|---|
| `$pageview` | Any page is viewed | path |
| `logged_in` | Successful login | — |
| `upload_started` | User clicks Upload | — |
| `upload_failed` | Upload fails | `error_type`, `error_name`, `error_message` (file names stripped), `file_size_bucket`, `mime_type` |
| `analysis_completed` | A document finishes processing during the visit | `duration_ms` |
| `results_viewed` | Analysis is shown, once per document visit | — |
| `question_asked` | User sends a chat question | — (no question text) |

Never sent: document text, file names, questions, AI answers, emails. Users are identified by an internal ID only.

## 3. AARRR funnel (7–8 Oct 2026)

| Stage | Definition | Value | Query |
|---|---|---|---|
| **Acquisition** | Unique visitors | **6** visitors, **15** sessions | [funnel.sql](sql/funnel.sql) |
| **Activation** | Visitor who viewed results *and* asked a question | **1 of 6** (17%) | [activation.sql](sql/activation.sql) |
| **Retention** | Visitor active on more than one day | **1 of 6** | [repeat_users.sql](sql/repeat_users.sql) |
| **Referral** | Visits referred by another user | Not tracked yet | — |
| **Revenue** | Paying users | **0**: the product is free during MVP | — |

### Upload funnel (event counts)

| Step | Events | Visitors |
|---|---|---|
| `upload_started` | 17 | 3 |
| `upload_failed` | 8 | 3 |
| `analysis_completed` | 3 | 1 |
| `results_viewed` | 18 | 1 |
| `question_asked` | 70 | 1 |

`results_viewed` (18) exceeds `analysis_completed` (3) because it also fires when a user reopens a document that was already processed.

### Upload failure rate

| Segment | Failed / started | Rate |
|---|---|---|
| **All** | 8 / 17 | **47%** |
| Desktop | 6 / 15 | 40% |
| Mobile | 2 / 2 | 100% |

The fix shipped on 7 Oct 2026 (see the [case study](../01-case-study/case-study.md#62-upload-reliability-47-failure-rate--fixed)). **Target:** under 5% failure rate. _TODO: re-measure after 1–2 weeks of post-fix data._

### Traffic mix

| Dimension | Breakdown (share of 302 events) |
|---|---|
| Device | Desktop 280 (93%) · Mobile 22 (7%) |
| Country | India 295 · Portugal 4 · Canada 2 · United States 1 |
| Source | Direct 192 · Internal navigation 100 · Gmail app 9 · Google search 1 |

The 9 Gmail-app visits are consistent with users arriving from the verification email.

## 4. Retention and churn

| Metric | Definition | Value |
|---|---|---|
| Day-1 retention | Visitors active on day N+1 ÷ visitors active on day N | 1 of 6 (window too short to be meaningful) |
| Weekly retention | Visitors active in week W+1 ÷ visitors active in week W | _TODO — needs 2+ weeks of data_ |
| Churn | 1 − weekly retention among activated users | _TODO — needs 2+ weeks of data_ |

## 5. Unit economics (CAC / LTV)

Not measurable yet: there is no paid acquisition and no revenue.

| Metric | Formula | Status |
|---|---|---|
| CAC | Acquisition spend ÷ new activated users | No spend so far; all traffic is direct or email |
| LTV | Average revenue per user per month × gross margin × average lifetime (months) | No pricing yet |
| Cost per document | (AI inference + storage + hosting) ÷ documents processed | _TODO — pull Cloudflare Workers AI and hosting bills_ |

## 6. Data sources and queries

| Query | Source | File |
|---|---|---|
| Sign-ups per day | App database (`users` table, counts only) | [signups.sql](sql/signups.sql) |
| Activation rate | PostHog events | [activation.sql](sql/activation.sql) |
| Upload funnel | PostHog events | [funnel.sql](sql/funnel.sql) |
| Documents per user | App database (`documents` table) | [docs_per_user.sql](sql/docs_per_user.sql) |
| Repeat users | PostHog events | [repeat_users.sql](sql/repeat_users.sql) |

The PostHog queries run against the **raw** export (with `person_id` and `session_id`) loaded into a table named `events`; they cannot be re-run on the sanitized CSV in this repo. Sign-ups aren't a PostHog event, so they come from the app database.
