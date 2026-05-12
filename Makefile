.PHONY: help test test-basic test-advanced fmt validate clean install

# Default target
help:
	@echo "Terraform Module - Entitlement Management"
	@echo ""
	@echo "Available targets:"
	@echo "  help          - Show this help message"
	@echo "  install       - Install Terraform (if not already installed)"
	@echo "  test          - Run all Terraform tests (validate all examples)"
	@echo "  test-basic    - Validate the basic example"
	@echo "  test-advanced - Validate the advanced example"
	@echo "  fmt           - Format all Terraform files"
	@echo "  validate      - Validate all Terraform configurations"
	@echo "  clean         - Clean up test artifacts"
	@echo ""

# Install Terraform if needed
install:
	@which terraform > /dev/null || (echo "Installing Terraform..." && \
		wget -q https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip && \
		unzip -q terraform_1.7.0_linux_amd64.zip && \
		sudo mv terraform /usr/local/bin/ && \
		rm terraform_1.7.0_linux_amd64.zip)
	@terraform version

# Run all tests
test: test-basic test-advanced
	@echo "✅ All tests completed successfully!"

# Validate the basic example
test-basic:
	@echo "Validating basic example..."
	@cd examples/basic && terraform init -backend=false > /dev/null && terraform validate
	@echo "✅ Basic example validation passed!"

# Validate the advanced example  
test-advanced:
	@echo "Validating advanced example..."
	@cd examples/advanced && terraform init -backend=false > /dev/null && terraform validate
	@echo "✅ Advanced example validation passed!"

# Format all Terraform files
fmt:
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive

# Validate all Terraform configurations
validate:
	@echo "Validating root module..."
	@terraform init -backend=false > /dev/null
	@terraform validate
	@echo "✅ Root module validation passed!"
	@$(MAKE) test-basic
	@$(MAKE) test-advanced

# Clean up test artifacts
clean:
	@echo "Cleaning up test artifacts..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find . -type f -name "terraform.tfstate*" -delete 2>/dev/null || true
	@echo "✅ Cleanup complete!"

