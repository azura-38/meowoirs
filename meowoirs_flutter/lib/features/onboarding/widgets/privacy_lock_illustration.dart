import 'package:flutter/material.dart';
import '../../../core/theme/meowoirs_theme.dart';

/// Screen 4: Luxury Padlock and Cat Silhouette Illustration with Emblem Badge.
/// Exact replica of PrivacyLockIllustration in OnboardingComponents.kt.
class PrivacyLockIllustration extends StatelessWidget {
  const PrivacyLockIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.meowoirsColors;

    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow backdrop
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colors.orange.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Main circular badge
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.cardBackground,
              border: Border.all(color: colors.cardBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(46, 46),
                painter: _LockCatPainter(
                  primaryColor: colors.textPrimary,
                  accentColor: colors.orange,
                  bgInnerColor: colors.cream,
                ),
              ),
            ),
          ),

          // Secondary emblem badge on bottom right
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.orange,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/onboarding_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockCatPainter extends CustomPainter {
  _LockCatPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.bgInnerColor,
  });

  final Color primaryColor;
  final Color accentColor;
  final Color bgInnerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shackle with cat ears
    final shacklePath = Path()
      ..moveTo(w * 0.30, h * 0.44)
      ..lineTo(w * 0.30, h * 0.30)
      ..lineTo(w * 0.38, h * 0.16)
      ..lineTo(w * 0.44, h * 0.22)
      ..cubicTo(w * 0.46, h * 0.19, w * 0.54, h * 0.19, w * 0.56, h * 0.22)
      ..lineTo(w * 0.62, h * 0.16)
      ..lineTo(w * 0.70, h * 0.30)
      ..lineTo(w * 0.70, h * 0.44);

    final shacklePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(shacklePath, shacklePaint);

    // Lock Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.42, w * 0.60, h * 0.46),
      const Radius.circular(10),
    );

    final bodyFill = Paint()
      ..color = bgInnerColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(bodyRect, bodyFill);

    final bodyStroke = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;
    canvas.drawRRect(bodyRect, bodyStroke);

    // Keyhole circle + slot
    final keyholePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.50, h * 0.60), 4, keyholePaint);

    final keyholeSlot = Path()
      ..moveTo(w * 0.48, h * 0.62)
      ..lineTo(w * 0.46, h * 0.72)
      ..lineTo(w * 0.54, h * 0.72)
      ..lineTo(w * 0.52, h * 0.62)
      ..close();
    canvas.drawPath(keyholeSlot, keyholePaint);
  }

  @override
  bool shouldRepaint(covariant _LockCatPainter oldDelegate) => false;
}
