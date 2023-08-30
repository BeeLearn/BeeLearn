class TextParser {
  static List<String> tokenize(String input) {
    RegExp pattern = RegExp(r'(%[^%]+%)');
    List<String> segments = [];

    int lastIndex = 0;
    for (RegExpMatch match in pattern.allMatches(input)) {
      segments.add(input.substring(lastIndex, match.start));
      segments.add(match.group(0)!);
      lastIndex = match.end;
    }
    segments.add(input.substring(lastIndex));

    return segments;
  }
}
