import 'package:flutter/material.dart';
import '../main.dart';

class AboutDialogWidget extends StatelessWidget {
  final Language currentLanguage;

  const AboutDialogWidget({super.key, required this.currentLanguage});

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: AnimalChessApp.getLocalizedString(
        'Animal Chess',
        '鬥獸棋',
        '斗兽棋',
        '動物チェス',
        '동물 체스',
        'หมากรุกสัตว์',
        'Échecs Animaux',
        'Ajedrez Animal',
        'Xadrez Animal',
        'Tier Schach',
        currentLanguage,
      ),
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.adb),
      applicationLegalese: '© 2025 Animal Chess',
      children: [
        Text(
          AnimalChessApp.getLocalizedString(
            'A Flutter implementation of the classic Chinese board game Animal Chess (Dou Shou Qi).',
            '經典中國棋盤遊戲鬥獸棋的Flutter實現。',
            '经典中国棋盘游戏斗兽棋的Flutter实现。',
            '古典的な中国のボードゲーム「動物チェス（鬥獸棋）」のFlutter実装。',
            '고전 중국 보드 게임 동물 체스(鬥獸棋)의 Flutter 구현.',
            'การนำเกมหมากรุกสัตว์ (鬥獸棋) แบบจีนคลาสสิกมาใช้ใน Flutter',
            'Une implémentation Flutter du jeu de société chinois classique Animal Chess (Dou Shou Qi).',
            'Una implementación en Flutter del clásico juego de mesa chino Ajedrez Animal (Dou Shou Qi).',
            'Uma implementação Flutter do clássico jogo de tabuleiro chinês Xadrez Animal (Dou Shou Qi).',
            'Eine Flutter-Implementierung des klassischen chinesischen Brettspiels Tier Schach (Dou Shou Qi).',
            currentLanguage,
          ),
        ),
      ],
    );
  }
}
