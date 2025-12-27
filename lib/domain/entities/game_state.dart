import 'difficulty.dart';
import 'question.dart';
import 'target.dart';

/// ゲームセッションの状態を表すエンティティ
class GameState {
  /// 選択された難易度
  final Difficulty difficulty;

  /// 現在の問題インデックス（0-9）
  final int currentQuestionIndex;

  /// 全問題リスト
  final List<Question> questions;

  /// 現在の問題に対する的のリスト
  final List<Target> currentTargets;

  /// 正答数
  final int correctCount;

  /// 現在の連続正解数
  final int currentStreak;

  /// 最大連続正解数
  final int maxStreak;

  /// ゲーム終了フラグ
  bool get isGameOver => currentQuestionIndex >= questions.length;

  /// 現在の問題
  Question? get currentQuestion =>
      isGameOver ? null : questions[currentQuestionIndex];

  /// 正答率（パーセント）
  double get accuracy =>
      currentQuestionIndex == 0 ? 0 : correctCount / currentQuestionIndex * 100;

  const GameState({
    required this.difficulty,
    required this.currentQuestionIndex,
    required this.questions,
    required this.currentTargets,
    required this.correctCount,
    required this.currentStreak,
    required this.maxStreak,
  });

  /// 初期状態を作成
  factory GameState.initial(Difficulty difficulty, List<Question> questions) {
    return GameState(
      difficulty: difficulty,
      currentQuestionIndex: 0,
      questions: questions,
      currentTargets: [],
      correctCount: 0,
      currentStreak: 0,
      maxStreak: 0,
    );
  }

  /// 状態をコピーして新しい状態を作成
  GameState copyWith({
    Difficulty? difficulty,
    int? currentQuestionIndex,
    List<Question>? questions,
    List<Target>? currentTargets,
    int? correctCount,
    int? currentStreak,
    int? maxStreak,
  }) {
    return GameState(
      difficulty: difficulty ?? this.difficulty,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      questions: questions ?? this.questions,
      currentTargets: currentTargets ?? this.currentTargets,
      correctCount: correctCount ?? this.correctCount,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
    );
  }
}
