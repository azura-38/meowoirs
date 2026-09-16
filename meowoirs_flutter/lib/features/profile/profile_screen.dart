import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/meowoirs_theme.dart';
import '../../data/models/cat.dart';
import '../../data/models/user_profile.dart';
import '../../data/providers/database_provider.dart';
import '../../domain/story/story_metrics.dart';
import '../../domain/story/story_metrics_calculator.dart';
import '../../widgets/meowoirs_card.dart';
import '../../widgets/subtle_motion.dart';
import 'profile_avatars.dart';

/// ProfileScreen: User identity, favorite cat, story preview, settings link.
/// Direct parity with ProfileScreen.kt.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onNavigateToSettings,
    required this.onNavigateToMyStory,
    required this.onNavigateToAddCat,
    required this.onNavigateToCatDetail,
  });

  final VoidCallback onNavigateToSettings;
  final VoidCallback onNavigateToMyStory;
  final VoidCallback onNavigateToAddCat;
  final ValueChanged<String> onNavigateToCatDetail;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showEditProfileDialog(UserProfile profile) {
    showDialog(
      context: context,
      builder: (context) => _EditProfileDialog(
        initialNickname: profile.nickname,
        initialAvatarId: profile.avatarId,
        onSave: (newNickname, newAvatarId) async {
          final prefs = ref.read(preferencesRepositoryProvider);
          await prefs.setUserProfile(
            profile.copyWith(
              nickname: newNickname,
              avatarId: newAvatarId,
            ),
          );
        },
      ),
    );
  }

  void _showFavoriteCatPicker(List<Cat> cats, String? favoriteCatId) {
    showDialog(
      context: context,
      builder: (context) => _FavoriteCatPickerDialog(
        cats: cats,
        selectedCatId: favoriteCatId,
        onSelectCat: (catId) async {
          final prefs = ref.read(preferencesRepositoryProvider);
          final current = prefs.userProfile;
          await prefs.setUserProfile(current.copyWith(favoriteCatId: catId));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    final catsAsync = ref.watch(catsStreamProvider);
    final memoriesAsync = ref.watch(allMemoriesStreamProvider);

    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;

    final profile = profileAsync.value ?? const UserProfile();
    final cats = catsAsync.value ?? [];
    final memories = memoriesAsync.value ?? [];

    final favoriteCat =
        cats.firstWhereOrNull((c) => c.id == profile.favoriteCatId);
    final storyMetrics = StoryMetricsCalculator.calculate(cats, memories);

    return Scaffold(
      backgroundColor: colors.cream,
      body: SafeArea(
        child: SubtleContentEntrance(
          child: ListView(
            padding: EdgeInsets.only(
              left: spacing.medium,
              right: spacing.medium,
              top: spacing.medium,
              bottom: 100, // Clearance
            ),
            children: [
              // 1. Header Card (Avatar, Nickname, Edit Button)
              _ProfileHeaderCard(
                nickname: profile.nickname,
                avatarId: profile.avatarId,
                onEditProfile: () => _showEditProfileDialog(profile),
              ),
              SizedBox(height: spacing.large),

              // 2. Favorite Cat Section
              _FavoriteCatSection(
                favoriteCat: favoriteCat,
                hasCats: cats.isNotEmpty,
                onChangeFavorite: () =>
                    _showFavoriteCatPicker(cats, profile.favoriteCatId),
                onAddCat: widget.onNavigateToAddCat,
                onCatClick: widget.onNavigateToCatDetail,
              ),
              SizedBox(height: spacing.large),

              // 3. My Story Section
              _MyStorySection(
                metrics: storyMetrics,
                onViewFullStory: widget.onNavigateToMyStory,
              ),
              SizedBox(height: spacing.large),

              // 4. Settings Entry Card
              _SettingsEntryCard(
                onNavigateToSettings: widget.onNavigateToSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.nickname,
    required this.avatarId,
    required this.onEditProfile,
  });

  final String nickname;
  final String avatarId;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);
    final avatar = ProfileAvatars.getById(avatarId);

    final displayName = nickname.trim().isNotEmpty
        ? '${l10n.profileGreetingPrefix}, $nickname'
        : l10n.profileDefaultTitle;

    return MeowoirsCard(
      shape: shapes.largeShape,
      padding: EdgeInsets.all(spacing.large),
      child: Column(
        children: [
          // Avatar
          Semantics(
            button: true,
            label: l10n.profileSelectAvatar,
            child: GestureDetector(
              onTap: onEditProfile,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: avatar.backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.orange, width: 3),
                ),
                child: Icon(avatar.icon, size: 48, color: avatar.iconColor),
              ),
            ),
          ),
          SizedBox(height: spacing.medium),

          Semantics(
            header: true,
            child: Text(
              displayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: spacing.extraSmall),

          Text(
            l10n.profileSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing.medium),

          OutlinedButton.icon(
            onPressed: onEditProfile,
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textPrimary,
              side: BorderSide(color: colors.cardBorder),
              shape: RoundedRectangleBorder(
                borderRadius: shapes.mediumRadius,
              ),
              minimumSize: const Size(120, 44),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(l10n.profileEditButton),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCatSection extends StatelessWidget {
  const _FavoriteCatSection({
    required this.favoriteCat,
    required this.hasCats,
    required this.onChangeFavorite,
    required this.onAddCat,
    required this.onCatClick,
  });

  final Cat? favoriteCat;
  final bool hasCats;
  final VoidCallback onChangeFavorite;
  final VoidCallback onAddCat;
  final ValueChanged<String> onCatClick;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.favoriteCatSectionTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
          ),
        ),
        SizedBox(height: spacing.small),

        MeowoirsCard(
          shape: shapes.largeShape,
          padding: EdgeInsets.all(spacing.medium),
          child: Builder(
            builder: (context) {
              if (favoriteCat != null) {
                final typeLabel = favoriteCat!.type == CatType.home
                    ? l10n.statHome
                    : l10n.statStreet;
                return InkWell(
                  onTap: () => onCatClick(favoriteCat!.id),
                  borderRadius: shapes.largeRadius,
                  child: Row(
                    children: [
                      // Photo
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colors.accentSageContainer,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: favoriteCat!.photoUri != null &&
                                favoriteCat!.photoUri!.isNotEmpty
                            ? _buildImage(favoriteCat!.photoUri!)
                            : Icon(Icons.pets_outlined,
                                size: 32, color: colors.sage),
                      ),
                      SizedBox(width: spacing.medium),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  favoriteCat!.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colors.textPrimary,
                                      ),
                                ),
                                SizedBox(width: spacing.extraSmall),
                                Icon(Icons.favorite,
                                    size: 16, color: colors.orange),
                              ],
                            ),
                            SizedBox(height: spacing.extraSmall),
                            Text(
                              typeLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      TextButton(
                        onPressed: onChangeFavorite,
                        child: Text(
                          l10n.favoriteCatChangeButton,
                          style: TextStyle(color: colors.orange),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (hasCats) {
                return Padding(
                  padding: EdgeInsets.all(spacing.small),
                  child: Column(
                    children: [
                      Text(
                        l10n.favoriteCatNoneSelected,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.small),
                      ElevatedButton(
                        onPressed: onChangeFavorite,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: shapes.mediumRadius,
                          ),
                        ),
                        child: Text(l10n.favoriteCatSelectButton),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.all(spacing.small),
                child: Column(
                  children: [
                    Text(
                      l10n.favoriteCatEmptyTitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing.small),
                    ElevatedButton(
                      onPressed: onAddCat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: shapes.mediumRadius,
                        ),
                      ),
                      child: Text(l10n.favoriteCatEmptyCta),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String uri) {
    try {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        return Image.network(
          uri,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.pets_outlined, size: 32),
        );
      }
      final file = File(uri);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.pets_outlined, size: 32),
        );
      }
    } catch (_) {}
    return const Icon(Icons.pets_outlined, size: 32);
  }
}

class _MyStorySection extends StatelessWidget {
  const _MyStorySection({
    required this.metrics,
    required this.onViewFullStory,
  });

  final StoryMetrics metrics;
  final VoidCallback onViewFullStory;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.myStorySectionTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
          ),
        ),
        SizedBox(height: spacing.small),

        MeowoirsCard(
          shape: shapes.largeShape,
          padding: EdgeInsets.all(spacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                final narrative = metrics.getLocalizedNarrative(l10n);
                if (narrative.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(bottom: spacing.medium),
                  child: Text(
                    narrative,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                          height: 1.5,
                        ),
                  ),
                );
              }),

              // 4 Stat boxes
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                        label: l10n.statCats, value: '${metrics.totalCats}'),
                  ),
                  SizedBox(width: spacing.small),
                  Expanded(
                    child: _StatBox(
                        label: l10n.statMemories,
                        value: '${metrics.totalMemories}'),
                  ),
                  SizedBox(width: spacing.small),
                  Expanded(
                    child: _StatBox(
                        label: l10n.statHome,
                        value: '${metrics.homeCatsCount}'),
                  ),
                  SizedBox(width: spacing.small),
                  Expanded(
                    child: _StatBox(
                        label: l10n.statStreet,
                        value: '${metrics.streetCatsCount}'),
                  ),
                ],
              ),
              SizedBox(height: spacing.medium),

              Divider(color: colors.cardBorder),

              InkWell(
                onTap: onViewFullStory,
                borderRadius: shapes.mediumRadius,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.small),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome_outlined,
                              size: 20, color: colors.orange),
                          SizedBox(width: spacing.small),
                          Text(
                            l10n.myStoryViewAll,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.orange,
                                ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios,
                          size: 16, color: colors.orange),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: colors.accentOrangeContainer.withValues(alpha: 0.3),
        borderRadius: shapes.smallRadius,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.orange,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _SettingsEntryCard extends StatelessWidget {
  const _SettingsEntryCard({required this.onNavigateToSettings});

  final VoidCallback onNavigateToSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      label: l10n.profileSettingsButton,
      child: MeowoirsCard(
        shape: shapes.largeShape,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.medium,
          vertical: spacing.small,
        ),
        child: InkWell(
          onTap: onNavigateToSettings,
          borderRadius: shapes.largeRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.settings_outlined,
                        size: 24, color: colors.textPrimary),
                    SizedBox(width: spacing.medium),
                    Text(
                      l10n.profileSettingsButton,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: colors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({
    required this.initialNickname,
    required this.initialAvatarId,
    required this.onSave,
  });

  final String initialNickname;
  final String initialAvatarId;
  final void Function(String nickname, String avatarId) onSave;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late final TextEditingController _controller;
  late String _selectedAvatarId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNickname);
    _selectedAvatarId = widget.initialAvatarId;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final spacing = context.meowoirsSpacing;
    final shapes = context.meowoirsShapes;
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.profileEditDialogTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              maxLength: 30,
              decoration: InputDecoration(
                labelText: l10n.profileNicknameLabel,
                hintText: l10n.profileNicknamePlaceholder,
              ),
            ),
            SizedBox(height: spacing.medium),

            Text(
              l10n.profileSelectAvatar,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: spacing.small),

            SizedBox(
              width: 280,
              height: 120,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: ProfileAvatars.all.length,
                itemBuilder: (context, index) {
                  final avatar = ProfileAvatars.all[index];
                  final isSelected = avatar.id == _selectedAvatarId;

                  return Semantics(
                    inMutuallyExclusiveGroup: true,
                    selected: isSelected,
                    button: true,
                    label: avatar.localizedName(l10n),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedAvatarId = avatar.id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: avatar.backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? colors.orange : colors.cardBorder,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                        child: Icon(avatar.icon,
                            size: 20, color: avatar.iconColor),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.profileCancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: shapes.mediumRadius,
            ),
          ),
          onPressed: () {
            widget.onSave(_controller.text.trim(), _selectedAvatarId);
            Navigator.of(context).pop();
          },
          child: Text(l10n.profileSave),
        ),
      ],
    );
  }
}

class _FavoriteCatPickerDialog extends StatelessWidget {
  const _FavoriteCatPickerDialog({
    required this.cats,
    required this.selectedCatId,
    required this.onSelectCat,
  });

  final List<Cat> cats;
  final String? selectedCatId;
  final ValueChanged<String> onSelectCat;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.favoriteCatDialogTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cats.length,
          itemBuilder: (context, index) {
            final cat = cats[index];
            final isSelected = cat.id == selectedCatId;

            return Semantics(
              selected: isSelected,
              button: true,
              child: ListTile(
                leading: Icon(Icons.pets_outlined,
                    color: isSelected ? colors.orange : colors.textSecondary),
                title: Text(
                  cat.name,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? colors.orange : colors.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: colors.orange)
                    : null,
                onTap: () {
                  onSelectCat(cat.id);
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.profileCancel),
        ),
      ],
    );
  }
}
