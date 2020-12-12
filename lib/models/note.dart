//konstruktor
class Note {
  int id;
  final String note;

  Note({
    this.id,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': note};
  }
}
