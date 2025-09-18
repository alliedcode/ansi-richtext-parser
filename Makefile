.PHONY: format format-check analyze test ci clean help

# Format all Dart files
format:
	@echo "Formatting Dart files..."
	dart format .

# Check if files are properly formatted (used in CI)
format-check:
	@echo "Checking Dart formatting..."
	dart format --output=none --set-exit-if-changed .

# Run static analysis
analyze:
	@echo "Running static analysis..."
	dart analyze

# Run tests
test:
	@echo "Running tests..."
	flutter test

# Run all CI checks (format, analyze, test)
ci: format-check analyze test
	@echo "✅ All CI checks passed!"

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	flutter clean
	dart pub get

# Show help
help:
	@echo "Available commands:"
	@echo "  format       - Format all Dart files"
	@echo "  format-check - Check if files are properly formatted"
	@echo "  analyze      - Run static analysis"
	@echo "  test         - Run tests"
	@echo "  ci           - Run all CI checks (format-check, analyze, test)"
	@echo "  clean        - Clean build artifacts and reinstall dependencies"
	@echo "  help         - Show this help message"
