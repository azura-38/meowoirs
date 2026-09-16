// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meowoirs_database.dart';

// ignore_for_file: type=lint
class $CatsTableTable extends CatsTable
    with TableInfo<$CatsTableTable, CatEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUriMeta = const VerificationMeta(
    'photoUri',
  );
  @override
  late final GeneratedColumn<String> photoUri = GeneratedColumn<String>(
    'photo_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    photoUri,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cats';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('photo_uri')) {
      context.handle(
        _photoUriMeta,
        photoUri.isAcceptableOrUnknown(data['photo_uri']!, _photoUriMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      photoUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_uri'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CatsTableTable createAlias(String alias) {
    return $CatsTableTable(attachedDatabase, alias);
  }
}

class CatEntry extends DataClass implements Insertable<CatEntry> {
  final String id;
  final String name;
  final String type;
  final String? photoUri;
  final String? note;
  final int createdAt;
  const CatEntry({
    required this.id,
    required this.name,
    required this.type,
    this.photoUri,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || photoUri != null) {
      map['photo_uri'] = Variable<String>(photoUri);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CatsTableCompanion toCompanion(bool nullToAbsent) {
    return CatsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      photoUri: photoUri == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUri),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory CatEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      photoUri: serializer.fromJson<String?>(json['photoUri']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'photoUri': serializer.toJson<String?>(photoUri),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  CatEntry copyWith({
    String? id,
    String? name,
    String? type,
    Value<String?> photoUri = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? createdAt,
  }) => CatEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    photoUri: photoUri.present ? photoUri.value : this.photoUri,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  CatEntry copyWithCompanion(CatsTableCompanion data) {
    return CatEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      photoUri: data.photoUri.present ? data.photoUri.value : this.photoUri,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('photoUri: $photoUri, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, photoUri, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.photoUri == this.photoUri &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class CatsTableCompanion extends UpdateCompanion<CatEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> photoUri;
  final Value<String?> note;
  final Value<int> createdAt;
  final Value<int> rowid;
  const CatsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.photoUri = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatsTableCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.photoUri = const Value.absent(),
    this.note = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<CatEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? photoUri,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (photoUri != null) 'photo_uri': photoUri,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? photoUri,
    Value<String?>? note,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return CatsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      photoUri: photoUri ?? this.photoUri,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (photoUri.present) {
      map['photo_uri'] = Variable<String>(photoUri.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('photoUri: $photoUri, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemoriesTableTable extends MemoriesTable
    with TableInfo<$MemoriesTableTable, MemoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catIdMeta = const VerificationMeta('catId');
  @override
  late final GeneratedColumn<String> catId = GeneratedColumn<String>(
    'cat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catNameMeta = const VerificationMeta(
    'catName',
  );
  @override
  late final GeneratedColumn<String> catName = GeneratedColumn<String>(
    'cat_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoUriMeta = const VerificationMeta(
    'photoUri',
  );
  @override
  late final GeneratedColumn<String> photoUri = GeneratedColumn<String>(
    'photo_uri',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catMoodMeta = const VerificationMeta(
    'catMood',
  );
  @override
  late final GeneratedColumn<String> catMood = GeneratedColumn<String>(
    'cat_mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userMoodMeta = const VerificationMeta(
    'userMood',
  );
  @override
  late final GeneratedColumn<String> userMood = GeneratedColumn<String>(
    'user_mood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    catId,
    catName,
    note,
    photoUri,
    catMood,
    userMood,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('cat_id')) {
      context.handle(
        _catIdMeta,
        catId.isAcceptableOrUnknown(data['cat_id']!, _catIdMeta),
      );
    } else if (isInserting) {
      context.missing(_catIdMeta);
    }
    if (data.containsKey('cat_name')) {
      context.handle(
        _catNameMeta,
        catName.isAcceptableOrUnknown(data['cat_name']!, _catNameMeta),
      );
    } else if (isInserting) {
      context.missing(_catNameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('photo_uri')) {
      context.handle(
        _photoUriMeta,
        photoUri.isAcceptableOrUnknown(data['photo_uri']!, _photoUriMeta),
      );
    }
    if (data.containsKey('cat_mood')) {
      context.handle(
        _catMoodMeta,
        catMood.isAcceptableOrUnknown(data['cat_mood']!, _catMoodMeta),
      );
    }
    if (data.containsKey('user_mood')) {
      context.handle(
        _userMoodMeta,
        userMood.isAcceptableOrUnknown(data['user_mood']!, _userMoodMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      catId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_id'],
      )!,
      catName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      photoUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_uri'],
      ),
      catMood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cat_mood'],
      ),
      userMood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_mood'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MemoriesTableTable createAlias(String alias) {
    return $MemoriesTableTable(attachedDatabase, alias);
  }
}

class MemoryEntry extends DataClass implements Insertable<MemoryEntry> {
  final String id;
  final String catId;
  final String catName;
  final String note;
  final String? photoUri;
  final String? catMood;
  final String? userMood;
  final int createdAt;
  const MemoryEntry({
    required this.id,
    required this.catId,
    required this.catName,
    required this.note,
    this.photoUri,
    this.catMood,
    this.userMood,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['cat_id'] = Variable<String>(catId);
    map['cat_name'] = Variable<String>(catName);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || photoUri != null) {
      map['photo_uri'] = Variable<String>(photoUri);
    }
    if (!nullToAbsent || catMood != null) {
      map['cat_mood'] = Variable<String>(catMood);
    }
    if (!nullToAbsent || userMood != null) {
      map['user_mood'] = Variable<String>(userMood);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  MemoriesTableCompanion toCompanion(bool nullToAbsent) {
    return MemoriesTableCompanion(
      id: Value(id),
      catId: Value(catId),
      catName: Value(catName),
      note: Value(note),
      photoUri: photoUri == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUri),
      catMood: catMood == null && nullToAbsent
          ? const Value.absent()
          : Value(catMood),
      userMood: userMood == null && nullToAbsent
          ? const Value.absent()
          : Value(userMood),
      createdAt: Value(createdAt),
    );
  }

  factory MemoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEntry(
      id: serializer.fromJson<String>(json['id']),
      catId: serializer.fromJson<String>(json['catId']),
      catName: serializer.fromJson<String>(json['catName']),
      note: serializer.fromJson<String>(json['note']),
      photoUri: serializer.fromJson<String?>(json['photoUri']),
      catMood: serializer.fromJson<String?>(json['catMood']),
      userMood: serializer.fromJson<String?>(json['userMood']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catId': serializer.toJson<String>(catId),
      'catName': serializer.toJson<String>(catName),
      'note': serializer.toJson<String>(note),
      'photoUri': serializer.toJson<String?>(photoUri),
      'catMood': serializer.toJson<String?>(catMood),
      'userMood': serializer.toJson<String?>(userMood),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  MemoryEntry copyWith({
    String? id,
    String? catId,
    String? catName,
    String? note,
    Value<String?> photoUri = const Value.absent(),
    Value<String?> catMood = const Value.absent(),
    Value<String?> userMood = const Value.absent(),
    int? createdAt,
  }) => MemoryEntry(
    id: id ?? this.id,
    catId: catId ?? this.catId,
    catName: catName ?? this.catName,
    note: note ?? this.note,
    photoUri: photoUri.present ? photoUri.value : this.photoUri,
    catMood: catMood.present ? catMood.value : this.catMood,
    userMood: userMood.present ? userMood.value : this.userMood,
    createdAt: createdAt ?? this.createdAt,
  );
  MemoryEntry copyWithCompanion(MemoriesTableCompanion data) {
    return MemoryEntry(
      id: data.id.present ? data.id.value : this.id,
      catId: data.catId.present ? data.catId.value : this.catId,
      catName: data.catName.present ? data.catName.value : this.catName,
      note: data.note.present ? data.note.value : this.note,
      photoUri: data.photoUri.present ? data.photoUri.value : this.photoUri,
      catMood: data.catMood.present ? data.catMood.value : this.catMood,
      userMood: data.userMood.present ? data.userMood.value : this.userMood,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEntry(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('catName: $catName, ')
          ..write('note: $note, ')
          ..write('photoUri: $photoUri, ')
          ..write('catMood: $catMood, ')
          ..write('userMood: $userMood, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    catId,
    catName,
    note,
    photoUri,
    catMood,
    userMood,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryEntry &&
          other.id == this.id &&
          other.catId == this.catId &&
          other.catName == this.catName &&
          other.note == this.note &&
          other.photoUri == this.photoUri &&
          other.catMood == this.catMood &&
          other.userMood == this.userMood &&
          other.createdAt == this.createdAt);
}

class MemoriesTableCompanion extends UpdateCompanion<MemoryEntry> {
  final Value<String> id;
  final Value<String> catId;
  final Value<String> catName;
  final Value<String> note;
  final Value<String?> photoUri;
  final Value<String?> catMood;
  final Value<String?> userMood;
  final Value<int> createdAt;
  final Value<int> rowid;
  const MemoriesTableCompanion({
    this.id = const Value.absent(),
    this.catId = const Value.absent(),
    this.catName = const Value.absent(),
    this.note = const Value.absent(),
    this.photoUri = const Value.absent(),
    this.catMood = const Value.absent(),
    this.userMood = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoriesTableCompanion.insert({
    required String id,
    required String catId,
    required String catName,
    required String note,
    this.photoUri = const Value.absent(),
    this.catMood = const Value.absent(),
    this.userMood = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       catId = Value(catId),
       catName = Value(catName),
       note = Value(note),
       createdAt = Value(createdAt);
  static Insertable<MemoryEntry> custom({
    Expression<String>? id,
    Expression<String>? catId,
    Expression<String>? catName,
    Expression<String>? note,
    Expression<String>? photoUri,
    Expression<String>? catMood,
    Expression<String>? userMood,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catId != null) 'cat_id': catId,
      if (catName != null) 'cat_name': catName,
      if (note != null) 'note': note,
      if (photoUri != null) 'photo_uri': photoUri,
      if (catMood != null) 'cat_mood': catMood,
      if (userMood != null) 'user_mood': userMood,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? catId,
    Value<String>? catName,
    Value<String>? note,
    Value<String?>? photoUri,
    Value<String?>? catMood,
    Value<String?>? userMood,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return MemoriesTableCompanion(
      id: id ?? this.id,
      catId: catId ?? this.catId,
      catName: catName ?? this.catName,
      note: note ?? this.note,
      photoUri: photoUri ?? this.photoUri,
      catMood: catMood ?? this.catMood,
      userMood: userMood ?? this.userMood,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catId.present) {
      map['cat_id'] = Variable<String>(catId.value);
    }
    if (catName.present) {
      map['cat_name'] = Variable<String>(catName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (photoUri.present) {
      map['photo_uri'] = Variable<String>(photoUri.value);
    }
    if (catMood.present) {
      map['cat_mood'] = Variable<String>(catMood.value);
    }
    if (userMood.present) {
      map['user_mood'] = Variable<String>(userMood.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('catId: $catId, ')
          ..write('catName: $catName, ')
          ..write('note: $note, ')
          ..write('photoUri: $photoUri, ')
          ..write('catMood: $catMood, ')
          ..write('userMood: $userMood, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MeowoirsDatabase extends GeneratedDatabase {
  _$MeowoirsDatabase(QueryExecutor e) : super(e);
  $MeowoirsDatabaseManager get managers => $MeowoirsDatabaseManager(this);
  late final $CatsTableTable catsTable = $CatsTableTable(this);
  late final $MemoriesTableTable memoriesTable = $MemoriesTableTable(this);
  late final CatDao catDao = CatDao(this as MeowoirsDatabase);
  late final MemoryDao memoryDao = MemoryDao(this as MeowoirsDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catsTable,
    memoriesTable,
  ];
}

typedef $$CatsTableTableCreateCompanionBuilder =
    CatsTableCompanion Function({
      required String id,
      required String name,
      required String type,
      Value<String?> photoUri,
      Value<String?> note,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$CatsTableTableUpdateCompanionBuilder =
    CatsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String?> photoUri,
      Value<String?> note,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$CatsTableTableFilterComposer
    extends Composer<_$MeowoirsDatabase, $CatsTableTable> {
  $$CatsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUri => $composableBuilder(
    column: $table.photoUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatsTableTableOrderingComposer
    extends Composer<_$MeowoirsDatabase, $CatsTableTable> {
  $$CatsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUri => $composableBuilder(
    column: $table.photoUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatsTableTableAnnotationComposer
    extends Composer<_$MeowoirsDatabase, $CatsTableTable> {
  $$CatsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get photoUri =>
      $composableBuilder(column: $table.photoUri, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CatsTableTableTableManager
    extends
        RootTableManager<
          _$MeowoirsDatabase,
          $CatsTableTable,
          CatEntry,
          $$CatsTableTableFilterComposer,
          $$CatsTableTableOrderingComposer,
          $$CatsTableTableAnnotationComposer,
          $$CatsTableTableCreateCompanionBuilder,
          $$CatsTableTableUpdateCompanionBuilder,
          (
            CatEntry,
            BaseReferences<_$MeowoirsDatabase, $CatsTableTable, CatEntry>,
          ),
          CatEntry,
          PrefetchHooks Function()
        > {
  $$CatsTableTableTableManager(_$MeowoirsDatabase db, $CatsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> photoUri = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatsTableCompanion(
                id: id,
                name: name,
                type: type,
                photoUri: photoUri,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<String?> photoUri = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CatsTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                photoUri: photoUri,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MeowoirsDatabase,
      $CatsTableTable,
      CatEntry,
      $$CatsTableTableFilterComposer,
      $$CatsTableTableOrderingComposer,
      $$CatsTableTableAnnotationComposer,
      $$CatsTableTableCreateCompanionBuilder,
      $$CatsTableTableUpdateCompanionBuilder,
      (CatEntry, BaseReferences<_$MeowoirsDatabase, $CatsTableTable, CatEntry>),
      CatEntry,
      PrefetchHooks Function()
    >;
typedef $$MemoriesTableTableCreateCompanionBuilder =
    MemoriesTableCompanion Function({
      required String id,
      required String catId,
      required String catName,
      required String note,
      Value<String?> photoUri,
      Value<String?> catMood,
      Value<String?> userMood,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$MemoriesTableTableUpdateCompanionBuilder =
    MemoriesTableCompanion Function({
      Value<String> id,
      Value<String> catId,
      Value<String> catName,
      Value<String> note,
      Value<String?> photoUri,
      Value<String?> catMood,
      Value<String?> userMood,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$MemoriesTableTableFilterComposer
    extends Composer<_$MeowoirsDatabase, $MemoriesTableTable> {
  $$MemoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catId => $composableBuilder(
    column: $table.catId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catName => $composableBuilder(
    column: $table.catName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUri => $composableBuilder(
    column: $table.photoUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catMood => $composableBuilder(
    column: $table.catMood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userMood => $composableBuilder(
    column: $table.userMood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemoriesTableTableOrderingComposer
    extends Composer<_$MeowoirsDatabase, $MemoriesTableTable> {
  $$MemoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catId => $composableBuilder(
    column: $table.catId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catName => $composableBuilder(
    column: $table.catName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUri => $composableBuilder(
    column: $table.photoUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catMood => $composableBuilder(
    column: $table.catMood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userMood => $composableBuilder(
    column: $table.userMood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoriesTableTableAnnotationComposer
    extends Composer<_$MeowoirsDatabase, $MemoriesTableTable> {
  $$MemoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get catId =>
      $composableBuilder(column: $table.catId, builder: (column) => column);

  GeneratedColumn<String> get catName =>
      $composableBuilder(column: $table.catName, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get photoUri =>
      $composableBuilder(column: $table.photoUri, builder: (column) => column);

  GeneratedColumn<String> get catMood =>
      $composableBuilder(column: $table.catMood, builder: (column) => column);

  GeneratedColumn<String> get userMood =>
      $composableBuilder(column: $table.userMood, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MemoriesTableTableTableManager
    extends
        RootTableManager<
          _$MeowoirsDatabase,
          $MemoriesTableTable,
          MemoryEntry,
          $$MemoriesTableTableFilterComposer,
          $$MemoriesTableTableOrderingComposer,
          $$MemoriesTableTableAnnotationComposer,
          $$MemoriesTableTableCreateCompanionBuilder,
          $$MemoriesTableTableUpdateCompanionBuilder,
          (
            MemoryEntry,
            BaseReferences<
              _$MeowoirsDatabase,
              $MemoriesTableTable,
              MemoryEntry
            >,
          ),
          MemoryEntry,
          PrefetchHooks Function()
        > {
  $$MemoriesTableTableTableManager(
    _$MeowoirsDatabase db,
    $MemoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> catId = const Value.absent(),
                Value<String> catName = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> photoUri = const Value.absent(),
                Value<String?> catMood = const Value.absent(),
                Value<String?> userMood = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoriesTableCompanion(
                id: id,
                catId: catId,
                catName: catName,
                note: note,
                photoUri: photoUri,
                catMood: catMood,
                userMood: userMood,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String catId,
                required String catName,
                required String note,
                Value<String?> photoUri = const Value.absent(),
                Value<String?> catMood = const Value.absent(),
                Value<String?> userMood = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MemoriesTableCompanion.insert(
                id: id,
                catId: catId,
                catName: catName,
                note: note,
                photoUri: photoUri,
                catMood: catMood,
                userMood: userMood,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$MeowoirsDatabase,
      $MemoriesTableTable,
      MemoryEntry,
      $$MemoriesTableTableFilterComposer,
      $$MemoriesTableTableOrderingComposer,
      $$MemoriesTableTableAnnotationComposer,
      $$MemoriesTableTableCreateCompanionBuilder,
      $$MemoriesTableTableUpdateCompanionBuilder,
      (
        MemoryEntry,
        BaseReferences<_$MeowoirsDatabase, $MemoriesTableTable, MemoryEntry>,
      ),
      MemoryEntry,
      PrefetchHooks Function()
    >;

class $MeowoirsDatabaseManager {
  final _$MeowoirsDatabase _db;
  $MeowoirsDatabaseManager(this._db);
  $$CatsTableTableTableManager get catsTable =>
      $$CatsTableTableTableManager(_db, _db.catsTable);
  $$MemoriesTableTableTableManager get memoriesTable =>
      $$MemoriesTableTableTableManager(_db, _db.memoriesTable);
}
