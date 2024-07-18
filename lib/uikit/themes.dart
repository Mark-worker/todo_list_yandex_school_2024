import 'package:flutter/material.dart';
import "package:todo_list_yandex_school_2024/uikit/colors.dart";
import "package:todo_list_yandex_school_2024/uikit/styles.dart";

class AppThemeData {
  // --------------------------
  // LightTheme
  // --------------------------
  static final lightTheme = ThemeData(
    useMaterial3: false,

    brightness: Brightness.light,

    // Basic color scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ColorPalette.lightColorBlue,
      onPrimary: ColorPalette.lightColorWhite,
      secondary: ColorPalette.lightColorGreen,
      onSecondary: ColorPalette.lightColorWhite,
      error: ColorPalette.lightColorRed,
      onError: ColorPalette.lightColorWhite,
      surface: ColorPalette.lightBackElevated,
      onSurface: ColorPalette.lightLabelPrimary,
      tertiary: ColorPalette.lightLabelTertiary,
    ),

    iconTheme: const IconThemeData(
      color: ColorPalette.lightLabelTertiary,
    ),

    scaffoldBackgroundColor: ColorPalette.ligthBackPrimary,

    appBarTheme: const AppBarTheme(
      backgroundColor: ColorPalette.ligthBackPrimary,
      surfaceTintColor: ColorPalette.ligthBackPrimary,
      iconTheme: IconThemeData(
        color: ColorPalette.lightLabelPrimary,
      ),
    ),

