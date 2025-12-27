import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 手裏剣形状のCustomClipper
/// 4つの刃がある手裏剣シルエットを生成
class ShurikenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 中央の円の半径（問題文を表示するスペース）
    final innerRadius = radius * 0.45;
    // 刃の先端までの距離
    final outerRadius = radius;
    // 刃の根元の幅（角度）
    final bladeBaseAngle = math.pi / 6; // 30度

    // 4つの刃を描画（上、右、下、左）
    for (int i = 0; i < 4; i++) {
      final baseAngle = -math.pi / 2 + (i * math.pi / 2); // 上から開始

      // 刃の先端
      final tipX = center.dx + outerRadius * math.cos(baseAngle);
      final tipY = center.dy + outerRadius * math.sin(baseAngle);

      // 刃の左側の根元
      final leftBaseX =
          center.dx + innerRadius * math.cos(baseAngle - bladeBaseAngle);
      final leftBaseY =
          center.dy + innerRadius * math.sin(baseAngle - bladeBaseAngle);

      // 刃の右側の根元
      final rightBaseX =
          center.dx + innerRadius * math.cos(baseAngle + bladeBaseAngle);
      final rightBaseY =
          center.dy + innerRadius * math.sin(baseAngle + bladeBaseAngle);

      if (i == 0) {
        path.moveTo(leftBaseX, leftBaseY);
      } else {
        path.lineTo(leftBaseX, leftBaseY);
      }
      path.lineTo(tipX, tipY);
      path.lineTo(rightBaseX, rightBaseY);

      // 次の刃の左側根元まで円弧で繋ぐ
      final nextBaseAngle = -math.pi / 2 + ((i + 1) * math.pi / 2);
      final nextLeftBaseX =
          center.dx + innerRadius * math.cos(nextBaseAngle - bladeBaseAngle);
      final nextLeftBaseY =
          center.dy + innerRadius * math.sin(nextBaseAngle - bladeBaseAngle);

      // 円弧で中央部分を繋ぐ
      path.arcToPoint(
        Offset(nextLeftBaseX, nextLeftBaseY),
        radius: Radius.circular(innerRadius),
        clockwise: true,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
