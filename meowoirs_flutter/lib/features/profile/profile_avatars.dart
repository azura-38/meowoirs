import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

class AvatarItem {
  const AvatarItem({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.assetPath,
  });

  final String id;
  final String name;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String assetPath;

  String localizedName(AppLocalizations l10n) {
    return ProfileAvatars.getLocalizedName(id, l10n);
  }

  Widget buildAvatar({
    double? size,
    BoxFit fit = BoxFit.contain,
    String? semanticLabel,
  }) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: fit,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => Icon(
        icon,
        size: (size != null) ? size * 0.6 : 24,
        color: iconColor,
      ),
    );
  }
}

class ProfileAvatars {
  static const List<AvatarItem> all = [
    AvatarItem(
      id: 'avatar_warm_cat',
      name: 'Sıcak Kedi',
      backgroundColor: Color(0xFFFCEEE3),
      iconColor: Color(0xFFE8753D),
      icon: Icons.pets,
      assetPath: 'assets/images/avatars/01_cat_happy.png',
    ),
    AvatarItem(
      id: 'avatar_sage_cat',
      name: 'Adaçayı Kedi',
      backgroundColor: Color(0xFFEAEFE9),
      iconColor: Color(0xFF7A9A7B),
      icon: Icons.pets,
      assetPath: 'assets/images/avatars/02_cat_play.png',
    ),
    AvatarItem(
      id: 'avatar_lavender_cat',
      name: 'Lavanta Kedi',
      backgroundColor: Color(0xFFF0EDF5),
      iconColor: Color(0xFF9181A5),
      icon: Icons.pets,
      assetPath: 'assets/images/avatars/03_cat_sleep.png',
    ),
    AvatarItem(
      id: 'avatar_curious_cat',
      name: 'Meraklı Kedi',
      backgroundColor: Color(0xFFFFF6E5),
      iconColor: Color(0xFFE89A3D),
      icon: Icons.search,
      assetPath: 'assets/images/avatars/05_search_cat.png',
    ),
    AvatarItem(
      id: 'avatar_cozy_cat',
      name: 'Rahat Kedi',
      backgroundColor: Color(0xFFF5EFEB),
      iconColor: Color(0xFF8D6E63),
      icon: Icons.weekend,
      assetPath: 'assets/images/avatars/06_cat_bed.png',
    ),
    AvatarItem(
      id: 'avatar_gentle_paw',
      name: 'Zarif Pati',
      backgroundColor: Color(0xFFFBE9E7),
      iconColor: Color(0xFFFF7043),
      icon: Icons.pets_outlined,
      assetPath: 'assets/images/avatars/04_cat_paw.png',
    ),
    AvatarItem(
      id: 'avatar_star_gazer',
      name: 'Yıldız Gözlemcisi',
      backgroundColor: Color(0xFFEDE7F6),
      iconColor: Color(0xFF7E57C2),
      icon: Icons.star_border,
      assetPath: 'assets/images/avatars/10_cat_home.png',
    ),
    AvatarItem(
      id: 'avatar_book_cat',
      name: 'Kitap Kurdu Kedi',
      backgroundColor: Color(0xFFEFEBE9),
      iconColor: Color(0xFF6D4C41),
      icon: Icons.auto_stories,
      assetPath: 'assets/images/avatars/08_memory_book.png',
    ),
    AvatarItem(
      id: 'avatar_sunlit_cat',
      name: 'Güneş Kedi',
      backgroundColor: Color(0xFFFFF9C4),
      iconColor: Color(0xFFFBC02D),
      icon: Icons.wb_sunny_outlined,
      assetPath: 'assets/images/avatars/09_cat_sun.png',
    ),
    AvatarItem(
      id: 'avatar_whisker_heart',
      name: 'Bıyıklı Kalp',
      backgroundColor: Color(0xFFFCE4EC),
      iconColor: Color(0xFFE91E63),
      icon: Icons.favorite_border,
      assetPath: 'assets/images/avatars/07_cat_love.png',
    ),
  ];

  static AvatarItem getById(String id) {
    return all.firstWhere(
      (a) => a.id == id,
      orElse: () => all.first,
    );
  }

  static String getLocalizedName(String id, AppLocalizations l10n) {
    switch (id) {
      case 'avatar_warm_cat':
        return l10n.avatarDescWarmCat;
      case 'avatar_sage_cat':
        return l10n.avatarDescSageCat;
      case 'avatar_lavender_cat':
        return l10n.avatarDescLavenderCat;
      case 'avatar_curious_cat':
        return l10n.avatarDescCuriousCat;
      case 'avatar_cozy_cat':
        return l10n.avatarDescCozyCat;
      case 'avatar_gentle_paw':
        return l10n.avatarDescGentlePaw;
      case 'avatar_star_gazer':
        return l10n.avatarDescStarGazer;
      case 'avatar_book_cat':
        return l10n.avatarDescBookCat;
      case 'avatar_sunlit_cat':
        return l10n.avatarDescSunlitCat;
      case 'avatar_whisker_heart':
        return l10n.avatarDescWhiskerHeart;
      default:
        return getById(id).name;
    }
  }
}
