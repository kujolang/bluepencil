# Pending editorial corpus expansion

Six original synthetic pairs supplement the existing 18-pair corpus for a
proposed 24-case evaluation. They cover accessibility, international dates,
measurement uncertainty, correction history, consent, and reasoned disagreement.
The new text is supplied under the repository MIT license. No external text was
copied. These are candidate fixtures awaiting independent review, not six new
validated reference judgments.

Give each independent reviewer the frozen candidate file and the existing
quality rubric. Do not share another reviewer's labels or any proposed answer
key. Record reviewer identity, review date, candidate-file SHA-256, per-case
preference (A/B/TIE), eight dimension ratings, blockers, and a rationale. Reviewers
must disclose prior access to the cases or labels and participation in authorship.
A reviewer who authored the cases cannot supply an independent label for them.

After both complete submissions, preserve their original bytes. Prepare a
JSON input with `schema_name: "bluepencil.reviewer-agreement"`,
`schema_version: "1.0.0"`, and two `reviewers`, each containing
`reviewer_id`, `provenance` (`source`, `blinded: true`, `independent: true`), and
`judgments` (`case_id`, `case_sha256`, `preferred_candidate`). Use the same frozen
case hash and case identifiers in both sets. Run:

```bash
bluepencil reviewer-agreement --input independent-labels.json --json
```

Report raw agreement, Cohen's kappa, category frequencies in the source labels,
sample size, and disagreements. Kappa is null when both reviewers always choose
the same category; do not report that degenerate case as kappa 1. Agreement does
not establish accuracy. The CLI validates shape and computes statistics; it
cannot authenticate reviewer identity, independence, or blind procedure.

Adjudicate disputes separately after the blind round. Keep original labels and
adjudication provenance, and only then promote the new pairs into the versioned
reference manifest. Do not silently change examples to increase agreement.

Current evidence: six candidates and tested measurement code. Missing evidence:
two independent completed label sets and their measured agreement. The existing
18-pair corpus remains unchanged. Synthetic unit-test labels are never results
for this expansion or evidence of semantic editorial quality.
