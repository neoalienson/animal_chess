// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get animalChess => '동물 체스';

  @override
  String get appDescription => '고전 중국 보드 게임 동물 체스(鬥獸棋)의 Flutter 구현.';

  @override
  String get newGame => '새 게임';

  @override
  String get gameInstructions => '게임 방법';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get about => '정보';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get cancel => '취소';

  @override
  String get gameRules => '게임 규칙';

  @override
  String get gameVariants => '게임 변형';

  @override
  String get resetGame => '게임 재설정';

  @override
  String get greenPlayer => '녹색 플레이어';

  @override
  String get redPlayer => '빨간색 플레이어';

  @override
  String gameOverWins(Object player) {
    return '게임 종료! $player 승리!';
  }

  @override
  String get gameOverDraw => '게임 종료! 무승부!';

  @override
  String turn(Object player) {
    return '$player의 차례';
  }

  @override
  String get gameRule1 => '각 플레이어는 다른 등급의 동물 8마리를 지휘합니다.';

  @override
  String get gameRule2 => '목표: 상대방의 굴에 말을 이동시키거나 상대방의 말을 모두 잡는 것입니다.';

  @override
  String get gameRule3 => '말은 상하좌우로 한 칸씩 움직입니다.';

  @override
  String get gameRule4 => '쥐만 강에 들어갈 수 있습니다.';

  @override
  String get gameRule5 => '사자와 호랑이는 강을 뛰어넘을 수 있습니다.';

  @override
  String get gameRule6 => '덫에 갇힌 말은 상대방의 어떤 말이라도 잡을 수 있습니다.';

  @override
  String get gameRule7 => '말은 자신과 같거나 낮은 등급의 상대방 말을 잡을 수 있습니다.';

  @override
  String get gameRule8 => '예외: 쥐는 코끼리를 잡을 수 있고, 코끼리는 쥐를 잡을 수 있습니다.';

  @override
  String get close => '닫기';

  @override
  String get ratOnlyDenEntry => '쥐만 굴에 들어갈 수 있음';

  @override
  String get extendedLionTigerJumps => '확장된 사자/호랑이 점프';

  @override
  String get dogRiverVariant => '개 강 변형';

  @override
  String get ratCannotCaptureElephant => '쥐는 코끼리를 잡을 수 없습니다';

  @override
  String get variantRatOnlyDenEntry => '쥐만 상대방의 굴에 들어가 승리할 수 있습니다';

  @override
  String get variantExtendedLionTigerJumps => '확장된 사자/호랑이 점프:';

  @override
  String get variantLionJumpBothRivers => '사자는 두 강을 모두 뛰어넘을 수 있습니다';

  @override
  String get variantTigerJumpSingleRiver => '호랑이는 단일 강을 뛰어넘을 수 있습니다';

  @override
  String get variantLeopardCrossRivers => '표범은 강을 수평으로 건널 수 있습니다';

  @override
  String get variantDogRiver => '개 강 변형:';

  @override
  String get variantDogEnterRiver => '개는 강에 들어갈 수 있습니다.';

  @override
  String get variantDogCaptureFromRiver => '개만이 강에서 해안의 말을 잡을 수 있습니다';

  @override
  String get piecesRank => '말의 등급';
}
