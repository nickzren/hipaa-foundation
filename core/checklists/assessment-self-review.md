# Assessment Self-Review Checklist

Run this checklist before finalizing any output.

- [ ] Did I check the content policy first?
- [ ] Did I determine entity type before setting assessment depth?
- [ ] Did I produce the structured triage block before domain findings?
- [ ] For every addressable Security Rule spec, did I capture the addressable disposition?
- [ ] Did I keep `missing_evidence` separate from `observed_gap`?
- [ ] Did I apply the repo-only realism rule for organizational controls?
- [ ] Did I avoid treating addressable specs as gaps when the disposition is undocumented in a repo-only review?
- [ ] If `entity_type` is `tbd`, did I avoid pulling entity-gated Privacy domains or describing the system as a covered entity or provider?
- [ ] Did `applicable_rules` match triage semantics — including `enforcement_rule` for context, and excluding `privacy_rule` when `entity_type` is `tbd` unless independently confirmed?
- [ ] If `part11-foundation` or `gamp5-foundation` was also used, did I keep findings separate by repo ownership?
- [ ] Did the output begin AND end with the exact disclaimer?
