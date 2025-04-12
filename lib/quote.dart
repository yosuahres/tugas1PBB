class Quote {
  int? id; 
  String text;
  String author;

  Quote({this.id, required this.text, required this.author});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
    };
  }
  
  static Quote fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      text: map['text'],
      author: map['author'],
    );
  }

  // Add the copyWith method
  Quote copyWith({int? id, String? text, String? author}) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
    );
  }
}