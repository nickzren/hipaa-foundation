#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
PASS = 0
FAIL = 1

errors = []
checks = []

def check(label, errors)
  yield
  puts "  check #{label}: PASS"
rescue => e
  errors << "#{label}: #{e.message}"
  puts "  check #{label}: FAIL - #{e.message}"
end

def relative_path(absolute)
  absolute.sub("#{ROOT}/", "")
end

def load_yaml(relative)
  YAML.safe_load(File.read(File.join(ROOT, relative)))
end

def load_text(relative)
  File.read(File.join(ROOT, relative))
end

def require_schema_v1(data, label)
  raise "#{label} missing schema_version" unless data["schema_version"]
  raise "#{label} schema_version must be v1" unless data["schema_version"] == "v1"
end

def ensure_includes(relative, snippets)
  text = load_text(relative)
  snippets.each do |snippet|
    raise "#{relative} missing required text #{snippet.inspect}" unless text.include?(snippet)
  end
end

puts "hipaa-foundation validator"
puts "=" * 40

# Check 1: Required files
checks << "required files"
check("#{checks.length} required files", errors) do
  required = %w[
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
    docs/assessment-output-template.md
    docs/example-assessment.md
    docs/example-assessment-ba.md
    docs/example-assessment-entity-tbd.md
    docs/manual-acceptance-harness.md
    docs/skill-install-and-use.md
    scripts/validate.rb
    scripts/validate.sh
    scripts/install-codex-skill.sh
    scripts/install-claude-skill.sh
    scripts/smoke-test-resolver.sh
    scripts/smoke-test-install.sh
    scripts/generate_foundation.rb
    .github/workflows/validate.yml
    test/fixtures/README.md
    test/fixtures/minimal-target/README.md
    test/fixtures/minimal-target/docs/architecture.md
    test/fixtures/minimal-target/src/service.py
    test/fixtures/rich-target/README.md
    test/fixtures/rich-target/docs/architecture.md
    test/fixtures/rich-target/docs/data-flow.md
    test/fixtures/rich-target/infra/storage.tf
    test/fixtures/rich-target/src/pipeline.py
  ]
  missing = required.reject { |f| File.exist?(File.join(ROOT, f)) }
  raise "missing files: #{missing.join(', ')}" unless missing.empty?
end

# Check 2: Content policy
checks << "content policy"
check("#{checks.length} content policy", errors) do
  data = load_yaml("core/provenance/content-policy.yaml")
  require_schema_v1(data, "content-policy")
  raise "missing policy_id" unless data["policy_id"]
  raise "missing repo_visibility" unless data["repo_visibility"]
end

# Check 3: Decision log
checks << "decision log"
check("#{checks.length} decision log", errors) do
  data = load_yaml("core/provenance/decision-log.yaml")
  raise "missing schema_version" unless data["schema_version"]
  raise "missing entries" unless data["entries"].is_a?(Array)
  raise "entries must not be empty" if data["entries"].empty?
  data["entries"].each do |entry|
    %w[id topic decision status].each do |key|
      raise "entry missing #{key}: #{entry}" unless entry[key]
    end
  end
end

# Check 4: Triage schema
checks << "triage schema"
check("#{checks.length} triage schema", errors) do
  data = load_yaml("core/applicability/triage-output-template.yaml")
  require_schema_v1(data, "triage-output-template")

  required_enums = %w[
    entity_type covered_entity_type hybrid_entity_status
    entity_type_confidence phi_scope_confidence
    evidence_basis assessment_confidence
    part_162_assessment_mode state_law_overlay_status
  ]
  required_enums.each do |field|
    raise "missing required_enum_fields.#{field}" unless data.dig("required_enum_fields", field)
    raise "missing values for #{field}" unless data.dig("required_enum_fields", field, "values").is_a?(Array)
  end

  required_lists = %w[phi_types_in_scope applicable_rules in_scope_domains excluded_domains open_decisions]
  required_lists.each do |field|
    raise "missing required_list_fields.#{field}" unless data.dig("required_list_fields", field)
  end

  raise "missing propagation_rule" unless data["propagation_rule"]
  raise "missing canonical_domain_vocabulary" unless data["canonical_domain_vocabulary"].is_a?(Array)
end

