# AI Answer-Quality Evaluation

## Headline

| Run | Score | Change |
|---|---|---|
| v1 (baseline) | **8 / 20** (40%) | — |
| v2 (after fixes) | **16 / 20** (80%) | **+8 answers, accuracy doubled** |
| v3 (follow-up spot check) | 2 / 4 | _TODO: describe what v3 covered_ |

Raw data: [eval-v1.csv](eval-v1.csv) · [eval-v2.csv](eval-v2.csv) · [eval-v3.csv](eval-v3.csv)

## 1. Method

- **Document:** a standard Indian lease-deed template (PDF) containing real clause text and unfilled blanks such as `__________` and `(Name of the Owner)`. This makes it a good test of whether the assistant invents answers.
- **Questions:** 20 questions a tenant or landlord would ask. The 6 recorded in `eval-v1.csv` cover who pays taxes, who handles repairs, the renewal option, the enhanced rent, a true/false check on a specific permission, and an overview question.
- **Ground truth:** the correct answer for each question was taken by hand from the PDF.
- **Procedure:** each question was asked in the Lawyer Lens chat, and the answer and citation were recorded and graded by hand.

## 2. Scoring rubric

Each answer is graded on three columns:

| Column | Values | Meaning |
|---|---|---|
| Correct? | Yes / Partly / No | Does the answer match the ground truth? |
| Gave page number? | Yes / No | Is the answer cited to a page? |
| Failure type | Missed it / Incomplete / Wrong section / — | Why a non-Yes answer failed |

**Score = number of answers graded "Yes", out of 20.** "Partly" counts as not correct. For example, v2's 16 correct plus 4 failures (3 incomplete, 1 wrong section) adds up to 20.

| Failure type | Definition |
|---|---|
| Missed it | The answer exists in the document, but the assistant didn't give it |
| Incomplete | Right clause, but the answer is cut off or missing the key fact |
| Wrong section | The assistant quoted an unrelated part of the document |

## 3. Results

### v1: baseline (8/20)

The v1 file records 6 of the graded questions:

| Question (shortened) | Expected | Result | Cited page | Failure |
|---|---|---|---|---|
| How many more years can the lease continue? | Up to 5 years | No | Yes | Missed it: returned the blank `upto __________ years` |
| What is the document about? | A lease deed between a Lessor and a Lessee | Yes | Yes | — |
| Who carries out repairs? | The Lessor | Yes | Yes | — |
| Who pays taxes, rates, and cesses? | The Lessee | No | Yes | Missed it: quote cut off at "charged thereon in" |
| Exact amount of the enhanced rent? | Not stated | Partly | Yes | Incomplete: quoted an unrelated blank |
| Can the Lessee install an ATM at no extra rent? | True | Yes | Yes | — |

All 6 recorded answers cited a page. The failures were not hallucinated facts; they came from **how answers were extracted and presented**.

### Failure patterns found in v1

1. **Cut-off quotes.** Answers ended mid-sentence because the PDF splits sentences across lines ("…charged thereon in").
2. **Placeholders presented as answers.** Template blanks (`__________`, `(Name of the Owner)`, `(city) civil courts`) were returned as if they were facts.
3. **Quote instead of answer.** Answers began "The document states: …" and pasted text without directly answering the question.

### v2: after fixes (16/20)

| Failure type | Count |
|---|---|
| Incomplete | 3 |
| Wrong section | 1 |
| **Total incorrect** | **4** |

Tester's note on the main remaining issue: _"It seems like it was just extracting text and not able to understand context."_ Suggested next fix: improve context.

## 4. What changed between v1 and v2

| Fix | Addresses |
|---|---|
| Answer rules: lead with one plain sentence that answers the question, then quote the full supporting sentence with its page | Quote-instead-of-answer, cut-off quotes |
| Blank detection: if the relevant clause is a blank or placeholder, answer "This is left blank in the document." | Placeholders as answers |
| Route cut-off lines, very long lines, and lines containing placeholders from the fast quote-matching path to the LLM path, which follows the rules above | Cut-off quotes, placeholders |
| Final safety check: if an answer still contains a placeholder, replace it with "This is left blank in the document." and keep the citation | Placeholders the LLM still returned |

Each fix shipped with automated tests using the real failing examples from this eval.

### A regression caught by testing

One fix, "drop any quoted line that doesn't end in punctuation," broke answers on **scanned** PDFs, because OCR reads a final period as `_`. The automated OCR test caught this before more users were affected, and the rule was narrowed to lines that end mid-clause (on a lowercase word, comma, or hyphen). **Lesson:** every eval-driven fix needs a regression test on other document types.

## 5. Limitations and next steps

- **One document.** Every question comes from a single lease template. _TODO: add NDAs, employment, and service agreements, plus at least one scanned PDF._
- **Partial v1 log.** The v1 file records 6 of the 20 graded questions. _TODO: export the full 20-row v1 and v2 sheets._
- **Manual grading.** One person graded every answer. _TODO: double-grade a sample to check agreement._
- **Target for v3+:** at least 18/20 on the expanded set, with no fabricated facts and no placeholders shown as answers.
