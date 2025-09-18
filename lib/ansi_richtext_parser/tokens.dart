import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';

/// Base class for all parser tokens
abstract class ParserToken {
  const ParserToken();
}

/// Represents a text token from the parser
class TextToken extends ParserToken {
  final String text;

  const TextToken(this.text);

  @override
  String toString() => 'TextToken("$text")';

  @override
  bool operator ==(Object other) => identical(this, other) || other is TextToken && text == other.text;

  @override
  int get hashCode => text.hashCode;
}

/// Represents an ANSI color token from the parser
class ColorToken extends ParserToken {
  final AnsiColor color;

  const ColorToken(this.color);

  @override
  String toString() => 'ColorToken($color)';

  @override
  bool operator ==(Object other) => identical(this, other) || other is ColorToken && color == other.color;

  @override
  int get hashCode => color.hashCode;
}
