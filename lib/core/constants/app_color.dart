import 'package:flutter/material.dart';

/// Central app colors. Use [AppColors] everywhere instead of local Color(...).
class AppColors {
  AppColors._();

  // ----- Theme -----
  static const Color primary = Color(0xFF102B2A);
  // Deep premium teal (main brand color)

  static const Color secondary = Color(0xFF2F6F6B);
  // Soft supporting teal

  static const Color accent = Color(0xFFD6B25E);
  // Elegant gold accent

  static const Color background = Color(0xFFFFF1F6);
  // Soft blush pink (girly + classy background)

  static const Color text = Color(0xFF102B2A);
  // Strong readable text (matches brand)

  static const Color card = Color(0xFFFFFDF9);
  // Warm cream cards (luxury feel)

  // ----- UI (CTAs, surfaces, borders) -----
  static const Color redAccent = Color(0xFF102B2A);
  // Primary CTA / Buy Now (strong web impact)

  static const Color textPrimary = Color(0xFF102B2A);
  // Headings & titles

  static const Color textSecondary = Color(0xFF6B7280);
  // Muted text (kept neutral for readability)

  static const Color borderGrey = Color(0xFFE6E1E8);
  // Soft border (matches pink theme)

  static const Color categoryBg = Color(0xFFFFF1F6);
  // Soft pink surface

  static const Color subtleShadow = Color(0x14000000);
  // Natural soft shadow

  // ----- Accents -----
  static const Color greenAccent = Color(0xFF22C55E);
  // Success / positive

  static const Color whatsAppGreen = Color(0xFF25D366);
  // WhatsApp brand

  static const Color softPink = Color(0xFFFFF1F6);
  // Soft blush background (girly & elegant)

  static const Color roseGold = Color(0xFF2F6F6B);
  // Soft teal accent (thin, modern, premium)

  static const Color deepRose = Color(0xFF102B2A);
  // Deep luxury teal (headers, strong accents)

  static const Color goldAccent = Color(0xFFE6C87A);
  // Champagne gold (badges, stars, offers)

  static const Color warmCream = Color(0xFFFFFDF9);
  // Warm ivory cards
}

/// Dark theme colors for the Admin panel. Modern, professional dashboard look.
class AdminColors {
  AdminColors._();

  // ----- Surfaces -----
  static const Color surface = Color(0xFF1E1E2C); // Darker main background
  static const Color surfaceVariant = Color(0xFF2C2C3A); // Panels / sections
  static const Color surfaceElevated = Color(
    0xFF3A3A48,
  ); // Elevated cards / popups

  // ----- Text -----
  static const Color onSurface = Color(0xFFECEFF4); // Primary text / headings
  static const Color onSurfaceVariant = Color(
    0xFFB0B6C1,
  ); // Muted / secondary text

  // ----- Accents -----
  static const Color accent = Color(0xFF2F6F6B); // Your brand primary color
  static const Color accentSoft = Color(
    0x332F6F6B,
  ); // Soft / translucent accent

  // ----- Borders / outlines -----
  static const Color outline = Color(0xFF4A4F5A); // Panels and card borders

  // ----- Status -----
  static const Color success = Color(0xFF22C55E); // Positive / success
  static const Color warning = Color(0xFFD6B25E); // Warning / attention
  static const Color danger = Color(0xFFEF4444); // Error / destructive
}
