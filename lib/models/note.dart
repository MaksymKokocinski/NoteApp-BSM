//konstruktor
class Note {
  int id;
  final String title;

  Note({
    this.id,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}