# Check 5: Rubric states and addressable rules
checks << "rubric states"
check("#{checks.length} rubric states", errors) do
  data = load_yaml("core/checklists/assessment-rubric.yaml")
  require_schema_v1(data, "assessment-rubric")

  expected_states = ["Adequate", "Partial", "Gap", "Not assessed", "Not applicable"]
  actual_states = data["finding_states"].map { |s| s["state"] }
  missing_states = expected_states - actual_states
  raise "missing finding states: #{missing_states.join(', ')}" unless missing_states.empty?

  raise "missing addressable_rules" unless data["addressable_rules"].is_a?(Hash)
  raise "missing documented_exception_is_not_a_gap" unless data.dig("addressable_rules", "documented_exception_is_not_a_gap")
  raise "missing basis_types" unless data["basis_types"].is_a?(Array)
  raise "missing severity_options" unless data["severity_options"].is_a?(Array)
  raise "missing repo_only_realism_rule" unless data["repo_only_realism_rule"]
end

# Check 6: Skill enum consistency
checks << "skill enum consistency"
check("#{checks.length} skill enum consistency", errors) do
  triage = load_yaml("core/applicability/triage-output-template.yaml")
  rubric = load_yaml("core/checklists/assessment-rubric.yaml")
  skill_text = load_text("skills/hipaa-assessor/SKILL.md")

  %w[
    entity_type covered_entity_type hybrid_entity_status
    entity_type_confidence phi_scope_confidence
    evidence_basis assessment_confidence
    part_162_assessment_mode state_law_overlay_status
  ].each do |field|
    values = triage.dig("required_enum_fields", field, "values")
    raise "missing enum values for #{field}" unless values.is_a?(Array)

    values.each do |value|
      raise "skills/hipaa-assessor/SKILL.md missing enum value #{field}=#{value}" unless skill_text.include?("`#{value}`")
    end
  end

  rubric["finding_states"].each do |entry|
    state = entry["state"]
    raise "skills/hipaa-assessor/SKILL.md missing finding state #{state}" unless skill_text.include?("`#{state}`")
  end

  %w[implemented alternative documented_exception not_evidenced].each do |value|
    raise "skills/hipaa-assessor/SKILL.md missing addressable disposition #{value}" unless skill_text.include?("`#{value}`")
  end
end

# Check 7: Evidence map structure
checks << "evidence map structure"
check("#{checks.length} evidence map structure", errors) do
  data = load_yaml("core/checklists/evidence-map.yaml")
  require_schema_v1(data, "evidence-map")
  raise "missing sections" unless data["sections"].is_a?(Hash)

  data["sections"].each do |domain_id, section|
    %w[look_for_in_code look_for_in_infrastructure look_for_in_docs look_for_in_external_evidence common_false_positives].each do |key|
      raise "#{domain_id} missing #{key}" unless section[key].is_a?(Array)
    end
  end
end

# Check 8: Domain inventory and files
checks << "domain inventory and files"
check("#{checks.length} domain inventory and files", errors) do
  data = load_yaml("core/index/domain-inventory.yaml")
  require_schema_v1(data, "domain-inventory")
  raise "missing domains" unless data["domains"].is_a?(Array)

  # Forward check: every inventory entry has a file
  data["domains"].each do |domain|
    %w[id title file].each do |key|
      raise "domain missing #{key}" unless domain[key]
    end
    raise "domain file missing: #{domain['file']}" unless File.exist?(File.join(ROOT, domain["file"]))

    domain_data = load_yaml(domain["file"])
    require_schema_v1(domain_data, domain["file"])
    raise "#{domain['file']} id mismatch: #{domain_data['id']} vs #{domain['id']}" unless domain_data["id"] == domain["id"]
  end

  # Reverse check: every domain file is in the inventory
  inventory_files = data["domains"].map { |d| d["file"] }
  Dir.glob(File.join(ROOT, "core/domains/*.yaml")).each do |file|
    rel = relative_path(file)
    raise "domain file #{rel} not in inventory" unless inventory_files.include?(rel)
  end

  # Cross-check: evidence map covers all domains
  evidence_map = load_yaml("core/checklists/evidence-map.yaml")
  inventory_ids = data["domains"].map { |d| d["id"] }
  missing_in_evidence = inventory_ids - evidence_map["sections"].keys
  raise "domains missing from evidence map: #{missing_in_evidence.join(', ')}" unless missing_in_evidence.empty?
