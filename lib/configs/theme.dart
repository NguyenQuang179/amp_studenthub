import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4279061896),
      surfaceTint: Color(4280967324),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282348207),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278197305),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4280433758),
      onSecondaryContainer: Color(4290170872),
      tertiary: Color(4283981674),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4292863731),
      onTertiaryContainer: Color(4282600021),
      error: Color(4290256670),
      onError: Color(4294967295),
      errorContainer: Color(4294930017),
      onErrorContainer: Color(4280745985),
      background: Color(4294572543),
      onBackground: Color(4279835680),
      surface: Color(4294768888),
      onSurface: Color(4280032027),
      surfaceVariant: Color(4292993767),
      onSurfaceVariant: Color(4282664779),
      outline: Color(4285888380),
      outlineVariant: Color(4291151563),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413680),
      inverseOnSurface: Color(4294242543),
      inversePrimary: Color(4288924159),
      primaryFixed: Color(4292076543),
      onPrimaryFixed: Color(4278197305),
      primaryFixedDim: Color(4288924159),
      onPrimaryFixedVariant: Color(4278208642),
      secondaryFixed: Color(4292142079),
      onSecondaryFixed: Color(4278197306),
      secondaryFixedDim: Color(4289710321),
      onSecondaryFixedVariant: Color(4281288810),
      tertiaryFixed: Color(4292666352),
      onTertiaryFixed: Color(4279573541),
      tertiaryFixedDim: Color(4290824147),
      onTertiaryFixedVariant: Color(4282402642),
      surfaceDim: Color(4292729305),
      surfaceBright: Color(4294768888),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439922),
      surfaceContainer: Color(4294045164),
      surfaceContainerHigh: Color(4293650407),
      surfaceContainerHighest: Color(4293255905),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278207612),
      surfaceTint: Color(4280967324),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282348207),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278197305),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4280433758),
      onSecondaryContainer: Color(4294966783),
      tertiary: Color(4282139470),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285429120),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292360241),
      onErrorContainer: Color(4294967295),
      background: Color(4294572543),
      onBackground: Color(4279835680),
      surface: Color(4294768888),
      onSurface: Color(4280032027),
      surfaceVariant: Color(4292993767),
      onSurfaceVariant: Color(4282467143),
      outline: Color(4284309348),
      outlineVariant: Color(4286151551),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413680),
      inverseOnSurface: Color(4294242543),
      inversePrimary: Color(4288924159),
      primaryFixed: Color(4282677172),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280770201),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284315291),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282670465),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285429120),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283784295),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292729305),
      surfaceBright: Color(4294768888),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439922),
      surfaceContainer: Color(4294045164),
      surfaceContainerHigh: Color(4293650407),
      surfaceContainerHighest: Color(4293255905),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278199108),
      surfaceTint: Color(4280967324),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278207612),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278197305),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4280433758),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279968556),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282139470),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301891),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294572543),
      onBackground: Color(4279835680),
      surface: Color(4294768888),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292993767),
      onSurfaceVariant: Color(4280427560),
      outline: Color(4282467143),
      outlineVariant: Color(4282467143),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413680),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4293127423),
      primaryFixed: Color(4278207612),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278201686),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4280960102),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4279315790),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282139470),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4280692023),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292729305),
      surfaceBright: Color(4294768888),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294439922),
      surfaceContainer: Color(4294045164),
      surfaceContainerHigh: Color(4293650407),
      surfaceContainerHighest: Color(4293255905),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4288924159),
      surfaceTint: Color(4288924159),
      onPrimary: Color(4278202716),
      primaryContainer: Color(4281624741),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4289710321),
      onSecondary: Color(4279644498),
      secondaryContainer: Color(4278527045),
      onSecondaryContainer: Color(4288131288),
      tertiary: Color(4294967295),
      onTertiary: Color(4280955195),
      tertiaryContainer: Color(4291745250),
      onTertiaryContainer: Color(4281942090),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4292360241),
      onErrorContainer: Color(4294967295),
      background: Color(4279309079),
      onBackground: Color(4293059304),
      surface: Color(4279505683),
      onSurface: Color(4293255905),
      surfaceVariant: Color(4282664779),
      onSurfaceVariant: Color(4291151563),
      outline: Color(4287598998),
      outlineVariant: Color(4282664779),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255905),
      inverseOnSurface: Color(4281413680),
      inversePrimary: Color(4280967324),
      primaryFixed: Color(4292076543),
      onPrimaryFixed: Color(4278197305),
      primaryFixedDim: Color(4288924159),
      onPrimaryFixedVariant: Color(4278208642),
      secondaryFixed: Color(4292142079),
      onSecondaryFixed: Color(4278197306),
      secondaryFixedDim: Color(4289710321),
      onSecondaryFixedVariant: Color(4281288810),
      tertiaryFixed: Color(4292666352),
      onTertiaryFixed: Color(4279573541),
      tertiaryFixedDim: Color(4290824147),
      onTertiaryFixedVariant: Color(4282402642),
      surfaceDim: Color(4279505683),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4280032027),
      surfaceContainer: Color(4280295199),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281676852),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4289449471),
      surfaceTint: Color(4288924159),
      onPrimary: Color(4278196016),
      primaryContainer: Color(4284650450),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4289973493),
      onSecondary: Color(4278196017),
      secondaryContainer: Color(4286157497),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294967295),
      onTertiary: Color(4280955195),
      tertiaryContainer: Color(4291745250),
      onTertiaryContainer: Color(4279836713),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279309079),
      onBackground: Color(4293059304),
      surface: Color(4279505683),
      onSurface: Color(4294900473),
      surfaceVariant: Color(4282664779),
      onSurfaceVariant: Color(4291414736),
      outline: Color(4288783272),
      outlineVariant: Color(4286677896),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255905),
      inverseOnSurface: Color(4281018922),
      inversePrimary: Color(4278405508),
      primaryFixed: Color(4292076543),
      onPrimaryFixed: Color(4278194727),
      primaryFixedDim: Color(4288924159),
      onPrimaryFixedVariant: Color(4278204262),
      secondaryFixed: Color(4292142079),
      onSecondaryFixed: Color(4278194472),
      secondaryFixedDim: Color(4289710321),
      onSecondaryFixedVariant: Color(4280104792),
      tertiaryFixed: Color(4292666352),
      onTertiaryFixed: Color(4278850074),
      tertiaryFixedDim: Color(4290824147),
      onTertiaryFixedVariant: Color(4281284417),
      surfaceDim: Color(4279505683),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4280032027),
      surfaceContainer: Color(4280295199),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281676852),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294703871),
      surfaceTint: Color(4288924159),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4289449471),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294703871),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4289973493),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294967295),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291745250),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279309079),
      onBackground: Color(4293059304),
      surface: Color(4279505683),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282664779),
      onSurfaceVariant: Color(4294638335),
      outline: Color(4291414736),
      outlineVariant: Color(4291414736),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255905),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4278201169),
      primaryFixed: Color(4292536575),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4289449471),
      onPrimaryFixedVariant: Color(4278196016),
      secondaryFixed: Color(4292601855),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4289973493),
      onSecondaryFixedVariant: Color(4278196017),
      tertiaryFixed: Color(4292929524),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291087320),
      onTertiaryFixedVariant: Color(4279244576),
      surfaceDim: Color(4279505683),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111182),
      surfaceContainerLow: Color(4280032027),
      surfaceContainer: Color(4280295199),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281676852),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary, 
    required this.surfaceTint, 
    required this.onPrimary, 
    required this.primaryContainer, 
    required this.onPrimaryContainer, 
    required this.secondary, 
    required this.onSecondary, 
    required this.secondaryContainer, 
    required this.onSecondaryContainer, 
    required this.tertiary, 
    required this.onTertiary, 
    required this.tertiaryContainer, 
    required this.onTertiaryContainer, 
    required this.error, 
    required this.onError, 
    required this.errorContainer, 
    required this.onErrorContainer, 
    required this.background, 
    required this.onBackground, 
    required this.surface, 
    required this.onSurface, 
    required this.surfaceVariant, 
    required this.onSurfaceVariant, 
    required this.outline, 
    required this.outlineVariant, 
    required this.shadow, 
    required this.scrim, 
    required this.inverseSurface, 
    required this.inverseOnSurface, 
    required this.inversePrimary, 
    required this.primaryFixed, 
    required this.onPrimaryFixed, 
    required this.primaryFixedDim, 
    required this.onPrimaryFixedVariant, 
    required this.secondaryFixed, 
    required this.onSecondaryFixed, 
    required this.secondaryFixedDim, 
    required this.onSecondaryFixedVariant, 
    required this.tertiaryFixed, 
    required this.onTertiaryFixed, 
    required this.tertiaryFixedDim, 
    required this.onTertiaryFixedVariant, 
    required this.surfaceDim, 
    required this.surfaceBright, 
    required this.surfaceContainerLowest, 
    required this.surfaceContainerLow, 
    required this.surfaceContainer, 
    required this.surfaceContainerHigh, 
    required this.surfaceContainerHighest, 
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
