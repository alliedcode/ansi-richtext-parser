class AnsiColor {
  final int? fgColor;
  final int? bgColor;
  final bool isFgExtended;
  final bool isBgExtended;

  AnsiColor({this.fgColor, this.bgColor, this.isFgExtended = false, this.isBgExtended = false});

  @override
  String toString() => 'AnsiColor{fgColor: $fgColor, bgColor: $bgColor, isFgExtended: $isFgExtended, isBgExtended: $isBgExtended}';

  @override
  bool operator ==(Object o) =>
      identical(this, o) || o is AnsiColor && fgColor == o.fgColor && bgColor == o.bgColor && isFgExtended == o.isFgExtended && isBgExtended == o.isBgExtended;

  @override
  int get hashCode => fgColor.hashCode + bgColor.hashCode + isFgExtended.hashCode + isBgExtended.hashCode;
}
