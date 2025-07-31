import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/main.dart'; // For Language enum and getLocalizedString

class SettingsDialogWidget extends StatefulWidget {
  final Language currentLanguage;
  final GameConfig gameConfig;
  final Function(GameConfig) onConfigChanged;

  const SettingsDialogWidget({
    super.key,
    required this.currentLanguage,
    required this.gameConfig,
    required this.onConfigChanged,
  });

  @override
  State<SettingsDialogWidget> createState() => _SettingsDialogWidgetState();
}

class _SettingsDialogWidgetState extends State<SettingsDialogWidget> {
  late GameConfig _gameConfig;

  @override
  void initState() {
    super.initState();
    _gameConfig = widget.gameConfig;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(
            AnimalChessApp.getLocalizedString(
              'Game Settings',
              '遊戲設定',
              '游戏设置',
              'ゲーム設定',
              '게임 설정',
              'การตั้งค่าเกม',
              'Paramètres du jeu',
              'Configuración del juego',
              'Configurações do Jogo',
              'Spieleinstellungen',
              widget.currentLanguage,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVariantToggle(
                AnimalChessApp.getLocalizedString(
                  'Rat-Only Den Entry',
                  '只有老鼠可以進入獸穴',
                  '只有老鼠可以进入兽穴',
                  'ネズミのみの巣穴侵入',
                  '쥐만 굴에 들어갈 수 있음',
                  'หนูเท่านั้นที่เข้าถ้ำได้',
                  'Entrée de la tanière réservée aux rats',
                  'Entrada a la guarida solo para ratas',
                  'Entrada da toca apenas para Rato',
                  'Nur Ratten dürfen den Bau betreten',
                  widget.currentLanguage,
                ),
                _gameConfig.ratOnlyDenEntry,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(ratOnlyDenEntry: value);
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
              _buildVariantToggle(
                AnimalChessApp.getLocalizedString(
                  'Extended Lion/Tiger Jumps',
                  '獅虎跳躍擴展',
                  '狮虎跳跃扩展',
                  '拡張ライオン/トラのジャンプ',
                  '확장된 사자/호랑이 점프',
                  'การกระโดดของสิงโต/เสือที่ขยายออกไป',
                  'Sauts étendus Lion/Tigre',
                  'Saltos extendidos de León/Tigre',
                  'Saltos Estendidos de Leão/Tigre',
                  'Erweiterte Löwen-/Tiger-Sprünge',
                  widget.currentLanguage,
                ),
                _gameConfig.extendedLionTigerJumps,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(
                      extendedLionTigerJumps: value,
                    );
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
              _buildVariantToggle(
                AnimalChessApp.getLocalizedString(
                  'Dog River Variant',
                  '狗入河變體',
                  '狗入河变体',
                  '犬の川のバリアント',
                  '개 강 변형',
                  'รูปแบบแม่น้ำสุนัข',
                  'Variante de la rivière du chien',
                  'Variante del río Perro',
                  'Variante do Rio Cão',
                  'Hund-Fluss-Variante',
                  widget.currentLanguage,
                ),
                _gameConfig.dogRiverVariant,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(dogRiverVariant: value);
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
              _buildVariantToggle(
                AnimalChessApp.getLocalizedString(
                  'Rat cannot capture Elephant',
                  '老鼠不能捕獲大象',
                  '老鼠不能捕获大象',
                  'ネズミはゾウを捕獲できません',
                  '쥐는 코끼리를 잡을 수 없습니다',
                  'หนูจับช้างไม่ได้',
                  'Le rat ne peut pas capturer l\'éléphant',
                  'La rata no puede capturar al elefante',
                  'Rato não pode capturar Elefante',
                  'Ratte kann Elefant nicht schlagen',
                  widget.currentLanguage,
                ),
                _gameConfig.ratCannotCaptureElephant,
                (bool value) {
                  setState(() {
                    _gameConfig = _gameConfig.copyWith(
                      ratCannotCaptureElephant: value,
                    );
                  });
                  widget.onConfigChanged(_gameConfig);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AnimalChessApp.getLocalizedString(
                  'Close',
                  '關閉',
                  '关闭',
                  '閉じる',
                  '닫기',
                  'ปิด',
                  'Fermer',
                  'Cerrar',
                  'Fechar',
                  'Schließen',
                  widget.currentLanguage,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVariantToggle(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
