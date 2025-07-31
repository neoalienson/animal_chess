import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('th'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @animalChess.
  ///
  /// In en, this message translates to:
  /// **'Animal Chess'**
  String get animalChess;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).'**
  String get appDescription;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @gameInstructions.
  ///
  /// In en, this message translates to:
  /// **'Game Instructions'**
  String get gameInstructions;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @gameRules.
  ///
  /// In en, this message translates to:
  /// **'Game Rules'**
  String get gameRules;

  /// No description provided for @gameVariants.
  ///
  /// In en, this message translates to:
  /// **'Game Variants'**
  String get gameVariants;

  /// No description provided for @resetGame.
  ///
  /// In en, this message translates to:
  /// **'Reset Game'**
  String get resetGame;

  /// No description provided for @greenPlayer.
  ///
  /// In en, this message translates to:
  /// **'Green Player'**
  String get greenPlayer;

  /// No description provided for @redPlayer.
  ///
  /// In en, this message translates to:
  /// **'Red Player'**
  String get redPlayer;

  /// No description provided for @gameOverWins.
  ///
  /// In en, this message translates to:
  /// **'Game Over! {player} wins!'**
  String gameOverWins(Object player);

  /// No description provided for @gameOverDraw.
  ///
  /// In en, this message translates to:
  /// **'Game Over! It\'s a draw!'**
  String get gameOverDraw;

  /// No description provided for @turn.
  ///
  /// In en, this message translates to:
  /// **'{player}\'s turn'**
  String turn(Object player);

  /// No description provided for @gameRule1.
  ///
  /// In en, this message translates to:
  /// **'Each player commands 8 animals with different ranks.'**
  String get gameRule1;

  /// No description provided for @gameRule2.
  ///
  /// In en, this message translates to:
  /// **'Objective: Move any piece into opponent\'s den or capture all opponent pieces.'**
  String get gameRule2;

  /// No description provided for @gameRule3.
  ///
  /// In en, this message translates to:
  /// **'Pieces move one space orthogonally (up, down, left, or right).'**
  String get gameRule3;

  /// No description provided for @gameRule4.
  ///
  /// In en, this message translates to:
  /// **'Only the Rat can enter the river.'**
  String get gameRule4;

  /// No description provided for @gameRule5.
  ///
  /// In en, this message translates to:
  /// **'Lion and Tiger can jump over rivers.'**
  String get gameRule5;

  /// No description provided for @gameRule6.
  ///
  /// In en, this message translates to:
  /// **'Pieces in traps can be captured by any opponent piece.'**
  String get gameRule6;

  /// No description provided for @gameRule7.
  ///
  /// In en, this message translates to:
  /// **'A piece can capture an opponent\'s piece if it is of equal or lower rank.'**
  String get gameRule7;

  /// No description provided for @gameRule8.
  ///
  /// In en, this message translates to:
  /// **'Exception: Rat can capture Elephant, and Elephant can capture Rat.'**
  String get gameRule8;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ratOnlyDenEntry.
  ///
  /// In en, this message translates to:
  /// **'Rat-Only Den Entry'**
  String get ratOnlyDenEntry;

  /// No description provided for @extendedLionTigerJumps.
  ///
  /// In en, this message translates to:
  /// **'Extended Lion/Tiger Jumps'**
  String get extendedLionTigerJumps;

  /// No description provided for @dogRiverVariant.
  ///
  /// In en, this message translates to:
  /// **'Dog River Variant'**
  String get dogRiverVariant;

  /// No description provided for @ratCannotCaptureElephant.
  ///
  /// In en, this message translates to:
  /// **'Rat cannot capture Elephant'**
  String get ratCannotCaptureElephant;

  /// No description provided for @variantRatOnlyDenEntry.
  ///
  /// In en, this message translates to:
  /// **'Only the Rat can enter the opponent\'s den to win'**
  String get variantRatOnlyDenEntry;

  /// No description provided for @variantExtendedLionTigerJumps.
  ///
  /// In en, this message translates to:
  /// **'Extended Lion/Tiger Jumps:'**
  String get variantExtendedLionTigerJumps;

  /// No description provided for @variantLionJumpBothRivers.
  ///
  /// In en, this message translates to:
  /// **'Lion can jump over both rivers'**
  String get variantLionJumpBothRivers;

  /// No description provided for @variantTigerJumpSingleRiver.
  ///
  /// In en, this message translates to:
  /// **'Tiger can jump over a single river'**
  String get variantTigerJumpSingleRiver;

  /// No description provided for @variantLeopardCrossRivers.
  ///
  /// In en, this message translates to:
  /// **'Leopard can cross rivers horizontally'**
  String get variantLeopardCrossRivers;

  /// No description provided for @variantDogRiver.
  ///
  /// In en, this message translates to:
  /// **'Dog River Variant:'**
  String get variantDogRiver;

  /// No description provided for @variantDogEnterRiver.
  ///
  /// In en, this message translates to:
  /// **'Dog can enter the river'**
  String get variantDogEnterRiver;

  /// No description provided for @variantDogCaptureFromRiver.
  ///
  /// In en, this message translates to:
  /// **'Only the Dog can capture pieces on the shore from within the river'**
  String get variantDogCaptureFromRiver;

  /// No description provided for @piecesRank.
  ///
  /// In en, this message translates to:
  /// **'Pieces Rank'**
  String get piecesRank;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'pt',
    'th',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
