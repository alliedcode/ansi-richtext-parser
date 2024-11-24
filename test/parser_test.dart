import 'package:ansi_richtext_parser/ansi_richtext_parser/color.dart';
import 'package:ansi_richtext_parser/ansi_richtext_parser/parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petitparser/core.dart';

void main() {
  final parser = AnsiParser().build();
  parse(val) => parser.parse(val);

  test('No colors', () {
    final result = parse("abc");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(1));
    expect(result.value[0], equals("abc"));
  });

  test('FG color', () {
    final result = parse("\x1B[30m");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(1));
    expect(result.value[0], equals(AnsiColor(fgColor: 30)));
  });

  test('FG + BG color', () {
    final result = parse("\u001b[30;40m");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(1));
    expect(result.value[0], equals(AnsiColor(fgColor: 30, bgColor: 40)));
  });

  test('Mixed colors and text', () {
    final result = parse("\u001b[96m29/\u001b[36m40");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(4));
    expect(result.value[0], equals(AnsiColor(fgColor: 96))); // first token
    expect(result.value[1], equals("29/")); // first string
    expect(result.value[2], equals(AnsiColor(fgColor: 36))); // second token
    expect(result.value[3], equals("40")); // second string
  });

  test('FG extended color (38;5;<n>)', () {
    final result = parse("\x1B[38;5;196m");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(1));
    expect(result.value[0], equals(AnsiColor(fgColor: 196, isFgExtended: true))); // Foreground extended color
  });

  test('BG extended color (48;5;<n>)', () {
    final result = parse("\x1B[48;5;46m");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(1));
    expect(result.value[0], equals(AnsiColor(bgColor: 46, isBgExtended: true))); // Background extended color
  });

  test('FG and BG extended colors combined', () {
    final result = parse("\x1B[38;5;123;48;5;210m");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(1));
    expect(
      result.value[0],
      equals(AnsiColor(fgColor: 123, bgColor: 210, isFgExtended: true, isBgExtended: true)), // Foreground 123, Background 210
    );
  });

  test('Mixed extended colors and text', () {
    final result = parse("\x1B[38;5;196mHello \x1B[48;5;46mWorld");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(4));
    expect(result.value[0], equals(AnsiColor(fgColor: 196, isFgExtended: true))); // Foreground extended color
    expect(result.value[1], equals("Hello ")); // First string
    expect(result.value[2], equals(AnsiColor(bgColor: 46, isBgExtended: true))); // Background extended color
    expect(result.value[3], equals("World")); // Second string
  });

  test('Reset colors (\\x1B[0m)', () {
    final result = parse("\x1B[38;5;196mRed\x1B[0mNormal");
    expect(result is Success, isTrue);
    expect(result.value.length, equals(4));
    expect(result.value[0], equals(AnsiColor(fgColor: 196, isFgExtended: true))); // Foreground extended color
    expect(result.value[1], equals("Red")); // First string
    expect(result.value[2], equals(AnsiColor(fgColor: 0))); // Reset colors
    expect(result.value[3], equals("Normal")); // Second string
  });
}
