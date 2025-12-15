class ImportantDay {
  final DateTime date;
  final String title;

  ImportantDay({required this.date, required this.title});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'title': title,
  };

  factory ImportantDay.fromJson(Map<String, dynamic> json) {
    return ImportantDay(
      date: DateTime.parse(json['date']),
      title: json['title'],
    );
  }
}
