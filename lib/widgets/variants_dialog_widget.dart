import 'package:flutter/material.dart';
import 'package:animal_chess/models/game_config.dart';
import 'package:animal_chess/main.dart'; // For Language enum and getLocalizedString

class VariantsDialogWidget extends StatelessWidget {
  final Language currentLanguage;
  final GameConfig gameConfig;
  final Function(GameConfig) onConfigChanged;

  const VariantsDialogWidget({
    super.key,
    required this.currentLanguage,
    required this.gameConfig,
    required this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AnimalChessApp.getLocalizedString(
          'Game Variants',
          '遊戲變體',
          '游戏变体',
          'ゲームバリアント',
          '게임 변형',
          'รูปแบบเกม',
          'Variantes du jeu',
          'Variantes del juego',
          'Variantes do Jogo',
          'Spielvarianten',
          currentLanguage,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AnimalChessApp.getLocalizedString(
                '1. Rat-Only Den Entry: Only the Rat can enter the opponent\'s den to win',
                '1. 只有老鼠可以進入獸穴：只有老鼠可以進入對手獸穴獲勝',
                '1. 只有老鼠可以进入兽穴：只有老鼠可以进入对手兽穴获胜',
                '1. ネズミのみの巣穴侵入：ネズミだけが相手の巣穴に入って勝つことができます',
                '1. 쥐만 굴에 들어갈 수 있음: 쥐만 상대방의 굴에 들어가 승리할 수 있습니다',
                '1. หนูเท่านั้นที่เข้าถ้ำได้: หนูเท่านั้นที่สามารถเข้าถ้ำของคู่ต่อสู้เพื่อชนะได้',
                '1. Entrée de la tanière réservée aux rats: Seul le Rat peut entrer dans la tanière de l\'adversaire pour gagner',
                '1. Entrada a la guarida solo para ratas: Solo la Rata puede entrar en la guarida del oponente para ganar',
                '1. Entrada da toca apenas para Rato: Apenas o Rato pode entrar na toca do oponente para vencer',
                '1. Nur Ratten dürfen den Bau betreten: Nur die Ratte darf den Bau des Gegners betreten, um zu gewinnen',
                currentLanguage,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AnimalChessApp.getLocalizedString(
                '2. Extended Lion/Tiger Jumps:',
                '2. 獅虎跳躍擴展：',
                '2. 狮虎跳跃扩展：',
                '2. 拡張ライオン/トラのジャンプ：',
                '2. 확장된 사자/호랑이 점프:',
                '2. การกระโดดของสิงโต/เสือที่ขยายออกไป:',
                '2. Sauts étendus Lion/Tigre:',
                '2. Saltos extendidos de León/Tigre:',
                '2. Saltos Estendidos de Leão/Tigre:',
                '2. Erweiterte Löwen-/Tiger-Sprünge:',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '   - Lion can jump over both rivers',
                '   - 獅子可以跳過兩條河流',
                '   - 狮子可以跳过两条河流',
                '   - ライオンは両方の川を飛び越えることができます',
                '   - 사자는 두 강을 모두 뛰어넘을 수 있습니다',
                '   - สิงโตสามารถกระโดดข้ามแม่น้ำทั้งสองได้',
                '   - Le Lion peut sauter par-dessus les deux rivières',
                '   - El León puede saltar sobre ambos ríos',
                '   - O Leão pode saltar sobre ambos os rios',
                '   - Löwe kann über beide Flüsse springen',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '   - Tiger can jump over a single river',
                '   - 老虎可以跳過一條河流',
                '   - 老虎可以跳过一条河流',
                '   - トラは単一の川を飛び越えることができます',
                '   - 호랑이는 단일 강을 뛰어넘을 수 있습니다',
                '   - เสือสามารถกระโดดข้ามแม่น้ำสายเดียวได้',
                '   - Le Tigre peut sauter par-dessus une seule rivière',
                '   - El Tigre puede saltar sobre un solo río',
                '   - O Tigre pode saltar sobre um único rio',
                '   - Tiger kann über einen einzelnen Fluss springen',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '   - Leopard can cross rivers horizontally',
                '   - 豹可以橫向過河',
                '   - 豹可以横向过河',
                '   - ヒョウは川を水平に渡ることができます',
                '   - 표범은 강을 수평으로 건널 수 있습니다',
                '   - เสือดาวสามารถข้ามแม่น้ำในแนวนอนได้',
                '   - Le Léopard peut traverser les rivières horizontalement',
                '   - El Leopardo puede cruzar ríos horizontalmente',
                '   - O Leopardo pode atravessar rios horizontalmente',
                '   - Leopard kann Flüsse horizontal überqueren',
                currentLanguage,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AnimalChessApp.getLocalizedString(
                '3. Dog River Variant:',
                '3. 狗入河變體：',
                '3. 狗入河变体：',
                '3. 犬の川のバリアント：',
                '3. 개 강 변형:',
                '3. รูปแบบแม่น้ำสุนัข:',
                '3. Variante de la rivière du chien:',
                '3. Variante del río Perro:',
                '3. Variante do Rio Cão:',
                '3. Hund-Fluss-Variante:',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '   - Dog can enter the river',
                '   - 狗可以進入河流。',
                '   - 狗可以进入河流。',
                '   - 犬は川に入ることができます。',
                '   - 개는 강에 들어갈 수 있습니다.',
                '   - สุนัขสามารถลงแม่น้ำได้',
                '   - Le Chien peut entrer dans la rivière.',
                '   - El Perro puede entrar al río.',
                '   - O Cão pode entrar no rio.',
                '   - Hund kann den Fluss betreten.',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '   - Only the Dog can capture pieces on the shore from within the river',
                '   - 只有狗可以在河中捕獲岸上的棋子',
                '   - 只有狗可以在河中捕获岸上的棋子',
                '   - 犬だけが川の中から岸の駒を捕獲できます',
                '   - 개만이 강에서 해안의 말을 잡을 수 있습니다',
                '   - สุนัขเท่านั้นที่สามารถจับหมากบนฝั่งจากในแม่น้ำได้',
                '   - Seul le Chien peut capturer des pièces sur le rivage depuis la rivière',
                '   - Solo el Perro puede capturar piezas en la orilla desde dentro del río',
                '   - Apenas o Cão pode capturar peças na margem a partir do rio',
                '   - Nur der Hund kann Figuren am Ufer vom Fluss aus schlagen',
                currentLanguage,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AnimalChessApp.getLocalizedString(
                '4. Rat cannot capture Elephant',
                '4. 老鼠不能捕獲大象',
                '4. 老鼠不能捕獲大象',
                '4. ネズミはゾウを捕獲できません',
                '4. 쥐는 코끼리를 잡을 수 없습니다',
                '4. หนูจับช้างไม่ได้',
                "4. Le rat ne peut pas capturer l'éléphant",
                '4. La rata no puede capturar al elefante',
                '4. Rato não pode capturar Elefante',
                '4. Ratte kann Elefant nicht schlagen',
                currentLanguage,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
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
              currentLanguage,
            ),
          ),
        ),
      ],
    );
  }
}
