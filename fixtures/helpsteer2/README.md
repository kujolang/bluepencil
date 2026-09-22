# Independently labeled writing preferences

This supplement adds 18 writing, rewriting, editing, and summarization prompt/
response pairs from **NVIDIA HelpSteer2-Preference**, with the publisher's original
human annotations. It complements the 18 role-specific pairs in `../calibration`;
it does not assign BluePencil's eight editorial dimensions or certify accuracy.

## Attribution and license

Dataset: NVIDIA HelpSteer2-Preference, by Zhilin Wang, Alexander Bukharin, Olivier
Delalleau, Daniel Egert, Gerald Shen, Jiaqi Zeng, Oleksii Kuchaiev, and Yi Dong;
annotation collection in partnership with Scale AI.

- [Dataset and license declaration](https://huggingface.co/datasets/nvidia/HelpSteer2)
- [Pinned source card](https://huggingface.co/datasets/nvidia/HelpSteer2/blob/990b2711a36180dd19d9c94b8627844866f8982a/README.md)
- [Collection methodology, section 2](https://arxiv.org/html/2410.01257v2)
- [CC BY 4.0 license](https://creativecommons.org/licenses/by/4.0/)
- [CC BY 4.0 legal text](https://creativecommons.org/licenses/by/4.0/legalcode.en)
- [Bundled license text](LICENSE)

`corpus.json` is redistributed under **CC BY 4.0**, not the repository's MIT
license. Retain this attribution and license link when redistributing it. NVIDIA
and the authors do not endorse BluePencil. The source texts and raw annotations
are unchanged; BluePencil selects a subset, renames response fields A/B, omits
aggregated/processed preference fields, and adds IDs, hashes, and provenance.
Generated agreement measurements and importer code are BluePencil contributions.

Source revision: `990b2711a36180dd19d9c94b8627844866f8982a`.
Source file: `preference/preference.jsonl.gz`.
Compressed SHA-256: `a5cd48600fb7a330cf0ccc8f59051e24e8f236907c379f42eff1ba18da55204b`.
Vendored SHA-256: `8f07e44268f520ce29dc2625a8ae8cd85710e0e99a4b44dd9315c88f8ef5fb61`.
Each case retains its 1-based source row, exact source-line hash, and canonical
case hash. Annotation identities are not published; array positions must not be
presented as persistent reviewers across cases.

## Selection and measurement

The deterministic importer takes the first 18 source-order `val` rows whose
prompt contains a whole word `write`, `rewrite`, `summarize`, `summary`, `edit`,
or `proofread`, whose prompt plus two responses occupy at most 12,000 UTF-8 bytes,
and which contain at least three original annotations. Selection does not use
preferences, agreement, or expected winners. Rows scanned: 8,751.

The measurement uses the **first three** `all_preferences_unprocessed` entries,
never the publisher's `three_most_similar_preferences`. Strengths -3..-1 map to
A, 1..3 to B, and -100 to NEITHER; there is no invented tie annotation. Strength
and all original justifications remain available in the fixture. Fleiss' nominal
kappa permits different reviewers per case and gives each case equal weight.

The checked result in `agreement.json` contains 54 ratings: 29 A and 25 B.
Mean within-case pairwise agreement is **77.78%**; **Fleiss' kappa is 0.5531**.
Six of 18 panels disagree. These results describe this small, nonrandom writing
subset of the published population. They do not measure BluePencil accuracy,
inter-rater reliability across all editorial roles, or independent verification
of reviewer identity. Independence is reported by the dataset authors; the
upstream collection and filtering policies still apply.

## Reproduce

Offline measurement:

```bash
kujo run scripts/evaluate_editorial_preferences.kujo
```

Re-download the immutable source, verify its checksum, and reproduce the
vendored fixture byte for byte (network required only for this optional import):

```bash
KUJO_BIN=/absolute/pinned/kujo bash scripts/import_editorial_preferences.sh
```

Use `panel-agreement --input FILE --json` for similarly sized independent panels,
or `reviewer-agreement` when two persistent, identified reviewers label every
frozen case. Neither statistic is an editorial quality score.
