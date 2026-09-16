import '../../core/localization/app_localizations.dart';

enum CatType {
  home('Ev Kedisi'),
  street('Sokak Kedisi');

  const CatType(this.label);
  final String label;

  String localizedLabel(AppLocalizations l10n) {
    return this == CatType.street ? l10n.catTypeStreet : l10n.catTypeHome;
  }

  static CatType fromString(String? value) {
    if (value == 'STREET' || value == 'street') {
      return CatType.street;
    }
    return CatType.home;
  }

  String toStorageString() => this == CatType.street ? 'STREET' : 'HOME';
}

/// Cat domain model.
/// Direct parity with Cat.kt in the Kotlin reference implementation.
class Cat {
  const Cat({
    required this.id,
    required this.name,
    required this.type,
    this.photoUri,
    this.note,
    required this.createdAt,
  });

  final String id;
  final String name;
  final CatType type;
  final String? photoUri;
  final String? note;
  final int createdAt;

  Cat copyWith({
    String? id,
    String? name,
    CatType? type,
    String? photoUri,
    String? note,
    int? createdAt,
  }) {
    return Cat(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      photoUri: photoUri ?? this.photoUri,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cat &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          photoUri == other.photoUri &&
          note == other.note &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      photoUri.hashCode ^
      note.hashCode ^
      createdAt.hashCode;
}
