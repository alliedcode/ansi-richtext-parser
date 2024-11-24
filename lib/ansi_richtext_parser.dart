library ansi_richtext_parser;

import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/colorscheme.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/parser.dart';
import 'package:flutter/widgets.dart';
import 'package:petitparser/core.dart';

_buildRichText(AnsiColorscheme colorscheme) => ((TextStyle?, List<InlineSpan>) previous, current) => switch ((current, previous)) {
      // Case: Reset (foreground and background cleared)
      (AnsiColor(fgColor: 0, bgColor: null), (_, List<InlineSpan> list)) => (null, list),

      // Case: AnsiColor is present; retrieve the style
      (AnsiColor ansiColor, (_, List<InlineSpan> list)) => (colorscheme.textStyle(ansiColor), list),

      // Case: Text string; apply the current TextStyle
      (String text, (TextStyle? ts, List<InlineSpan> list)) => (ts, list..add(TextSpan(text: text, style: ts))),

      // Fallback case: Unexpected token
      var token => throw ("Unexpected values: $token"),
    };

Text? parse(String ansi, AnsiColorscheme colorscheme) {
  final parser = AnsiParser().build<List>();
  final result = parser.parse(ansi);

  if (result is Failure) {
    return null;
  }

  return switch (result.value) {
    [String text] => Text(text),
    _ => Text.rich(TextSpan(
        children: result.value.fold((null as TextStyle?, <InlineSpan>[]), _buildRichText(colorscheme)).$2,
      )),
  };
}
