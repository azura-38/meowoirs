import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/meowoirs_theme.dart';

/// Reusable memory thumbnail widget supporting network, file, and graceful fallback.
class MemoryThumbnail extends StatelessWidget {
  const MemoryThumbnail({
    super.key,
    required this.photoUri,
    this.catName = '',
    this.width,
    this.height,
    this.aspectRatio,
    this.borderRadius,
    this.iconSize = 24.0,
    this.fit = BoxFit.cover,
  });

  final String? photoUri;
  final String catName;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BorderRadius? borderRadius;
  final double iconSize;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;
    final shapes = context.meowoirsShapes;
    final radius = borderRadius ?? shapes.mediumRadius;

    Widget content;
    final uri = photoUri?.trim();
    if (uri != null && uri.isNotEmpty) {
      if (uri.startsWith('http://') || uri.startsWith('https://')) {
        content = Image.network(
          uri,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => _buildFallback(context),
        );
      } else {
        try {
          final file = File(uri);
          if (file.existsSync()) {
            content = Image.file(
              file,
              fit: fit,
              width: width,
              height: height,
              errorBuilder: (_, __, ___) => _buildFallback(context),
            );
          } else {
            content = _buildFallback(context);
          }
        } catch (_) {
          content = _buildFallback(context);
        }
      }
    } else {
      content = _buildFallback(context);
    }

    if (aspectRatio != null) {
      content = AspectRatio(
        aspectRatio: aspectRatio!,
        child: content,
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: width,
        height: height,
        color: colors.accentOrangeContainer.withValues(alpha: 0.35),
        child: content,
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final colors = context.meowoirsColors;
    return Center(
      child: Icon(
        Icons.camera_alt_outlined,
        size: iconSize,
        color: colors.orange.withValues(alpha: 0.5),
      ),
    );
  }
}
