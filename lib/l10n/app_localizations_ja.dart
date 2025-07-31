// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get animalChess => '動物チェス';

  @override
  String get appDescription => '古典的な中国のボードゲーム「動物チェス（鬥獸棋）」のFlutter実装。';

  @override
  String get newGame => '新しいゲーム';

  @override
  String get gameInstructions => 'ゲームの遊び方';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get about => 'について';

  @override
  String get selectLanguage => '言語選択';

  @override
  String get cancel => 'キャンセル';

  @override
  String get gameRules => 'ゲームルール';

  @override
  String get gameVariants => 'ゲームバリアント';

  @override
  String get resetGame => 'ゲームをリセット';

  @override
  String get greenPlayer => '緑のプレイヤー';

  @override
  String get redPlayer => '赤のプレイヤー';

  @override
  String gameOverWins(Object player) {
    return 'ゲームオーバー！$playerの勝ち！';
  }

  @override
  String get gameOverDraw => 'ゲームオーバー！引き分け！';

  @override
  String turn(Object player) {
    return '$playerのターン';
  }

  @override
  String get gameRule1 => '各プレイヤーは異なるランクの8匹の動物を指揮します。';

  @override
  String get gameRule2 => '目的：相手の巣穴に駒を進めるか、相手の駒をすべて捕獲する。';

  @override
  String get gameRule3 => '駒は縦横に1マス移動します。';

  @override
  String get gameRule4 => 'ネズミだけが川に入ることができます。';

  @override
  String get gameRule5 => 'ライオンとトラは川を飛び越えることができます。';

  @override
  String get gameRule6 => '罠の中の駒は、相手のどの駒でも捕獲できます。';

  @override
  String get gameRule7 => '駒は、同等またはそれ以下のランクの相手の駒を捕獲できます。';

  @override
  String get gameRule8 => '例外：ネズミはゾウを捕獲でき、ゾウはネズミを捕獲できます。';

  @override
  String get close => '閉じる';

  @override
  String get ratOnlyDenEntry => 'ネズミのみの巣穴侵入';

  @override
  String get extendedLionTigerJumps => '拡張ライオン/トラのジャンプ';

  @override
  String get dogRiverVariant => '犬の川のバリアント';

  @override
  String get ratCannotCaptureElephant => 'ネズミはゾウを捕獲できません';

  @override
  String get variantRatOnlyDenEntry => 'ネズミだけが相手の巣穴に入って勝つことができます';

  @override
  String get variantExtendedLionTigerJumps => '拡張ライオン/トラのジャンプ：';

  @override
  String get variantLionJumpBothRivers => 'ライオンは両方の川を飛び越えることができます';

  @override
  String get variantTigerJumpSingleRiver => 'トラは単一の川を飛び越えることができます';

  @override
  String get variantLeopardCrossRivers => 'ヒョウは川を水平に渡ることができます';

  @override
  String get variantDogRiver => '犬の川のバリアント：';

  @override
  String get variantDogEnterRiver => '犬は川に入ることができます。';

  @override
  String get variantDogCaptureFromRiver => '犬だけが川の中から岸の駒を捕獲できます';

  @override
  String get piecesRank => '駒のランク';
}
