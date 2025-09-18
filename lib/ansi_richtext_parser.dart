library ansi_richtext_parser;

import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/colorscheme.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/parser.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/tokens.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/errors.dart';
import 'package:flutter/widgets.dart';
import 'package:petitparser/core.dart';

/// Type-safe function to build rich text from parser tokens
(TextStyle?, List<InlineSpan>) _buildRichTextFromTokens(
  AnsiColorscheme colorscheme,
  (TextStyle?, List<InlineSpan>) previous,
  ParserToken current,
) =>
    switch ((current, previous)) {
      // Case: Reset color token
      (ColorToken(color: AnsiColor(fgColor: 0)), (_, List<InlineSpan> list)) =>
        (null, list),

      // Case: Color token - apply the style
      (ColorToken(color: final ansiColor), (_, List<InlineSpan> list)) => (
          colorscheme.textStyle(ansiColor),
          list
        ),

      // Case: Text token - apply the current TextStyle
      (TextToken(text: final text), (TextStyle? ts, List<InlineSpan> list)) => (
          ts,
          list..add(TextSpan(text: text, style: ts))
        ),

      // Fallback case: Unexpected token
      (final token, _) => throw UnexpectedTokenError(
          token,
          'ColorToken or TextToken',
        ),
    };

/// Parses ANSI escape sequences into a Flutter Text widget with graceful error handling.
///
/// Returns null if parsing fails, otherwise returns a Text widget with appropriate styling.
/// This method never throws exceptions - all errors are handled gracefully by returning null.
///
/// Use this method when you want to handle parsing failures gracefully without exception handling.
///
/// Example:
/// ```dart
/// final result = parseSafe(ansiText, colorscheme);
/// if (result != null) {
///   return result;
/// } else {
///   return Text("Failed to parse ANSI text");
/// }
/// ```
Text? parseSafe(String ansi, AnsiColorscheme colorscheme) {
  try {
    final parser = AnsiParser().build();
    final result = parser.parse(ansi);

    if (result is Failure) {
      return null;
    }

    final tokens = result.value;

    // Handle simple case with just one text token
    if (tokens.length == 1 && tokens.first is TextToken) {
      return Text((tokens.first as TextToken).text);
    }

    // Handle complex case with multiple tokens
    final (_, spans) = tokens.fold<(TextStyle?, List<InlineSpan>)>(
      (null, <InlineSpan>[]),
      (acc, token) => _buildRichTextFromTokens(colorscheme, acc, token),
    );

    return Text.rich(TextSpan(children: spans));
  } catch (e) {
    // Always return null on any error for graceful degradation
    return null;
  }
}

/// Parses ANSI escape sequences into a Flutter Text widget with strict error handling.
///
/// Returns a Text widget with appropriate styling, or throws an exception if parsing fails.
/// This method preserves all error information by throwing exceptions.
///
/// Use this method when you want to handle errors explicitly with try-catch blocks.
///
/// Example:
/// ```dart
/// try {
///   final result = parseStrict(ansiText, colorscheme);
///   return result;
/// } on ParsingError catch (e) {
///   // Handle parsing errors
///   return Text("Parse error: ${e.message}");
/// }
/// ```
Text parseStrict(String ansi, AnsiColorscheme colorscheme) {
  final parser = AnsiParser().build();
  final result = parser.parse(ansi);

  if (result is Failure) {
    throw ParseFailureError(
      'Failed to parse ANSI text: ${result.message}',
      input: ansi,
      position: result.position,
    );
  }

  final tokens = result.value;

  // Handle simple case with just one text token
  if (tokens.length == 1 && tokens.first is TextToken) {
    return Text((tokens.first as TextToken).text);
  }

  // Handle complex case with multiple tokens
  final (_, spans) = tokens.fold<(TextStyle?, List<InlineSpan>)>(
    (null, <InlineSpan>[]),
    (acc, token) => _buildRichTextFromTokens(colorscheme, acc, token),
  );

  return Text.rich(TextSpan(children: spans));
}
