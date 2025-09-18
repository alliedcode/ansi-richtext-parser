# Changelog

## 0.0.3

### Breaking Changes

* Removed legacy `parse()` method - use `parseSafe()` or `parseStrict()` instead

### Improvements

* Clean API with no deprecated methods
* All deprecation warnings eliminated
* Simplified codebase by removing legacy compatibility code

## 0.0.2

### Major Improvements

* **Dual Parse Methods**: Added `parseSafe()` and `parseStrict()` methods with clear error handling strategies
  * `parseSafe()`: Returns `null` on errors, never throws exceptions - perfect for graceful error handling
  * `parseStrict()`: Throws detailed exceptions on errors - perfect for explicit error handling

* **Type Safety Enhancements**:
  * Added sealed token classes (`ParserToken`, `TextToken`, `ColorToken`) for compile-time type checking
  * Enhanced `AnsiColor` class with factory constructors and validation
  * Improved parser with better type inference throughout

* **Robust Error Handling**:
  * Created structured error types (`ParsingError`, `UnexpectedTokenError`, `ParseFailureError`)
  * Replaced string-based error throwing with proper exception types
  * Added detailed error information including input and position

* **Factory Constructors**:
  * `AnsiColor.basic()`: For standard ANSI colors with validation
  * `AnsiColor.extended()`: For 256-color palette with validation
  * `AnsiColor.reset()`: For reset color codes
  * Added helper properties: `isReset`, `hasForeground`, `hasBackground`

* **Documentation & Testing**:
  * Comprehensive README with usage examples for both parse methods
  * Complete test coverage for all new functionality (23 tests total)
  * Clean API with no deprecated methods

### Breaking Changes

* Removed legacy `parse()` method - use `parseSafe()` or `parseStrict()` instead

## 0.0.1

* Initial release with basic ANSI color parsing functionality
