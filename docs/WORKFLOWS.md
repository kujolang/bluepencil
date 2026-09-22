# Evaluation workflow contracts

All evaluation commands take a bounded JSON `--input FILE` and produce the
standard CLI envelope. They are offline and do not modify source artifacts or
approve publication. A failed deterministic format rule returns a nonzero exit
with individual checks in `data`. Invalid contracts also fail nonzero.

| Command | Required input | Meaning of success |
| --- | --- | --- |
| `reviewer-agreement` | Versioned `bluepencil.reviewer-agreement` input; two distinct reviewer identities, independent/blind provenance, matching frozen cases | Raw agreement and nominal Cohen's kappa; supplied provenance is not authenticated |
| `panel-agreement` | Versioned `bluepencil.panel-agreement` input; independent source provenance, 2..1000 frozen cases with the same 2..20 ratings each | Mean within-case pairwise agreement and nominal Fleiss' kappa; reviewers may differ between cases |
| `calibration-score` | `blinded: true`, equally sized nonempty arrays `expected` and `observed` of judgment strings | Exact supplied judgment agreement, not independent proof of blinding or taste |
| `calibration-trend` | `runs`: ordered scoring-input objects, optional `run_id` | Disagreement-rate changes in supplied order |
| `bundle-verify` | `bundle` with `bundle_id`/`version`, hexadecimal `signature`, `key_id`; explicit `--key-file` | HMAC-SHA256 authenticates the canonical bundle under a locally trusted shared key |
| `bundle-upgrade` | `current` and `candidate` bundle manifests | Same identity/major version and no downgrade; not a migration |
| `format-check` | `format` and `content` | Deterministic field checks described below |
| `accessibility-check` | `declared: true`, unique supported `capabilities` | Declaration schema accepted; `independently_verified: false` |
| `adapter-check` | `offline: true`, `redaction_gate: complete` or `redacted`, object `model_output` | Receipt shape and secret-shaped keys checked; execution/redaction remain declarations |

Format content contracts:

- Newsletter: nonempty `subject`, `preview_text`, exactly one text item in
  `primary_ctas`, and a text `label` for each supplied `links` entry.
- Social: nonempty `platform`, integer `character_budget` (1..100000), nonempty
  `body` within that budget, `links_disclosed: true`, and text `alt` for each
  supplied `media` entry.
- Case study: `subject_consent: true`, at least one `claims` entry with a text
  `evidence` reference, text `results_scope`, and text `attribution` on quotes.
- Audiovisual script: at least one `scenes` entry, each with text `speaker` and
  `visual`, plus text `caption_plan` and `audio_description_plan`.

These checks verify supplied fields, not the truth of consent, evidence,
accessibility, or disclosure. Empty optional media/link/quote lists are valid.

A trusted key file is bounded to 8 KiB and contains `key_id`, `status: active`,
and `material` (16..4096 bytes of key text). It is never included in CLI output
or persisted in editorial records. Supply trust out of band; do not accept the
key file from the bundle's untrusted sender. Keep it outside version control and
restrict local access. To rotate, distribute a new key ID/material through that
trusted channel. To revoke, mark the old key `status: revoked`; verification
refuses it. HMAC is shared-secret authentication, not public-key authorship.

Record schemas preserve safe unknown metadata. Runtime validation additionally
checks Gregorian dates, secret-shaped keys, bound artifact digests, and blocker
precedence. JSON Schema `format` annotations alone do not validate dates.

Both agreement contracts use `schema_version: "1.0.0"` and the corresponding
`schema_name`. Cohen judgments contain `case_id`, `case_sha256`, and
`preferred_candidate` (`A`, `B`, or `TIE`). See the
[two-reviewer input example](../fixtures/editorial_expansion/README.md).
Panel cases contain `case_id`, `case_sha256`, and `ratings`; labels may be `A`,
`B`, `TIE`, or `NEITHER`. `TIE` means equal preference, while `NEITHER` means both
candidates are invalid. Panel `provenance` requires nonempty `source` and
`independent: true`. Duplicate case IDs and unequal panel sizes are rejected.
Kappa is `null` with `kappa_defined: false` when all ratings occupy one category.
See [licensed corpus methodology](../fixtures/helpsteer2/README.md) for an
independently sourced example. Agreement is not accuracy; no reviewer identity
or provenance assertion becomes authenticated merely by passing this command.
