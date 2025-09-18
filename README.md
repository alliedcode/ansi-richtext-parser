# ANSI Rich Text Parser

[![Tests](https://github.com/nilscc/ansi-richtext-parser/workflows/Flutter%20Tests/badge.svg)](https://github.com/nilscc/ansi-richtext-parser/actions)
[![Pub](https://img.shields.io/pub/v/ansi_richtext_parser.svg)](https://pub.dev/packages/ansi_richtext_parser)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A type-safe Flutter package for parsing [ANSI escape codes] and rendering them as styled [Flutter Text] widgets with full support for foreground and background colors.

[ANSI escape codes]: https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit
[Flutter Text]: https://api.flutter.dev/flutter/widgets/Text/Text.rich.html

## Features

✨ **Type-Safe Parsing** - Compile-time type checking with sealed token classes

🎨 **Full ANSI Color Support** - Basic (8/16 colors) and extended (256 colors)

🏗️ **Factory Constructors** - Validated color creation with descriptive errors

🛡️ **Dual Error Handling** - Choose between graceful (`parseSafe`) or strict (`parseStrict`) error handling

⚡ **High Performance** - Efficient parsing with minimal allocations

📱 **Flutter Ready** - Direct integration with Flutter's Text widgets

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ansi_richtext_parser: ^0.0.3
```

## Usage

### Basic Usage

The package provides two parsing methods with different error handling strategies:

#### Safe Parsing (Recommended for most use cases)

```dart
import 'package:ansi_richtext_parser/ansi_richtext_parser.dart';

// Parse ANSI text with graceful error handling
final ansiText = "\u001b[96mHello \u001b[36mWorld\u001b[0m!";
final textWidget = parseSafe(ansiText, colorschemeVSC);

// Use in your Flutter widget - null-safe approach
Widget build(BuildContext context) {
  return Column(
    children: [
      Text("Plain text"),
      textWidget ?? Text("Failed to parse ANSI text"),
    ],
  );
}
```

#### Strict Parsing (For explicit error handling)

```dart
import 'package:ansi_richtext_parser/ansi_richtext_parser.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/errors.dart';

// Parse ANSI text with explicit error handling
try {
  final textWidget = parseStrict(ansiText, colorschemeVSC);
  return textWidget;
} on ParseFailureError catch (e) {
  // Handle parsing failures with detailed error information
  return Text("Parse error: ${e.message}");
} on UnexpectedTokenError catch (e) {
  // Handle unexpected tokens
  return Text("Unexpected token: ${e.token}");
}
```

### Supported ANSI Sequences

```dart
// Basic foreground colors (30-37, 90-97)
"\u001b[30m"  // Black
"\u001b[31m"  // Red
"\u001b[96m"  // Bright Cyan

// Basic background colors (40-47, 100-107)
"\u001b[40m"  // Black background
"\u001b[41m"  // Red background
"\u001b[106m" // Bright Yellow background

// Combined foreground and background
"\u001b[30;41m" // Black text on red background

// Extended colors (256-color palette)
"\u001b[38;5;196m" // Extended red foreground
"\u001b[48;5;46m"  // Extended green background
"\u001b[38;5;123;48;5;210m" // Combined extended colors

// Reset all colors
"\u001b[0m"
```

### Available Color Schemes

The package includes 11 predefined color schemes based on popular terminals:

```dart
// Choose from these predefined schemes:
colorschemeVGA                    // Classic VGA colors
colorschemeWindowsXPConsole      // Windows XP Console
colorschemeWindowsPowerShell     // Windows PowerShell 1.0–6.0
colorschemeVSC                   // Visual Studio Code (default)
colorschemeWindows10Console      // Windows 10 Console
colorschemeTerminalApp           // Terminal.app
colorschemePuTTY                 // PuTTY
colorschememIRC                  // mIRC
colorschemexterm                 // xterm
colorschemeUbuntu                // Ubuntu
colorschemeEclipseTerminal       // Eclipse Terminal

// Example with different color scheme
final textWidget = parse(ansiText, colorschemeUbuntu);
```

### Type-Safe Color Creation

For advanced use cases, you can create `AnsiColor` objects with full type safety:

```dart
import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';

// Factory constructors with validation
final basicColor = AnsiColor.basic(fgColor: 31, bgColor: 40);
final extendedColor = AnsiColor.extended(fgColor: 196, bgColor: 46);
final resetColor = AnsiColor.reset();

// Helper properties
if (basicColor.hasForeground) {
  print("Has foreground color");
}
if (basicColor.hasBackground) {
  print("Has background color");
}
if (resetColor.isReset) {
  print("This is a reset color");
}
```

### Advanced Usage with Custom Parsing

```dart
import 'package:ansi_richtext_parser/ansi_richtext_parser/parser.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/tokens.dart';

// Parse to tokens for custom processing
final parser = AnsiParser().build();
final result = parser.parse("\u001b[96mHello \u001b[36mWorld");

if (result is Success) {
  final tokens = result.value;
  for (final token in tokens) {
    switch (token) {
      case TextToken(:final text):
        print("Text: $text");
      case ColorToken(:final color):
        print("Color: $color");
    }
  }
}
```

### Error Handling

#### With parseSafe() - Graceful Error Handling

```dart
// parseSafe() never throws - always returns null on errors
final result = parseSafe(ansiText, colorschemeVSC);
if (result != null) {
  // Success - use the widget
  return result;
} else {
  // Parsing failed - handle gracefully
  return Text("Failed to parse ANSI text");
}
```

#### With parseStrict() - Explicit Error Handling

```dart
import 'package:ansi_richtext_parser/ansi_richtext_parser/errors.dart';

try {
  final textWidget = parseStrict(ansiText, colorschemeVSC);
  return textWidget;
} on ParseFailureError catch (e) {
  // Detailed error information available
  print("Parse failed: ${e.message}");
  print("Input: ${e.input}");
  print("Position: ${e.position}");
  return Text("Parse error at position ${e.position}");
} on UnexpectedTokenError catch (e) {
  print("Unexpected token: ${e.token}");
  print("Expected: ${e.expectedType}");
  return Text("Unexpected token: ${e.token}");
} catch (e) {
  // Handle any other unexpected errors
  return Text("Unexpected error: $e");
}
```

#### Choosing the Right Method

- **Use `parseSafe()`** when you want simple, graceful error handling
- **Use `parseStrict()`** when you need detailed error information or want to handle specific error types differently

## Type Safety Features

This package provides comprehensive type safety through:

- **Sealed Token Classes**: `ParserToken`, `TextToken`, `ColorToken`
- **Factory Constructors**: Validated `AnsiColor` creation
- **Structured Errors**: Proper error types instead of exceptions
- **Compile-time Checking**: Catch errors during development

## Performance

- Efficient parsing with minimal string allocations
- Optimized color scheme lookups
- Lazy evaluation of color calculations
- Memory-efficient token representation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.
# Test comment
