// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get animalChess => '斗兽棋';

  @override
  String get appDescription => '经典中国棋盘游戏斗兽棋的Flutter实现。';

  @override
  String get newGame => '新游戏';

  @override
  String get gameInstructions => '游戏说明';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get about => '关于';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get cancel => '取消';

  @override
  String get gameRules => '游戏规则';

  @override
  String get gameVariants => '游戏变体';

  @override
  String get resetGame => '重置游戏';

  @override
  String get greenPlayer => '绿方玩家';

  @override
  String get redPlayer => '红方玩家';

  @override
  String gameOverWins(Object player) {
    return '游戏结束！$player获胜！';
  }

  @override
  String get gameOverDraw => '游戏结束！平局！';

  @override
  String turn(Object player) {
    return '$player的回合';
  }

  @override
  String get gameRule1 => '每位玩家指挥8只不同等级的动物。';

  @override
  String get gameRule2 => '目标：将任何棋子移入对方兽穴或捕获所有对方棋子。';

  @override
  String get gameRule3 => '棋子可向上、下、左、右移动一格。';

  @override
  String get gameRule4 => '只有老鼠可以进入河流。';

  @override
  String get gameRule5 => '狮子和老虎可以跳过两条河流。';

  @override
  String get gameRule6 => '在陷阱中的棋子可被任何对手棋子捕获。';

  @override
  String get gameRule7 => '棋子可以捕获等级相同或较低的对手棋子。';

  @override
  String get gameRule8 => '例外：老鼠可以捕获大象，大象可以捕获老鼠。';

  @override
  String get close => '关闭';

  @override
  String get ratOnlyDenEntry => '只有老鼠可以进入兽穴';

  @override
  String get extendedLionTigerJumps => '狮虎跳跃扩展';

  @override
  String get dogRiverVariant => '狗入河变体';

  @override
  String get ratCannotCaptureElephant => '老鼠不能捕获大象';

  @override
  String get variantRatOnlyDenEntry => '只有老鼠可以进入对手兽穴获胜';

  @override
  String get variantExtendedLionTigerJumps => '狮虎跳跃扩展：';

  @override
  String get variantLionJumpBothRivers => '狮子可以跳过两条河流';

  @override
  String get variantTigerJumpSingleRiver => '老虎可以跳过一条河流';

  @override
  String get variantLeopardCrossRivers => '豹可以横向过河';

  @override
  String get variantDogRiver => '狗入河变体：';

  @override
  String get variantDogEnterRiver => '狗可以进入河流。';

  @override
  String get variantDogCaptureFromRiver => '只有狗可以在河中捕获岸上的棋子';

  @override
  String get piecesRank => '棋子等级';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get animalChess => '鬥獸棋';

  @override
  String get appDescription => '經典中國棋盤遊戲鬥獸棋的Flutter實現。';

  @override
  String get newGame => '新遊戲';

  @override
  String get gameInstructions => '遊戲說明';

  @override
  String get settings => '設定';

  @override
  String get language => '語言';

  @override
  String get about => '關於';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get cancel => '取消';

  @override
  String get gameRules => '遊戲規則';

  @override
  String get gameVariants => '遊戲變體';

  @override
  String get resetGame => '重置遊戲';

  @override
  String get greenPlayer => '綠方玩家';

  @override
  String get redPlayer => '紅方玩家';

  @override
  String gameOverWins(Object player) {
    return '遊戲結束！$player獲勝！';
  }

  @override
  String get gameOverDraw => '遊戲結束！平局！';

  @override
  String turn(Object player) {
    return '$player的回合';
  }

  @override
  String get gameRule1 => '每位玩家指揮8隻不同等級的動物。';

  @override
  String get gameRule2 => '目標：將任何棋子移入對方獸穴或捕獲所有對方棋子。';

  @override
  String get gameRule3 => '棋子可向上、下、左、右移動一格。';

  @override
  String get gameRule4 => '只有老鼠可以進入河流。';

  @override
  String get gameRule5 => '獅子和老虎可以跳過河流。';

  @override
  String get gameRule6 => '在陷阱中的棋子可被任何對手棋子捕獲。';

  @override
  String get gameRule7 => '棋子可以捕獲等級相同或較低的對手棋子。';

  @override
  String get gameRule8 => '例外：老鼠可以捕獲大象，大象可以捕獲老鼠。';

  @override
  String get close => '關閉';

  @override
  String get ratOnlyDenEntry => '只有老鼠可以進入獸穴';

  @override
  String get extendedLionTigerJumps => '獅虎跳躍擴展';

  @override
  String get dogRiverVariant => '狗入河變體';

  @override
  String get ratCannotCaptureElephant => '老鼠不能捕獲大象';

  @override
  String get variantRatOnlyDenEntry => '只有老鼠可以進入對手獸穴獲勝';

  @override
  String get variantExtendedLionTigerJumps => '獅虎跳躍擴展：';

  @override
  String get variantLionJumpBothRivers => '獅子可以跳過兩條河流';

  @override
  String get variantTigerJumpSingleRiver => '老虎可以跳過一條河流';

  @override
  String get variantLeopardCrossRivers => '豹可以橫向過河';

  @override
  String get variantDogRiver => '狗入河變體：';

  @override
  String get variantDogEnterRiver => '狗可以進入河流。';

  @override
  String get variantDogCaptureFromRiver => '只有狗可以在河中捕獲岸上的棋子';

  @override
  String get piecesRank => '棋子等級';
}