    // Typography
    textTheme: TextTheme(
      titleLarge: AppTextStyle.largeTitleStyle.copyWith(
        color: ColorPalette.lightLabelPrimary,
      ),
      titleMedium: AppTextStyle.titleStyle.copyWith(
        color: ColorPalette.lightLabelPrimary,
      ),
      bodyMedium: AppTextStyle.bodyStyle.copyWith(
        color: ColorPalette.lightLabelPrimary,
      ),
      bodySmall: AppTextStyle.subheadStyle.copyWith(
        color: ColorPalette.lightLabelTertiary,
      ),
      bodyLarge: AppTextStyle.buttonStyle.copyWith(
        color: ColorPalette.lightLabelPrimary,
      ),
    ),
    // Input decoration
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorPalette.lightColorBlue,
      shape: CircleBorder(),
      sizeConstraints: BoxConstraints(
        minHeight: 56,
        minWidth: 56,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.lightColorGreen;
          }
          return null;
        },
      ),
      checkColor: const WidgetStatePropertyAll(ColorPalette.lightColorWhite),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: AppTextStyle.bodyStyle
          .copyWith(color: ColorPalette.lightLabelPrimary),
      hintStyle: AppTextStyle.bodyStyle
          .copyWith(color: ColorPalette.lightLabelTertiary),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.all(16),
        ),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.lightColorBlue;
        } else {
          return ColorPalette.lightBackElevated;
        }
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.lightColorBlue.withOpacity(0.30);
        } else {
          return ColorPalette.lightSupportOverlay;
        }
      }),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 4,
    ),
    dividerColor: ColorPalette.lightSupportSeparator,
    dividerTheme: const DividerThemeData(
      thickness: 1,
    ),

    // DatePicker (calendar)
    datePickerTheme: DatePickerThemeData(
      rangePickerElevation: 88,
      headerBackgroundColor: ColorPalette.lightColorBlue,
      headerForegroundColor: ColorPalette.lightColorWhite,
      backgroundColor: ColorPalette.lightBackSecondary,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyle.subheadStyle.copyWith(
          color: ColorPalette.lightLabelPrimary,
        ),
      ),
      dayForegroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.lightColorWhite;
          }
          return ColorPalette.lightLabelPrimary;
        },
      ),
      yearForegroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.lightColorWhite;
          }
          return ColorPalette.lightLabelPrimary;
        },
      ),
      rangePickerHeaderForegroundColor: ColorPalette.lightLabelPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    ),
  );

  // --------------------------
  // Dark Theme
  // --------------------------

  static final darkTheme = ThemeData(
    useMaterial3: false,

    brightness: Brightness.dark,

    // Basic color scheme
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: ColorPalette.darkColorBlue,
      onPrimary: ColorPalette.darkColorWhite,
      secondary: ColorPalette.darkColorGreen,
      onSecondary: ColorPalette.darkColorWhite,
      error: ColorPalette.darkColorRed,
      onError: ColorPalette.darkColorWhite,
      surface: ColorPalette.darkBackSecondary,
      onSurface: ColorPalette.darkLabelPrimary,
      tertiary: ColorPalette.darkLabelTertiary,
    ),

    iconTheme: const IconThemeData(
      color: ColorPalette.darkLabelTertiary,
    ),

    scaffoldBackgroundColor: ColorPalette.darkBackPrimary,

    appBarTheme: const AppBarTheme(
      backgroundColor: ColorPalette.darkBackPrimary,
      surfaceTintColor: ColorPalette.darkBackPrimary,
      iconTheme: IconThemeData(
        color: ColorPalette.darkLabelPrimary,
      ),
    ),

    // Typography
    textTheme: TextTheme(
      titleLarge: AppTextStyle.largeTitleStyle.copyWith(
        color: ColorPalette.darkLabelPrimary,
      ),
      titleMedium: AppTextStyle.titleStyle.copyWith(
        color: ColorPalette.darkLabelPrimary,
      ),
      bodyMedium: AppTextStyle.bodyStyle.copyWith(
        color: ColorPalette.darkLabelPrimary,
      ),
      bodySmall: AppTextStyle.subheadStyle.copyWith(
        color: ColorPalette.darkLabelTertiary,
      ),
      bodyLarge: AppTextStyle.buttonStyle.copyWith(
        color: ColorPalette.darkLabelPrimary,
      ),
    ),

    // Input decoration
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorPalette.darkColorBlue,
      shape: CircleBorder(),
      sizeConstraints: BoxConstraints(
        minHeight: 56,
        minWidth: 56,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.darkColorGreen;
          }
          return null;
        },
      ),
      checkColor: const WidgetStatePropertyAll(ColorPalette.lightColorWhite),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle:
          AppTextStyle.bodyStyle.copyWith(color: ColorPalette.darkLabelPrimary),
      hintStyle: AppTextStyle.bodyStyle
          .copyWith(color: ColorPalette.darkLabelTertiary),
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.all(16),
        ),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.darkColorBlue;
        } else {
          return ColorPalette.darkBackElevated;
        }
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorPalette.darkColorBlue.withOpacity(0.30);
        } else {
          return ColorPalette.darkSupportOverlay;
        }
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        } else {
          return ColorPalette.darkLabelTertiary;
        }
      }),
    ),

    // List tile
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 4,
      iconColor: ColorPalette.darkLabelTertiary,
    ),
    dividerColor: ColorPalette.darkSupportSeparator,
    dividerTheme: const DividerThemeData(
      thickness: 1,
    ),

    // DatePicker (calendar)
    datePickerTheme: DatePickerThemeData(
      rangePickerElevation: 88,
      headerBackgroundColor: ColorPalette.darkColorBlue,
      headerForegroundColor: ColorPalette.darkColorWhite,
      backgroundColor: ColorPalette.darkBackSecondary,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyle.subheadStyle.copyWith(
          color: ColorPalette.darkLabelPrimary,
        ),
      ),
      dayForegroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.darkBackSecondary;
          }
          return ColorPalette.darkLabelPrimary;
        },
      ),
      yearForegroundColor: WidgetStateColor.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPalette.darkBackSecondary;
          }
          return ColorPalette.darkLabelPrimary;
        },
      ),
      rangePickerHeaderForegroundColor: ColorPalette.darkLabelPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
    ),
  );
}
