import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    //Define black as the color that most buttons and icons, and white as the color of the background
    primaryColor: Colors.black,
    hintColor: Colors.black,
    cardColor: Colors.grey[300],
    focusColor: Colors.black,
    hoverColor: Colors.grey[300],
    shadowColor: Colors.grey[300],
    splashColor: Colors.black,
    canvasColor: Colors.white,
    dividerColor: Colors.grey[300],
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.black,
    disabledColor: Colors.black,
    highlightColor: Colors.black,
    indicatorColor: const Color.fromARGB(255, 163, 246, 175),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 3,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    secondaryHeaderColor: Colors.black,
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.grey[600],
    applyElevationOverlayColor: true,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
  );
}
