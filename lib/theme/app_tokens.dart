import 'package:flutter/material.dart';

/// Theme tokens to centralize colors and gradients for light/dark.
class AppTokens extends ThemeExtension<AppTokens> {
  // Surfaces
  final Color bg;
  final Color surface;
  final Color card;
  final Color elevatedCard;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // Border
  final Color borderSubtle;

  // Chips/Badges
  final Color chipBg;
  final Color chipFg;
  final Color successBg;
  final Color successFg;
  final Color warningBg;
  final Color warningFg;
  final Color dangerBg;
  final Color dangerFg;

  // Shadow
  final Color shadowColor;

  // Gradients (per section/page)
  final List<Color> homeGradient;
  final List<Color> updateGradient;
  final List<Color> eksepsiGradient;
  final List<Color> cutiAllGradient;
  final List<Color> insentifGradient;

  const AppTokens({
    // surfaces
    required this.bg,
    required this.surface,
    required this.card,
    required this.elevatedCard,
    // text
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    // border
    required this.borderSubtle,
    // chips
    required this.chipBg,
    required this.chipFg,
    required this.successBg,
    required this.successFg,
    required this.warningBg,
    required this.warningFg,
    required this.dangerBg,
    required this.dangerFg,
    // shadow
    required this.shadowColor,
    // gradients
    required this.homeGradient,
    required this.updateGradient,
    required this.eksepsiGradient,
    required this.cutiAllGradient,
    required this.insentifGradient,
  });

  static const light = AppTokens(
    bg: Color(0xFFF8FAFC),
    surface: Color(0xFFF8FAFC),
    card: Colors.white,
    elevatedCard: Colors.white,
    textPrimary: Color(0xFF2D3748),
    textSecondary: Color(0xFF718096),
    textMuted: Color(0xFF94A3B8),
    borderSubtle: Color(0xFFE5E7EB),
    chipBg: Color(0xFFEFF6FF),
    chipFg: Color(0xFF2563EB),
    successBg: Color(0xFFDEF7EC),
    successFg: Color(0xFF046C4E),
    warningBg: Color(0xFFFFEFD5),
    warningFg: Color(0xFFDD6B20),
    dangerBg: Color(0xFFFEE2E2),
    dangerFg: Color(0xFFB91C1C),
    shadowColor: Color(0x14000000),
    homeGradient: [Color(0xFF667EEA), Color(0xFF764BA2)],
    updateGradient: [Color(0xFFF6AD55), Color(0xFFED8936)],
    eksepsiGradient: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    cutiAllGradient: [Color(0xFF4FACFE), Color(0xFF00D2FF)],
    insentifGradient: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );

  static const dark = AppTokens(
    bg: Color(0xFF0B1220),
    surface: Color(0xFF0F172A),
    card: Color(0xFF111827),
    elevatedCard: Color(0xFF111827),
    textPrimary: Color(0xFFE5E7EB),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    borderSubtle: Color(0xFF334155),
    chipBg: Color(0xFF1E293B),
    chipFg: Color(0xFF93C5FD),
    successBg: Color(0xFF0E3B2E),
    successFg: Color(0xFF34D399),
    warningBg: Color(0xFF3B2A0A),
    warningFg: Color(0xFFFBBF24),
    dangerBg: Color(0xFF3B0F0F),
    dangerFg: Color(0xFFF87171),
    shadowColor: Color(0x66000000),
    homeGradient: [Color(0xFF5469D4), Color(0xFF6B4BD1)],
    updateGradient: [Color(0xFFF59E0B), Color(0xFFEA580C)],
    eksepsiGradient: [Color(0xFF0891B2), Color(0xFF2563EB)],
    cutiAllGradient: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    insentifGradient: [Color(0xFF16A34A), Color(0xFF059669)],
  );

  @override
  AppTokens copyWith({
    Color? bg,
    Color? surface,
    Color? card,
    Color? elevatedCard,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? borderSubtle,
    Color? chipBg,
    Color? chipFg,
    Color? successBg,
    Color? successFg,
    Color? warningBg,
    Color? warningFg,
    Color? dangerBg,
    Color? dangerFg,
    Color? shadowColor,
    List<Color>? homeGradient,
    List<Color>? updateGradient,
    List<Color>? eksepsiGradient,
    List<Color>? cutiAllGradient,
    List<Color>? insentifGradient,
  }) {
    return AppTokens(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      elevatedCard: elevatedCard ?? this.elevatedCard,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      chipBg: chipBg ?? this.chipBg,
      chipFg: chipFg ?? this.chipFg,
      successBg: successBg ?? this.successBg,
      successFg: successFg ?? this.successFg,
      warningBg: warningBg ?? this.warningBg,
      warningFg: warningFg ?? this.warningFg,
      dangerBg: dangerBg ?? this.dangerBg,
      dangerFg: dangerFg ?? this.dangerFg,
      shadowColor: shadowColor ?? this.shadowColor,
      homeGradient: homeGradient ?? this.homeGradient,
      updateGradient: updateGradient ?? this.updateGradient,
      eksepsiGradient: eksepsiGradient ?? this.eksepsiGradient,
      cutiAllGradient: cutiAllGradient ?? this.cutiAllGradient,
      insentifGradient: insentifGradient ?? this.insentifGradient,
    );
  }

  @override
  ThemeExtension<AppTokens> lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;
    List<Color> lerpGradient(List<Color> a, List<Color> b) => [
          lerpColor(a[0], b[0]),
          lerpColor(a[1], b[1]),
        ];
    return AppTokens(
      bg: lerpColor(bg, other.bg),
      surface: lerpColor(surface, other.surface),
      card: lerpColor(card, other.card),
      elevatedCard: lerpColor(elevatedCard, other.elevatedCard),
      textPrimary: lerpColor(textPrimary, other.textPrimary),
      textSecondary: lerpColor(textSecondary, other.textSecondary),
      textMuted: lerpColor(textMuted, other.textMuted),
      borderSubtle: lerpColor(borderSubtle, other.borderSubtle),
      chipBg: lerpColor(chipBg, other.chipBg),
      chipFg: lerpColor(chipFg, other.chipFg),
      successBg: lerpColor(successBg, other.successBg),
      successFg: lerpColor(successFg, other.successFg),
      warningBg: lerpColor(warningBg, other.warningBg),
      warningFg: lerpColor(warningFg, other.warningFg),
      dangerBg: lerpColor(dangerBg, other.dangerBg),
      dangerFg: lerpColor(dangerFg, other.dangerFg),
      shadowColor: lerpColor(shadowColor, other.shadowColor),
      homeGradient: lerpGradient(homeGradient, other.homeGradient),
      updateGradient: lerpGradient(updateGradient, other.updateGradient),
      eksepsiGradient: lerpGradient(eksepsiGradient, other.eksepsiGradient),
      cutiAllGradient: lerpGradient(cutiAllGradient, other.cutiAllGradient),
      insentifGradient: lerpGradient(insentifGradient, other.insentifGradient),
    );
  }
}

