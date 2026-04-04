#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"

ROOT = File.expand_path("..", __dir__)

TARGET = ARGV[0]
abort("usage: ruby scripts/generate_foundation.rb /path/to/output") unless TARGET

STATIC_FILES = %w[
  AGENTS.md
  CLAUDE.md
  README.md
  LICENSE
  CONTRIBUTING.md
  Makefile
  .gitignore
  skills/SKILL.md
  skills/codex/SKILL.md
  skills/claude-code/SKILL.md
  skills/hipaa-assessor/SKILL.md
  skills/hipaa-assessor/START-HERE.md
  skills/hipaa-assessor/references/index.yaml
  skills/hipaa-assessor/scripts/resolve-foundation-root.sh
  core/provenance/source-manifest.yaml
  core/provenance/decision-log.yaml
  core/provenance/content-policy.yaml
  core/applicability/triage.yaml
  core/applicability/triage-output-template.yaml
  core/checklists/assessment-rubric.yaml
  core/checklists/evidence-map.yaml
  core/checklists/assessment-self-review.md
  core/index/domain-inventory.yaml
  core/index/node-inventory.yaml
  core/guidance/scope-and-application.yaml
  core/domains/entity-and-applicability.yaml
  core/domains/risk-analysis-and-management.yaml
  core/domains/privacy-uses-and-disclosures.yaml
  core/domains/minimum-necessary.yaml
  core/domains/individual-rights.yaml
  core/domains/administrative-safeguards.yaml
  core/domains/physical-safeguards.yaml
  core/domains/technical-safeguards.yaml
  core/domains/organizational-requirements.yaml
  core/domains/breach-notification.yaml
  core/domains/policies-procedures-documentation.yaml
  core/domains/training-and-sanctions.yaml
  docs/assessment-output-template.md
  docs/example-assessment.md
  docs/example-assessment-ba.md
  docs/example-assessment-entity-tbd.md
  docs/skill-install-and-use.md
  scripts/install-codex-skill.sh
  scripts/install-claude-skill.sh
  scripts/validate.sh
  scripts/validate.rb
  scripts/generate_foundation.rb
  .github/workflows/validate.yml
].freeze

regulation_files = Dir.glob(File.join(ROOT, "core/regulations/*.yaml")).sort.map do |f|
  f.sub("#{ROOT}/", "")
end

FILES = (STATIC_FILES + regulation_files).uniq.freeze

target_root = File.expand_path(TARGET)
FileUtils.mkdir_p(target_root)

FILES.each do |relative_path|
  source = File.join(ROOT, relative_path)
  destination = File.join(target_root, relative_path)
  FileUtils.mkdir_p(File.dirname(destination))
  FileUtils.cp(source, destination)
end

%w[
  scripts/install-codex-skill.sh
  scripts/install-claude-skill.sh
  scripts/validate.sh
  skills/hipaa-assessor/scripts/resolve-foundation-root.sh
].each do |relative_path|
  FileUtils.chmod("+x", File.join(target_root, relative_path))
end

puts "Generated hipaa-foundation scaffold at #{target_root}"
