import 'difficulty.dart';
import 'game_state.dart';

/// ゲーム結果を表すエンティティ
class GameResult {
  /// 難易度
  final Difficulty difficulty;

  /// 総問題数
  final int totalQuestions;

  /// 正答数
  final int correctCount;

  /// 最大連続正解数
  final int maxStreak;

  /// 正答率（パーセント）
  double get accuracy => correctCount / totalQuestions * 100;

  const GameResult({
    required this.difficulty,
    required this.totalQuestions,
    required this.correctCount,
    required this.maxStreak,
  });

  /// GameStateから結果を作成
  factory GameResult.fromGameState(GameState state) {
    return GameResult(
      difficulty: state.difficulty,
      totalQuestions: state.questions.length,
      correctCount: state.correctCount,
      maxStreak: state.maxStreak,
    );
  }
}
