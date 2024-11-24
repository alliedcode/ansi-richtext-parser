import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';
import 'package:petitparser/petitparser.dart';

class AnsiParser extends GrammarDefinition {
  @override
  Parser start() => ref0(elem).plus();

  Parser elem() => ref0(color) | ref0(text);

  Parser color() => (ref0(extendedColor) | ref0(basicColor) | ref0(reset))
      .skip(before: escape(), after: char('m'))
      .map((values) => AnsiColor(fgColor: values[0], bgColor: values.length > 1 ? values[1] : null));

  Parser escape() => string('\x1B[');

  /// Parses basic ANSI colors (30-37 or 90-97 foreground, 40-47 or 100-107 background).
  Parser basicColor() => (fgColor() & bgColor().optional()).map((values) => [values[0], values[1]]);

  /// Parses extended ANSI colors (38;5;<n> foreground, 48;5;<n> background).
  Parser extendedColor() =>
      (fgExtendedColor().skip(after: char(';')) & bgExtendedColor()) |
      fgExtendedColor().map((value) => [value]) |
      bgExtendedColor().map((value) => [null, value]);

  Parser reset() => string('0').map((_) => [0]);

  Parser fgExtendedColor() => ref0(integer).skip(before: string('38;5;'));
  Parser bgExtendedColor() => ref0(integer).skip(before: string('48;5;'));

  Parser fgColor() => ref0(integer).where((value) => value >= 30 && value <= 37 || value >= 90 && value <= 97);
  Parser bgColor() => ref0(integer).skip(before: char(';')).where((value) => value >= 40 && value <= 47 || value >= 100 && value <= 107);

  Parser integer() => digit().plus().flatten().map(int.parse);

  Parser notEscape() => escape().not() & any();
  Parser text() => ref0(notEscape).plus().flatten();
}
