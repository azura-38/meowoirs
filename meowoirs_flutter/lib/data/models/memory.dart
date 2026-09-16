/// Memory domain model.
/// Direct parity with Memory.kt in the Kotlin reference implementation.
class Memory {
  const Memory({
    required this.id,
    required this.catId,
    required this.catName,
    required this.note,
    this.photoUri,
    this.catMood,
    this.userMood,
    required this.createdAt,
  });

  final String id;
  final String catId;
  final String catName;
  final String note;
  final String? photoUri;
  final String? catMood;
  final String? userMood;
  final int createdAt;

  Memory copyWith({
    String? id,
    String? catId,
    String? catName,
    String? note,
    String? photoUri,
    String? catMood,
    String? userMood,
    int? createdAt,
  }) {
    return Memory(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      catName: catName ?? this.catName,
      note: note ?? this.note,
      photoUri: photoUri ?? this.photoUri,
      catMood: catMood ?? this.catMood,
      userMood: userMood ?? this.userMood,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Memory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          catId == other.catId &&
          catName == other.catName &&
          note == other.note &&
          photoUri == other.photoUri &&
          catMood == other.catMood &&
          userMood == other.userMood &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      catId.hashCode ^
      catName.hashCode ^
      note.hashCode ^
      photoUri.hashCode ^
      catMood.hashCode ^
      userMood.hashCode ^
      createdAt.hashCode;
}
