.PHONY: help test test-basic test-advanced fmt validate clean install

# Default target
help:
	@echo "Terraform Module - Entitlement Management"
	@echo ""
	@echo "Available targets:"
	@echo "  help          - Show this help message"
	@echo "  install       - Install Terraform (if not already installed)"
	@echo "  test          - Run all Terraform tests (basic and advanced examples)"
	@echo "  test-basic    - Run tests for the basic example"
	@echo "  test-advanced - Run tests for the advanced example"
	@echo "  fmt           - Format all Terraform files"
	@echo "  validate      - Validate Terraform configuration"
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
	@echo "All tests completed successfully!"

# Run tests for the basic example
test-basic:
	@echo "Running tests for basic example..."
	@cd tests && terraform test -filter=basic.tftest.hcl

# Run tests for the advanced example  
test-advanced:
	@echo "Running tests for advanced example..."
	@cd tests && terraform test -filter=advanced.tftest.hcl

# Format all Terraform files
fmt:
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive

# Validate Terraform configuration
validate:
	@echo "Validating root module..."
	@terraform init -backend=false
	@terraform validate
	@echo "Validating basic example..."
	@cd examples/basic && terraform init -backend=false && terraform validate
	@echo "Validating advanced example..."
	@cd examples/advanced && terraform init -backend=false && terraform validate

# Clean up test artifacts
clean:
	@echo "Cleaning up test artifacts..."
	@find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	@find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@find . -type f -name "terraform.tfstate*" -delete 2>/dev/null || true
	@echo "Cleanup complete!"
