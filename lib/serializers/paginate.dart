/// Don't use  json_serializer for this file
/// json_serializer generic_argument_factories require a lot of boilerplate code
class Paginate<T> {
  final int count;
  final String? previous, next;
  final List<T> results;

  const Paginate({
    this.next,
    this.previous,
    required this.count,
    required this.results,
  });

  factory Paginate.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJSON,
  ) {
    return Paginate(
      count: json["count"],
      previous: json["previous"],
      next: json["next"],
      results: json["results"].map<T>((response) => fromJSON(response)).toList(),
    );
  }
}
