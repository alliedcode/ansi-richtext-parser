import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/tokens.dart';
import 'package:petitparser/petitparser.dart';

/// Type-safe ANSI parser that returns ParserToken objects
class AnsiParser extends GrammarDefinition {
  @override
  Parser start() => ref0(elem).plus();

  Parser elem() => ref0(color) | ref0(text);

  Parser color() => ref0(ansiColor).skip(before: escape(), after: char('m')).map((color) => ColorToken(color));

  Parser escape() => string('\x1B[');
  Parser notEscape() => escape().not() & any();
  Parser text() => ref0(notEscape).plus().flatten().map((text) => TextToken(text));

  Parser ansiColor() => ref0(extendedAnsiColor) | ref0(basicAnsiColor) | ref0(resetAnsiColor);

  /// Parses basic ANSI colors (30-37 or 90-97 foreground, 40-47 or 100-107 background).
  Parser basicAnsiColor() => (fgColor() & bgColor().optional()).map((a) => AnsiColor.basic(fgColor: a[0], bgColor: a[1]));

  /// Parses extended ANSI colors (38;5;<n> foreground, 48;5;<n> background).
  Parser extendedAnsiColor() =>
      (fgExtendedColor().skip(after: char(';')) & bgExtendedColor()).map((a) => AnsiColor.extended(fgColor: a[0], bgColor: a[1])) |
      fgExtendedColor().map((value) => AnsiColor.extended(fgColor: value)) |
      bgExtendedColor().map((value) => AnsiColor.extended(bgColor: value));

  Parser resetAnsiColor() => string('0').map((_) => AnsiColor.reset());

  Parser fgExtendedColor() => ref0(integer).skip(before: string('38;5;'));
  Parser bgExtendedColor() => ref0(integer).skip(before: string('48;5;'));

  Parser fgColor() => ref0(integer).where((value) => (value >= 30 && value <= 37) || (value >= 90 && value <= 97));

  Parser bgColor() => ref0(integer).skip(before: char(';')).where((value) => (value >= 40 && value <= 47) || (value >= 100 && value <= 107));

  Parser integer() => digit().plus().flatten().map(int.parse);
}
