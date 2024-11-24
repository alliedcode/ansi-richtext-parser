import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';
import 'package:petitparser/petitparser.dart';

class AnsiParser extends GrammarDefinition {
  @override
  Parser start() => ref0(elem).plus();

  Parser elem() => ref0(color) | ref0(text);

  Parser color() => ref0(ansiColor).skip(before: escape(), after: char('m'));

  Parser escape() => string('\x1B[');
  Parser notEscape() => escape().not() & any();
  Parser text() => ref0(notEscape).plus().flatten();

  Parser ansiColor() => (ref0(extendedAnsiColor) | ref0(basicAnsiColor) | ref0(resetAnsiColor));

  /// Parses basic ANSI colors (30-37 or 90-97 foreground, 40-47 or 100-107 background).
  Parser basicAnsiColor() => (fgColor() & bgColor().optional()).map((a) => AnsiColor(fgColor: a[0], bgColor: a[1], isFgExtended: false, isBgExtended: false));

  /// Parses extended ANSI colors (38;5;<n> foreground, 48;5;<n> background).
  Parser extendedAnsiColor() =>
      (fgExtendedColor().skip(after: char(';')) & bgExtendedColor())
          .map((a) => AnsiColor(fgColor: a[0], bgColor: a[1], isFgExtended: true, isBgExtended: true)) |
      fgExtendedColor().map((value) => AnsiColor(fgColor: value, isFgExtended: true)) |
      bgExtendedColor().map((value) => AnsiColor(bgColor: value, isBgExtended: true));

  Parser resetAnsiColor() => string('0').map((_) => AnsiColor(fgColor: 0));

  Parser fgExtendedColor() => ref0(integer).skip(before: string('38;5;'));
  Parser bgExtendedColor() => ref0(integer).skip(before: string('48;5;'));

  Parser fgColor() => ref0(integer).where((value) => value >= 30 && value <= 37 || value >= 90 && value <= 97);
  Parser bgColor() => ref0(integer).skip(before: char(';')).where((value) => value >= 40 && value <= 47 || value >= 100 && value <= 107);

  Parser integer() => digit().plus().flatten().map(int.parse);
}