end

# Check 9: Reference index
checks << "reference index"
check("#{checks.length} reference index", errors) do
  data = load_yaml("skills/hipaa-assessor/references/index.yaml")
  require_schema_v1(data, "reference index")
  raise "missing read_order" unless data["read_order"].is_a?(Array)
  raise "missing references" unless data["references"].is_a?(Array)

  required_hierarchy_ids = %w[cfr_text ocr_guidance repo_interpretation target_system_evidence]
  hierarchy_ids = data["source_hierarchy"].map { |entry| entry["id"] }
  missing_hierarchy_ids = required_hierarchy_ids - hierarchy_ids
  raise "missing source_hierarchy IDs: #{missing_hierarchy_ids.join(', ')}" unless missing_hierarchy_ids.empty?

  required_reference_paths = %w[
    core/applicability/triage-output-template.yaml
    core/checklists/assessment-rubric.yaml
    core/checklists/evidence-map.yaml
    docs/assessment-output-template.md
    docs/example-assessment.md
    docs/example-assessment-ba.md
    docs/example-assessment-entity-tbd.md
  ]
  reference_paths = data["references"].map { |ref| ref["path"] }
  missing_reference_paths = required_reference_paths - reference_paths
  raise "missing reference paths: #{missing_reference_paths.join(', ')}" unless missing_reference_paths.empty?

  data["references"].each do |ref|
    %w[path role].each do |key|
      raise "reference missing #{key}" unless ref[key]
    end
    raise "reference file missing: #{ref['path']}" unless File.exist?(File.join(ROOT, ref["path"]))
  end
end

# Check 10: Operator surface alignment
checks << "operator surface alignment"
check("#{checks.length} operator surface alignment", errors) do
  ensure_includes("docs/skill-install-and-use.md", [
    "HIPAA_FOUNDATION_ROOT",
    '${XDG_CONFIG_HOME:-$HOME/.config}/hipaa-assessor/config',
    '$HOME/github/hipaa-foundation'
  ])
  ensure_includes("README.md", [
    "docs/skill-install-and-use.md"
  ])
  ensure_includes("AGENTS.md", [
    "docs/skill-install-and-use.md"
  ])
  ensure_includes("CLAUDE.md", [
    "docs/skill-install-and-use.md"
  ])
  ensure_includes("skills/SKILL.md", ["skills/hipaa-assessor/SKILL.md"])
  ensure_includes("skills/codex/SKILL.md", ["../hipaa-assessor/SKILL.md"])
  ensure_includes("skills/claude-code/SKILL.md", ["../hipaa-assessor/SKILL.md"])
  ensure_includes("skills/hipaa-assessor/START-HERE.md", [
    "references/index.yaml"
  ])
  ensure_includes("docs/manual-acceptance-harness.md", [
    "test/fixtures/minimal-target",
    "test/fixtures/rich-target"
  ])
end

# Check 11: Schema version consistency
checks << "schema version consistency"
check("#{checks.length} schema version consistency", errors) do
  yaml_files = Dir.glob(File.join(ROOT, "core/**/*.yaml")) +
               Dir.glob(File.join(ROOT, "skills/hipaa-assessor/references/*.yaml"))
  yaml_files.each do |file|
    data = YAML.safe_load(File.read(file))
    next unless data.is_a?(Hash) && data.key?("schema_version")
    rel = relative_path(file)
    raise "#{rel} has non-v1 schema_version: #{data['schema_version']}" unless data["schema_version"] == "v1"
  end
end

# Check 12: Source manifest
checks << "source manifest"
check("#{checks.length} source manifest", errors) do
  data = load_yaml("core/provenance/source-manifest.yaml")
  require_schema_v1(data, "source-manifest")
  raise "missing primary_sources" unless data["primary_sources"].is_a?(Array)
  raise "missing reference_sources" unless data["reference_sources"].is_a?(Array)
  raise "missing pending_changes" unless data["pending_changes"].is_a?(Array)

  (data["primary_sources"] + data["reference_sources"]).each do |source|
    %w[id title authority url type status source_role last_verified_on refresh_cadence].each do |key|
      raise "source #{source['id'] || source.inspect} missing #{key}" unless source[key]
    end
  end

  source_ids = data["primary_sources"].map { |s| s["id"] }
  %w[ecfr-part-160 ecfr-part-162 ecfr-part-164].each do |required_id|
    raise "missing #{required_id}" unless source_ids.include?(required_id)
  end

  pending_ids = data["pending_changes"].map { |s| s["id"] }
  raise "missing security-rule-nprm in pending" unless pending_ids.include?("security-rule-nprm")
