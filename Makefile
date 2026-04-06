validate:
	ruby scripts/validate.rb

smoke:
	./scripts/smoke-test-resolver.sh
	./scripts/smoke-test-install.sh
