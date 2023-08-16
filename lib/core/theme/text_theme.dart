// Define your text theme
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _titleFont = GoogleFonts.bangers; // this font already bold
const _bodyFont = GoogleFonts.roboto;

final textTheme = TextTheme(
  // Display styles
  displayLarge: _titleFont(fontSize: 36),
  displayMedium: _titleFont(fontSize: 24),
  displaySmall: _titleFont(fontSize: 20),

  // Headline styles
  headlineLarge: _titleFont(fontSize: 28),
  headlineMedium: _titleFont(fontSize: 24),
  headlineSmall: _titleFont(fontSize: 20),

  // Title styles
  titleLarge: _bodyFont(fontSize: 22, fontWeight: FontWeight.bold),
  titleMedium: _bodyFont(fontSize: 18, fontWeight: FontWeight.bold),
  titleSmall: _bodyFont(fontSize: 16, fontWeight: FontWeight.bold),

  // Body styles
  bodyLarge: _bodyFont(fontSize: 20, fontWeight: FontWeight.normal),
  bodyMedium: _bodyFont(fontSize: 16, fontWeight: FontWeight.normal),
  bodySmall: _bodyFont(fontSize: 14, fontWeight: FontWeight.normal),

  // Label styles
  labelLarge: _bodyFont(fontSize: 18, fontWeight: FontWeight.normal),
  labelMedium: _bodyFont(fontSize: 14, fontWeight: FontWeight.normal),
  labelSmall: _bodyFont(fontSize: 12, fontWeight: FontWeight.normal),
);
