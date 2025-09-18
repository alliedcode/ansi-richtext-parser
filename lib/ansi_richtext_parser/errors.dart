/// Base class for all parsing errors
sealed class ParsingError {
  final String message;
  final String? input;
  final int? position;

  const ParsingError(this.message, {this.input, this.position});

  @override
  String toString() {
    final buffer = StringBuffer('ParsingError: $message');
    if (input != null) buffer.write(' in input: "$input"');
    if (position != null) buffer.write(' at position $position');
    return buffer.toString();
  }
}

/// Error when an unexpected token is encountered
class UnexpectedTokenError extends ParsingError {
  final dynamic token;
  final String expectedType;

  const UnexpectedTokenError(
    this.token,
    this.expectedType, {
    String? input,
    int? position,
  }) : super(
          'Unexpected token: $token. Expected: $expectedType',
          input: input,
          position: position,
        );

  @override
  String toString() {
    final buffer = StringBuffer('UnexpectedTokenError: token "$token" of type ${token.runtimeType}');
    buffer.write(' was encountered but expected $expectedType');
    if (input != null) buffer.write(' in input: "$input"');
    if (position != null) buffer.write(' at position $position');
    return buffer.toString();
  }
}

/// Error when parsing fails completely
class ParseFailureError extends ParsingError {
  final String? reason;

  const ParseFailureError(
    String message, {
    this.reason,
    String? input,
    int? position,
  }) : super(message, input: input, position: position);

  @override
  String toString() {
    final buffer = StringBuffer('ParseFailureError: $message');
    if (reason != null) buffer.write(' (Reason: $reason)');
    if (input != null) buffer.write(' in input: "$input"');
    if (position != null) buffer.write(' at position $position');
    return buffer.toString();
  }
}
