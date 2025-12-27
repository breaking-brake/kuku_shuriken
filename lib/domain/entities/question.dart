/// 九九の問題を表すエンティティ
/// Domain層に配置（フレームワーク非依存）
class Question {
  /// 掛ける数（2-9）
  final int multiplicand;

  /// 掛けられる数（2-9）
  final int multiplier;

  /// 正解
  int get answer => multiplicand * multiplier;

  /// 問題の表示文字列
  String get displayText => '$multiplicand × $multiplier';

  const Question({
    required this.multiplicand,
    required this.multiplier,
  });
}
