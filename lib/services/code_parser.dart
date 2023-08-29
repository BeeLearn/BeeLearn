import "dart:convert";

class CodeParser {
  static List<List<String>> tokenize(String input) {
    List<String> lines = LineSplitter.split(input.trim()).toList();
    List<List<String>> tokens = [];

    for (String line in lines) {
      List<String> lineTokens = _findTokens(line);
      tokens.add(lineTokens.where((token) => token.isNotEmpty).toList());
    }

    return tokens;
  }

  static List<String> _findTokens(String line) {
    RegExp regExp = RegExp(r'\t| +|[^ \t]+');
    Iterable<Match> matches = regExp.allMatches(line);
    return matches.map((match) => match.group(0)!).toList();
  }
}
