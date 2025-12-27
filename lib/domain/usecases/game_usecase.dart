import 'dart:math';

import '../entities/difficulty.dart';
import '../entities/game_result.dart';
import '../entities/game_state.dart';
import '../entities/question.dart';
import '../entities/swipe_direction.dart';
import '../entities/target.dart';

/// ゲームロジックを提供するユースケース
abstract class GameUseCase {
  /// 新しいゲームセッションを開始
  GameState startGame(Difficulty difficulty);

  /// 指定された問題に対する的のリストを生成
  List<Target> generateTargets(Question question, Difficulty difficulty);

  /// スワイプ方向に基づいて回答を判定
  GameState processAnswer(GameState state, SwipeDirection direction);

  /// ゲーム結果を生成
  GameResult getResult(GameState state);
}

/// GameUseCaseの実装
class GameUseCaseImpl implements GameUseCase {
  final Random _random;

  GameUseCaseImpl({Random? random}) : _random = random ?? Random();

  @override
  GameState startGame(Difficulty difficulty) {
    final questions = _generateQuestions();
    final state = GameState.initial(difficulty, questions);
    final targets = generateTargets(state.currentQuestion!, difficulty);
    return state.copyWith(currentTargets: targets);
  }

  /// 10問のランダムな九九問題を生成
  List<Question> _generateQuestions() {
    final questions = <Question>[];
    while (questions.length < 10) {
      final multiplicand = _random.nextInt(8) + 2; // 2-9
      final multiplier = _random.nextInt(8) + 2; // 2-9
      final question = Question(
        multiplicand: multiplicand,
        multiplier: multiplier,
      );
      // 重複を避ける
      if (!questions.any(
        (q) =>
            q.multiplicand == question.multiplicand &&
            q.multiplier == question.multiplier,
      )) {
        questions.add(question);
      }
    }
    return questions;
  }

  @override
  List<Target> generateTargets(Question question, Difficulty difficulty) {
    final correctAnswer = question.answer;
    final directions = List<SwipeDirection>.from(difficulty.directions);

    // 正解の配置方向をランダムに決定
    final correctDirection = directions[_random.nextInt(directions.length)];

    // 不正解の選択肢を生成
    final wrongAnswers = _generateWrongAnswers(
      correctAnswer,
      directions.length - 1,
    );

    // 的のリストを作成
    final targets = <Target>[];
    var wrongIndex = 0;

    for (final direction in directions) {
      if (direction == correctDirection) {
        targets.add(
          Target(value: correctAnswer, direction: direction, isCorrect: true),
        );
      } else {
        targets.add(
          Target(
            value: wrongAnswers[wrongIndex++],
            direction: direction,
            isCorrect: false,
          ),
        );
      }
    }

    return targets;
  }

  /// 正解に近い不正解の選択肢を生成
  List<int> _generateWrongAnswers(int correctAnswer, int count) {
    final wrongAnswers = <int>{};

    // 正解±10の範囲で不正解を生成（ただし正解と同じ値は除外）
    while (wrongAnswers.length < count) {
      final offset = _random.nextInt(21) - 10; // -10 to +10
      final wrongAnswer = correctAnswer + offset;
      if (wrongAnswer > 0 && wrongAnswer != correctAnswer) {
        wrongAnswers.add(wrongAnswer);
      }
    }

    return wrongAnswers.toList();
  }

  @override
  GameState processAnswer(GameState state, SwipeDirection direction) {
    final selectedTarget = state.currentTargets.firstWhere(
      (t) => t.direction == direction,
    );

    final isCorrect = selectedTarget.isCorrect;
    final newStreak = isCorrect ? state.currentStreak + 1 : 0;
    final newMaxStreak = isCorrect
        ? (newStreak > state.maxStreak ? newStreak : state.maxStreak)
        : state.maxStreak;

    final newState = state.copyWith(
      correctCount: isCorrect ? state.correctCount + 1 : state.correctCount,
      currentStreak: newStreak,
      maxStreak: newMaxStreak,
      currentQuestionIndex: state.currentQuestionIndex + 1,
    );

    // 次の問題がある場合は新しい的を生成
    if (!newState.isGameOver) {
      final newTargets = generateTargets(
        newState.currentQuestion!,
        newState.difficulty,
      );
      return newState.copyWith(currentTargets: newTargets);
    }

    return newState;
  }

  @override
  GameResult getResult(GameState state) {
    return GameResult.fromGameState(state);
  }
}
