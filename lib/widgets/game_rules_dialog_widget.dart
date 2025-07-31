import 'package:flutter/material.dart';
import 'package:animal_chess/main.dart';

class GameRulesDialogWidget extends StatelessWidget {
  final Language currentLanguage;

  const GameRulesDialogWidget({super.key, required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AnimalChessApp.getLocalizedString(
          'Game Rules',
          '遊戲規則',
          '游戏规则',
          'ゲームルール',
          '게임 규칙',
          'กฎของเกม',
          'Règles du jeu',
          'Reglas del juego',
          'Regras do Jogo',
          'Spielregeln',
          currentLanguage,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AnimalChessApp.getLocalizedString(
                'Animal Chess is a strategic board game for two players.',
                '鬥獸棋是兩人對弈的戰略棋盤遊戲。',
                '斗兽棋是两人对弈的战略棋盘游戏。',
                '動物チェスは2人用の戦略ボードゲームです。',
                '동물 체스는 두 명의 플레이어를 위한 전략 보드 게임입니다.',
                'หมากรุกสัตว์เป็นเกมกระดานกลยุทธ์สำหรับผู้เล่นสองคน',
                'Animal Chess est un jeu de société stratégique pour deux joueurs.',
                'El Ajedrez Animal es un juego de mesa estratégico para dos jugadores.',
                'Xadrez Animal é um jogo de tabuleiro estratégico para dois jogadores.',
                'Tier Schach ist ein strategisches Brettspiel für zwei Spieler.',
                currentLanguage,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AnimalChessApp.getLocalizedString(
                '1. Each player commands 8 animals with different ranks.',
                '1. 每位玩家指揮8隻不同等級的動物。',
                '1. 每位玩家指挥8只不同等级的动物。',
                '1. 各プレイヤーは異なるランクの8匹の動物を指揮します。',
                '1. 각 플레이어는 다른 등급의 동물 8마리를 지휘합니다.',
                '1. ผู้เล่นแต่ละคนควบคุมสัตว์ 8 ตัวที่มีอันดับต่างกัน',
                '1. Chaque joueur commande 8 animaux de rangs différents.',
                '1. Cada jugador comanda 8 animales con diferentes rangos.',
                '1. Cada jogador comanda 8 animais com diferentes patentes.',
                '1. Jeder Spieler befehligt 8 Tiere mit unterschiedlichen Rängen.',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                "2. Objective: Move any piece into opponent's den or capture all opponent pieces.",
                '2. 目標：將任何棋子移入對方獸穴或捕獲所有對方棋子。',
                '2. 目标：将任何棋子移入对方兽穴或捕获所有对方棋子。',
                '2. 目的：相手の巣穴に駒を進めるか、相手の駒をすべて捕獲する。',
                '2. 목표: 상대방의 굴에 말을 이동시키거나 상대방의 말을 모두 잡는 것입니다.',
                '2. วัตถุประสงค์: ย้ายหมากตัวใดตัวหนึ่งเข้าไปในรังของคู่ต่อสู้ หรือจับหมากของคู่ต่อสู้ทั้งหมด',
                "2. Objectif: Déplacer une pièce dans le repaire de l'adversaire ou capturer toutes les pièces adverses.",
                '2. Objetivo: Mover cualquier pieza al den del oponente o capturar todas las piezas del oponente.',
                '2. Objetivo: Mover qualquer peça para a toca do oponente ou capturar todas as peças do oponente.',
                '2. Ziel: Eine Figur in die Höhle des Gegners bewegen oder alle gegnerischen Figuren schlagen.',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '3. Pieces move one space orthogonally (up, down, left, or right).',
                '3. 棋子可向上、下、左、右移動一格。',
                '3. 棋子可向上、下、左、右移动一格。',
                '3. 駒は縦横に1マス移動します。',
                '3. 말은 상하좌우로 한 칸씩 움직입니다.',
                '3. หมากเคลื่อนที่ได้หนึ่งช่องในแนวตั้ง (ขึ้น, ลง, ซ้าย, หรือขวา)',
                '3. Les pièces se déplacent d\'une case orthogonalement (haut, bas, gauche ou droite).',
                '3. Las piezas se mueven una casilla ortogonalmente (arriba, abajo, izquierda o derecha).',
                '3. As peças movem-se uma casa ortogonalmente (para cima, para baixo, para a esquerda ou para a direita).',
                '3. Figuren bewegen sich ein Feld orthogonal (hoch, runter, links oder rechts).',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '4. Only the Rat can enter the river.',
                '4. 只有老鼠可以進入河流。',
                '4. 只有老鼠可以进入河流。',
                '4. ネズミだけが川に入ることができます。',
                '4. 쥐만 강에 들어갈 수 있습니다.',
                '4. หนูเท่านั้นที่สามารถลงแม่น้ำได้',
                '4. Seul le Rat peut entrer dans la rivière.',
                '4. Solo la Rata puede entrar al río.',
                '4. Apenas o Rato pode entrar no rio.',
                '4. Nur die Ratte darf den Fluss betreten.',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '5. Lion and Tiger can jump over rivers.',
                '5. 獅子和老虎可以跳過河流。',
                '5. 狮子和老虎可以跳过两条河流。',
                '5. ライオンとトラは川を飛び越えることができます。',
                '5. 사자와 호랑이는 강을 뛰어넘을 수 있습니다.',
                '5. สิงโตและเสือสามารถกระโดดข้ามแม่น้ำทั้งสองได้',
                '5. Le Lion et le Tigre peuvent sauter par-dessus les rivières.',
                '5. El León y el Tigre pueden saltar sobre ambos ríos.',
                '5. O Leão e o Tigre podem saltar sobre ambos os rios.',
                '5. Löwe und Tiger können über beide Flüsse springen.',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '6. Pieces in traps can be captured by any opponent piece.',
                '6. 在陷阱中的棋子可被任何對手棋子捕獲。',
                '6. 在陷阱中的棋子可被任何对手棋子捕获。',
                '6. 罠の中の駒は、相手のどの駒でも捕獲できます。',
                '6. 덫에 갇힌 말은 상대방의 어떤 말이라도 잡을 수 있습니다.',
                '6. หมากในกับดักสามารถถูกจับได้โดยหมากของคู่ต่อสู้',
                '6. Les pièces dans les pièges peuvent être capturées par n\'importe quelle pièce adverse.',
                '6. Las piezas en trampas pueden ser capturadas por cualquier pieza oponente.',
                '6. Peças em armadilhas podem ser capturadas por qualquer peça adversária.',
                '6. Figuren in Fallen können von jeder gegnerischen Figur geschlagen werden.',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '7. A piece can capture an opponent\'s piece if it is of equal or lower rank.',
                '7. 棋子可以捕獲等級相同或較低的對手棋子。',
                '7. 棋子可以捕获等级相同或较低的对手棋子。',
                '7. 駒は、同等またはそれ以下のランクの相手の駒を捕獲できます。',
                '7. 말은 자신과 같거나 낮은 등급의 상대방 말을 잡을 수 있습니다.',
                '7. หมากสามารถจับหมากของคู่ต่อสู้ได้หากมีอันดับเท่ากันหรือต่ำกว่า',
                '7. Une pièce peut capturer une pièce adverse si elle est de rang égal ou inférieur.',
                '7. Las piezas en trampas pueden ser capturadas por cualquier pieza oponente.',
                '7. Uma peça pode capturar uma peça do oponente se for de patente igual ou inferior.',
                '7. Eine Figur kann eine gegnerische Figur schlagen, wenn sie gleich oder niedriger im Rang ist.',
                currentLanguage,
              ),
            ),
            Text(
              AnimalChessApp.getLocalizedString(
                '8. Exception: Rat can capture Elephant, and Elephant can capture Rat.',
                '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。',
                '8. 例外：老鼠可以捕獲大象，大象可以捕獲老鼠。',
                '8. 例外：ネズミはゾウを捕獲でき、ゾウはネズミを捕獲できます。',
                '8. 예외: 쥐는 코끼리를 잡을 수 있고, 코끼리는 쥐를 잡을 수 있습니다.',
                '8. ข้อยกเว้น: หนูจับช้างได้ และช้างจับหนูได้',
                '8. Exception: Le rat peut capturer l\'éléphant, et l\'éléphant peut capturer le rat.',
                '8. Excepción: La rata puede capturar al elefante, y el elefante puede capturar a la rata.',
                '8. Exceção: O Rato pode capturar o Elefante, e o Elefante pode capturar o Rato.',
                '8. Ausnahme: Ratte kann Elefant schlagen, und Elefant kann Ratte schlagen.',
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