end

# Check 13: Node inventory and regulation files
checks << "node inventory and regulation files"
check("#{checks.length} node inventory and regulation files", errors) do
  data = load_yaml("core/index/node-inventory.yaml")
  require_schema_v1(data, "node-inventory")
  raise "missing nodes" unless data["nodes"].is_a?(Array)
  raise "nodes must not be empty" if data["nodes"].empty?

  # Forward check: every inventory entry has a file
  data["nodes"].each do |node|
    %w[regulation_id title file].each do |key|
      raise "node missing #{key}" unless node[key]
    end
    raise "node file missing: #{node['file']}" unless File.exist?(File.join(ROOT, node["file"]))
  end

  # Reverse check: every regulation file is in the inventory
  inventory_files = data["nodes"].map { |n| n["file"] }
  Dir.glob(File.join(ROOT, "core/regulations/*.yaml")).each do |file|
    rel = relative_path(file)
    raise "regulation file #{rel} not in node inventory" unless inventory_files.include?(rel)
  end

  inventory_ids = data["nodes"].map { |n| n["regulation_id"] }
  %w[164.501 164.308(b)(2) 164.308(b)(3) 164.314(a)(2)(iii)].each do |required_id|
    raise "missing #{required_id} in node inventory" unless inventory_ids.include?(required_id)
  end
end

# Check 14: Regulation file schema
checks << "regulation file schema"
check("#{checks.length} regulation file schema", errors) do
  Dir.glob(File.join(ROOT, "core/regulations/*.yaml")).each do |file|
    rel = relative_path(file)
    data = load_yaml(rel)
    require_schema_v1(data, rel)
    %w[regulation_id title rule_family status].each do |key|
      raise "#{rel} missing #{key}" unless data[key]
    end
    raise "#{rel} missing authoritative_text" unless data["authoritative_text"].is_a?(String) && !data["authoritative_text"].strip.empty?
    raise "#{rel} missing source_reference" unless data["source_reference"].is_a?(Hash)
    raise "#{rel} missing source_reference.edition_date" if data.dig("source_reference", "edition_date").to_s.strip.empty?
    raise "#{rel} missing source_reference.retrieved_on" if data.dig("source_reference", "retrieved_on").to_s.strip.empty?

    markers = ["[Verify", "TODO", "FIXME", "[See"]
    if markers.any? { |marker| data["authoritative_text"].include?(marker) }
      raise "#{rel} contains placeholder or editorial marker in authoritative_text"
    end

    # Security Rule implementation specs must have implementation_type
    next unless data["standard_or_spec"] == "implementation_specification" && data["rule_family"] == "security_rule"
    raise "#{rel} missing implementation_type for Security Rule impl spec" unless data["implementation_type"]
    unless %w[required addressable].include?(data["implementation_type"])
      raise "#{rel} invalid implementation_type: #{data['implementation_type']}"
    end
  end
end

# Check 15: Guidance files
checks << "guidance files"
check("#{checks.length} guidance files", errors) do
  guidance_dir = File.join(ROOT, "core/guidance")
  raise "missing core/guidance directory" unless File.directory?(guidance_dir)
  guidance_files = Dir.glob(File.join(guidance_dir, "*.yaml"))
  raise "no guidance files found" if guidance_files.empty?
  guidance_files.each do |file|
    rel = relative_path(file)
    data = load_yaml(rel)
    require_schema_v1(data, rel)
  end
end

# Check 16: Domain regulation_files existence
checks << "domain regulation_files existence"
check("#{checks.length} domain regulation_files existence", errors) do
  inventory = load_yaml("core/index/domain-inventory.yaml")
  inventory["domains"].each do |domain|
    domain_data = load_yaml(domain["file"])
    domain_id = domain["id"]

    raise "#{domain_id} missing regulation_ids" unless domain_data["regulation_ids"].is_a?(Array)
    raise "#{domain_id} missing regulation_files" unless domain_data["regulation_files"].is_a?(Hash)

    all_files = Array(domain_data.dig("regulation_files", "standards")) +
                Array(domain_data.dig("regulation_files", "implementation_specifications"))

    all_files.each do |reg_file|
      raise "#{domain_id}: regulation file missing on disk: #{reg_file}" unless File.exist?(File.join(ROOT, reg_file))
    end
  end
