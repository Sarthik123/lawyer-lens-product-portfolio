# Wireframes

Low-fidelity layouts of the four core screens as shipped. High-fidelity designs: [figma-links.md](figma-links.md).

## 1. Home

```
┌──────────────────────────────────────────────┐
│  [ AI Legal Document Reviewer ]              │
│                                              │
│  Understand your legal documents             │
│  with confidence.                            │
│                                              │
│  Upload a legal document, identify risks     │
│  and missing information, and ask questions. │
│                                              │
│  [ Review a Document ]   [ Learn More ]      │
│                                              │
│  Your documents are private to you.          │
│  Delete them anytime. Privacy policy →       │
├──────────────────────────────────────────────┤
│  Disclaimer · Privacy · Give feedback        │
└──────────────────────────────────────────────┘
```

## 2. Upload

```
┌──────────────────────────────────────────────┐
│  Review a Document                           │
│  Upload a PDF to begin your review.          │
│ ┌──────────────────────────────────────────┐ │
│ │ [ Choose file ]                          │ │
│ │ Selected: lease.pdf              (×)     │ │
│ │ [ Upload Document ]                      │ │
│ │ ⟳ Uploading and processing…             │ │
│ │ PDF only · Max 10 MB                     │ │
│ │ Your documents are private to you.       │ │
│ └──────────────────────────────────────────┘ │
│  Uploaded successfully.  [ Go to Dashboard ] │
└──────────────────────────────────────────────┘
```

Error states: wrong file type · file over 10 MB · "Couldn't open this file. Save it to your phone first, then upload." · connection problem, with a Retry button.

## 3. Dashboard

```
┌──────────────────────────────────────────────┐
│  Your documents          [ Upload document ] │
│ ┌──────────────────────────────────────────┐ │
│ │ lease.pdf                                │ │
│ │ processed · 48,210 characters            │ │
│ │ uploaded date        [ Open ] [ Delete ] │ │
│ └──────────────────────────────────────────┘ │
│  Empty state: "No documents yet" +           │
│  [ Upload your first document ]              │
└──────────────────────────────────────────────┘
```

## 4. Document review

```
┌──────────────────────────────────────────────┐
│  ← Back to Dashboard                         │
│  lease.pdf · Document Review                 │
│ ┌─────────────── PDF Document ─────────────┐ │
│ │            (embedded PDF viewer)         │ │
│ └──────────────────────────────────────────┘ │
│ ┌──────────── Document Information ────────┐ │
│ │ Summary · Key Points · Potential Risks · │ │
│ │ Missing Information                      │ │
│ └──────────────────────────────────────────┘ │
│ ┌──────────── Document Chat ──── Clear chat ┐ │
│ │  You: Who pays the taxes?                │ │
│ │  AI: The Lessee pays all taxes.          │ │
│ │      ▸ Sources (Page 3 · Line 12: "…")   │ │
│ │ [ Ask about this document… ]  [ Send ]   │ │
│ └──────────────────────────────────────────┘ │
│              Give feedback                   │
└──────────────────────────────────────────────┘
```
