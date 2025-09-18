/// Represents an ANSI color with optional foreground and background colors
class AnsiColor {
  final int? fgColor;
  final int? bgColor;
  final bool isFgExtended;
  final bool isBgExtended;

  const AnsiColor._({
    this.fgColor,
    this.bgColor,
    this.isFgExtended = false,
    this.isBgExtended = false,
  });

  /// Factory constructor for basic ANSI colors
  factory AnsiColor.basic({
    int? fgColor,
    int? bgColor,
  }) {
    _validateBasicColor(fgColor, true);
    _validateBasicColor(bgColor, false);
    return AnsiColor._(
      fgColor: fgColor,
      bgColor: bgColor,
      isFgExtended: false,
      isBgExtended: false,
    );
  }

  /// Factory constructor for extended ANSI colors (256-color palette)
  factory AnsiColor.extended({
    int? fgColor,
    int? bgColor,
  }) {
    _validateExtendedColor(fgColor, true);
    _validateExtendedColor(bgColor, false);
    return AnsiColor._(
      fgColor: fgColor,
      bgColor: bgColor,
      isFgExtended: fgColor != null,
      isBgExtended: bgColor != null,
    );
  }

  /// Factory constructor for reset (clears all colors)
  factory AnsiColor.reset() => const AnsiColor._(fgColor: 0);

  /// Legacy constructor for backward compatibility
  @Deprecated(
      'Use AnsiColor.basic(), AnsiColor.extended(), or AnsiColor.reset() instead')
  AnsiColor({
    this.fgColor,
    this.bgColor,
    this.isFgExtended = false,
    this.isBgExtended = false,
  });

  /// Validates basic ANSI color codes (30-37, 90-97 for fg; 40-47, 100-107 for bg)
  static void _validateBasicColor(int? color, bool isForeground) {
    if (color == null) return;

    final validRanges =
        isForeground ? [(30, 37), (90, 97)] : [(40, 47), (100, 107)];

    final isValid =
        validRanges.any((range) => color >= range.$1 && color <= range.$2);

    if (!isValid) {
      throw ArgumentError(
          'Invalid basic ${isForeground ? 'foreground' : 'background'} color: $color. '
          'Must be in ranges ${isForeground ? '30-37 or 90-97' : '40-47 or 100-107'}.');
    }
  }

  /// Validates extended ANSI color codes (0-255)
  static void _validateExtendedColor(int? color, bool isForeground) {
    if (color == null) return;

    if (color < 0 || color > 255) {
      throw ArgumentError(
          'Invalid extended ${isForeground ? 'foreground' : 'background'} color: $color. '
          'Must be between 0 and 255.');
    }
  }

  /// Returns true if this represents a reset color
  bool get isReset => fgColor == 0 && bgColor == null;

  /// Returns true if this color has any foreground color set
  bool get hasForeground => fgColor != null && fgColor != 0;

  /// Returns true if this color has any background color set
  bool get hasBackground => bgColor != null;

  @override
  String toString() =>
      'AnsiColor{fgColor: $fgColor, bgColor: $bgColor, isFgExtended: $isFgExtended, isBgExtended: $isBgExtended}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnsiColor &&
          fgColor == other.fgColor &&
          bgColor == other.bgColor &&
          isFgExtended == other.isFgExtended &&
          isBgExtended == other.isBgExtended;

  @override
  int get hashCode => Object.hash(fgColor, bgColor, isFgExtended, isBgExtended);
}
