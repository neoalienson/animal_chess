// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get animalChess => 'หมากรุกสัตว์';

  @override
  String get appDescription =>
      'การนำเกมหมากรุกสัตว์ (鬥獸棋) แบบจีนคลาสสิกมาใช้ใน Flutter';

  @override
  String get newGame => 'เกมใหม่';

  @override
  String get gameInstructions => 'คำแนะนำเกม';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get selectLanguage => 'เลือกภาษา';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get gameRules => 'กฎของเกม';

  @override
  String get gameVariants => 'รูปแบบเกม';

  @override
  String get resetGame => 'รีเซ็ตเกม';

  @override
  String get greenPlayer => 'ผู้เล่นสีเขียว';

  @override
  String get redPlayer => 'ผู้เล่นสีแดง';

  @override
  String gameOverWins(Object player) {
    return 'จบเกม! $player ชนะ!';
  }

  @override
  String get gameOverDraw => 'จบเกม! เสมอ!';

  @override
  String turn(Object player) {
    return 'ตาของ $player';
  }

  @override
  String get gameRule1 => 'ผู้เล่นแต่ละคนควบคุมสัตว์ 8 ตัวที่มีอันดับต่างกัน';

  @override
  String get gameRule2 =>
      'วัตถุประสงค์: ย้ายหมากตัวใดตัวหนึ่งเข้าไปในรังของคู่ต่อสู้ หรือจับหมากของคู่ต่อสู้ทั้งหมด';

  @override
  String get gameRule3 =>
      'หมากเคลื่อนที่ได้หนึ่งช่องในแนวตั้ง (ขึ้น, ลง, ซ้าย, หรือขวา)';

  @override
  String get gameRule4 => 'หนูเท่านั้นที่สามารถลงแม่น้ำได้';

  @override
  String get gameRule5 => 'สิงโตและเสือสามารถกระโดดข้ามแม่น้ำได้';

  @override
  String get gameRule6 => 'หมากในกับดักสามารถถูกจับได้โดยหมากของคู่ต่อสู้';

  @override
  String get gameRule7 =>
      'หมากสามารถจับหมากของคู่ต่อสู้ได้หากมีอันดับเท่ากันหรือต่ำกว่า';

  @override
  String get gameRule8 => 'ข้อยกเว้น: หนูจับช้างได้ และช้างจับหนูได้';

  @override
  String get close => 'ปิด';

  @override
  String get ratOnlyDenEntry => 'หนูเท่านั้นที่เข้าถ้ำได้';

  @override
  String get extendedLionTigerJumps => 'การกระโดดของสิงโต/เสือที่ขยายออกไป';

  @override
  String get dogRiverVariant => 'รูปแบบแม่น้ำสุนัข';

  @override
  String get ratCannotCaptureElephant => 'หนูจับช้างไม่ได้';

  @override
  String get variantRatOnlyDenEntry =>
      'หนูเท่านั้นที่สามารถเข้าถ้ำของคู่ต่อสู้เพื่อชนะได้';

  @override
  String get variantExtendedLionTigerJumps =>
      'การกระโดดของสิงโต/เสือที่ขยายออกไป:';

  @override
  String get variantLionJumpBothRivers =>
      'สิงโตสามารถกระโดดข้ามแม่น้ำทั้งสองได้';

  @override
  String get variantTigerJumpSingleRiver =>
      'เสือสามารถกระโดดข้ามแม่น้ำสายเดียวได้';

  @override
  String get variantLeopardCrossRivers => 'เสือดาวสามารถข้ามแม่น้ำในแนวนอนได้';

  @override
  String get variantDogRiver => 'รูปแบบแม่น้ำสุนัข:';

  @override
  String get variantDogEnterRiver => 'สุนัขสามารถลงแม่น้ำได้';

  @override
  String get variantDogCaptureFromRiver =>
      'สุนัขเท่านั้นที่สามารถจับหมากบนฝั่งจากในแม่น้ำได้';

  @override
  String get piecesRank => 'ระดับหมาก';
}