end

# Check 17: Domain regulation_files rule_family consistency
checks << "domain regulation_files rule_family consistency"
check("#{checks.length} domain regulation_files rule_family", errors) do
  allowed_families = {
    "risk-analysis-and-management" => %w[security_rule],
    "administrative-safeguards" => %w[security_rule],
    "physical-safeguards" => %w[security_rule],
    "technical-safeguards" => %w[security_rule],
    "organizational-requirements" => %w[security_rule],
    "privacy-uses-and-disclosures" => %w[privacy_rule],
    "minimum-necessary" => %w[privacy_rule],
    "individual-rights" => %w[privacy_rule],
    "breach-notification" => %w[breach_notification_rule],
    "policies-procedures-documentation" => %w[security_rule privacy_rule],
    "training-and-sanctions" => %w[security_rule privacy_rule],
    "entity-and-applicability" => %w[security_rule privacy_rule breach_notification_rule general],
  }

  inventory = load_yaml("core/index/domain-inventory.yaml")
  inventory["domains"].each do |domain|
    domain_data = load_yaml(domain["file"])
    domain_id = domain["id"]
    families = allowed_families[domain_id]
    next unless families

    all_files = Array(domain_data.dig("regulation_files", "standards")) +
                Array(domain_data.dig("regulation_files", "implementation_specifications"))

    all_files.each do |reg_file|
      reg_data = load_yaml(reg_file)
      unless families.include?(reg_data["rule_family"])
        raise "#{domain_id}: #{reg_file} has rule_family '#{reg_data['rule_family']}', expected one of #{families}"
      end
    end
  end
end

# Check 18: Domain regulation_files completeness (bidirectional)
checks << "domain regulation_files completeness"
check("#{checks.length} domain regulation_files completeness", errors) do
  inventory = load_yaml("core/index/domain-inventory.yaml")
  inventory["domains"].each do |domain|
    domain_data = load_yaml(domain["file"])
    domain_id = domain["id"]
    declared_ids = domain_data["regulation_ids"] || []

    all_files = Array(domain_data.dig("regulation_files", "standards")) +
                Array(domain_data.dig("regulation_files", "implementation_specifications"))

    # Forward: every regulation_id has a file
    file_reg_ids = all_files.map { |f| load_yaml(f)["regulation_id"] }
    declared_ids.each do |rid|
      unless file_reg_ids.include?(rid)
        raise "#{domain_id}: regulation_id '#{rid}' declared but no matching file in regulation_files"
      end
    end

    # Reverse: every file's regulation_id is declared
    file_reg_ids.each do |frid|
      unless declared_ids.include?(frid)
        raise "#{domain_id}: file has regulation_id '#{frid}' but it is not in regulation_ids"
      end
    end
  end

  privacy_domain = load_yaml("core/domains/privacy-uses-and-disclosures.yaml")
  rights_domain = load_yaml("core/domains/individual-rights.yaml")
  raise "privacy-uses-and-disclosures missing 164.501" unless privacy_domain["regulation_ids"].include?("164.501")
  raise "individual-rights missing 164.501" unless rights_domain["regulation_ids"].include?("164.501")
end

# Check 19: Domain files must not contain rating_guidance
checks << "no rating_guidance in domain files"
check("#{checks.length} no rating_guidance in domain files", errors) do
  inventory = load_yaml("core/index/domain-inventory.yaml")
  inventory["domains"].each do |domain|
    domain_data = load_yaml(domain["file"])
    if domain_data.key?("rating_guidance")
      raise "#{domain['id']}: rating_guidance is not allowed in domain files. Use assessment_guidance instead."
    end
  end
end

puts "=" * 40
if errors.empty?
  puts "ALL #{checks.length}/#{checks.length} CHECKS PASSED"
  exit PASS
else
  puts "FAILED: #{errors.length} of #{checks.length} check(s)"
  errors.each { |e| puts "  - #{e}" }
  exit FAIL
end
