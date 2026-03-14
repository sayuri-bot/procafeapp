import 'package:flutter/material.dart';

class ColoresApp {
  static const fondo = Color(0xFFF5F7FA);
  static const cards = Color(0xFFFFFFFF);
  //BOTON PRIMARIO
  static const boton = Color(0xFF2563EB);
  //EN STOCK
  static const exito = Color(0xFF16A34A);
  //stock bajo
  static const advertencia = Color(0xFFF59E0B);
  //sin stock
  static const peligro = Color(0xFF7F1D1D);
  // TEXTO 
  static const textoPrincipal = Color(0xFF1E293B);
  static const textoSecundario = Color(0xFF64748B);
}

final ThemeData temaEjecutivo = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: 'Albert Sans',
  scaffoldBackgroundColor: ColoresApp.fondo,

  colorScheme: ColorScheme.fromSeed(
    seedColor: ColoresApp.boton,
    brightness: Brightness.light,
    primary: ColoresApp.boton,
    error: ColoresApp.peligro,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: ColoresApp.cards,
    elevation: 0,
    centerTitle: false,
    foregroundColor: ColoresApp.textoPrincipal,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: ColoresApp.textoPrincipal,
      fontFamily: 'Albert Sans',
    ),
  ),


  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColoresApp.boton,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE2E8F0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE2E8F0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: ColoresApp.boton,
        width: 1.5,
      ),
    ),
    labelStyle: const TextStyle(
      color: ColoresApp.textoSecundario,
      fontWeight: FontWeight.w500,
    ),
  ),

  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 22,
      color: ColoresApp.textoPrincipal,
    ),
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: ColoresApp.textoPrincipal,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: ColoresApp.textoPrincipal,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: ColoresApp.textoPrincipal,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      color: ColoresApp.textoSecundario,
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: ColoresApp.cards,
    selectedItemColor: ColoresApp.boton,
    unselectedItemColor: ColoresApp.textoSecundario,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
);