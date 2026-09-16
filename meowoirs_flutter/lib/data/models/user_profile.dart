/// User profile preference model.
/// Direct parity with UserProfile in Kotlin UserPreferencesRepository.kt.
class UserProfile {
  const UserProfile({
    this.nickname = '',
    this.avatarId = 'avatar_warm_cat',
    this.favoriteCatId = '',
  });

  final String nickname;
  final String avatarId;
  final String favoriteCatId;

  UserProfile copyWith({
    String? nickname,
    String? avatarId,
    String? favoriteCatId,
  }) {
    return UserProfile(
      nickname: nickname ?? this.nickname,
      avatarId: avatarId ?? this.avatarId,
      favoriteCatId: favoriteCatId ?? this.favoriteCatId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          nickname == other.nickname &&
          avatarId == other.avatarId &&
          favoriteCatId == other.favoriteCatId;

  @override
  int get hashCode =>
      nickname.hashCode ^ avatarId.hashCode ^ favoriteCatId.hashCode;
}
