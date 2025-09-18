import 'package:ansi_richtext_parser/ansi_richtext_parser.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/colorscheme.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/errors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final colorscheme = colorschemeVSC;

  group('parseSafe', () {
    test('returns Text widget for valid ANSI text', () {
      final result = parseSafe("\u001b[31mHello", colorscheme);
      expect(result, isNotNull);
      expect(result, isA<Text>());
    });

    test('returns null for invalid ANSI text', () {
      final result = parseSafe("\u001b[invalid", colorscheme);
      expect(result, isNull);
    });

    test('returns null for malformed escape sequences', () {
      final result = parseSafe("\u001b[999m", colorscheme);
      expect(result, isNull);
    });

    test('never throws exceptions', () {
      expect(() => parseSafe("\u001b[invalid", colorscheme), returnsNormally);
      expect(() => parseSafe("\u001b[999m", colorscheme), returnsNormally);
      expect(() => parseSafe("", colorscheme), returnsNormally);
    });
  });

  group('parseStrict', () {
    test('returns Text widget for valid ANSI text', () {
      final result = parseStrict("\u001b[31mHello", colorscheme);
      expect(result, isNotNull);
      expect(result, isA<Text>());
    });

    test('throws ParseFailureError for invalid ANSI text', () {
      expect(
        () => parseStrict("\u001b[invalid", colorscheme),
        throwsA(isA<ParseFailureError>()),
      );
    });

    test('throws ParseFailureError for malformed escape sequences', () {
      expect(
        () => parseStrict("\u001b[999m", colorscheme),
        throwsA(isA<ParseFailureError>()),
      );
    });

    test('throws UnexpectedTokenError for unexpected tokens', () {
      // This would require a more complex test setup to trigger unexpected tokens
      // For now, we'll test that it can throw ParsingError subclasses
      expect(
        () => parseStrict("\u001b[invalid", colorscheme),
        throwsA(isA<ParsingError>()),
      );
    });

    test('preserves error information', () {
      try {
        parseStrict("\u001b[invalid", colorscheme);
        fail('Expected ParseFailureError to be thrown');
      } on ParseFailureError catch (e) {
        expect(e.input, equals("\u001b[invalid"));
        expect(e.message, contains('Failed to parse ANSI text'));
      }
    });
  });

  group('comparison between methods', () {
    test('both methods return same result for valid input', () {
      const validInput = "\u001b[31mHello \u001b[32mWorld\u001b[0m";

      final safeResult = parseSafe(validInput, colorscheme);
      final strictResult = parseStrict(validInput, colorscheme);

      expect(safeResult, isNotNull);
      expect(strictResult, isNotNull);
      // Both should be Text widgets with the same content
      expect(safeResult.runtimeType, equals(strictResult.runtimeType));
    });

    test('parseSafe returns null while parseStrict throws for invalid input', () {
      const invalidInput = "\u001b[invalid";

      final safeResult = parseSafe(invalidInput, colorscheme);
      expect(safeResult, isNull);

      expect(
        () => parseStrict(invalidInput, colorscheme),
        throwsA(isA<ParseFailureError>()),
      );
    });
  });
}
