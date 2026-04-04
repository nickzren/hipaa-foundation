# Contributing

## Getting started

1. Fork and clone this repository.
2. Run `make validate` to confirm the baseline passes.
3. Make your changes.
4. Run `make validate` again to confirm nothing breaks.

## Guidelines

- All YAML files must parse cleanly and include `schema_version: v1`.
- New domain files must be added to `core/index/domain-inventory.yaml`.
- New files referenced by the skill must be added to `skills/hipaa-assessor/references/index.yaml`.
- Keep the validator and generator in sync with any structural changes.
- Do not add the Security Rule NPRM content as if it were effective regulation.
- Do not add Part 162 assessment modules until the CMS-aware transaction module is designed.

## Content policy

This is a public, MIT-licensed repository. The CFR text is public domain. Original repo content (summaries, rubric, workflow, evidence map) is MIT-licensed. See `core/provenance/content-policy.yaml`.

## Commit style

```
type(scope): Short description
```

## Questions

Open an issue.
