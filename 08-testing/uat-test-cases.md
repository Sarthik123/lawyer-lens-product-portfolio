# UAT Test Cases

| Field | Value |
|---|---|
| Release / build | TODO |
| Environment | Real Android phone; PDF uploaded from the Downloads folder |
| Tester | TODO |
| Date | 8 Oct 2026 |

**Status values:** Pass · Fail · Blocked · Not run

| ID | Scenario | Steps | Expected | Actual | Status |
|---|---|---|---|---|---|
| UAT-01 | Upload a PDF | Upload a PDF from the phone's Downloads folder | The PDF uploads | Uploaded as expected | Pass |
| UAT-02 | Analysis | After upload, let the document be analysed | Analysis completes | Analysis completed as expected | Pass |
| UAT-03 | Chat / questions | Ask questions about the uploaded document | Questions are answered | Questions answered as expected | Pass |
| UAT-04 | Document preview | View the uploaded document in the preview area | A readable preview of the document | The preview area shows a grey PDF box with the internal document ID and an Open button instead of a readable preview | Fail (cosmetic) |

## Defects found

| Defect ID | Linked test | Severity | Description | Suggested fix | Status |
|---|---|---|---|---|---|
| DEF-01 | UAT-04 | Low | The document preview shows a grey PDF box with the internal document ID and an Open button instead of a readable preview. | Show the filename and an "Open PDF" label instead of the ID. | Open |

## Sign-off

TODO
