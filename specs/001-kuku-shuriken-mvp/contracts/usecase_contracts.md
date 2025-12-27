# ユースケースコントラクト: 九九手裏剣 MVP

**作成日**: 2025-12-27
**ステータス**: 完了

## ユースケース一覧

1. **GameUseCase** - ゲームロジック全般
2. **AudioUseCase** - 効果音再生

---

## 1. GameUseCase

ゲームの問題生成、正解判定、スコア管理を担当するユースケース。

### インターフェース

```dart
/// ゲームロジックを提供するユースケース
abstract class GameUseCase {
  /// 新しいゲームセッションを開始
  /// [difficulty] 選択された難易度
  /// Returns: 初期化されたGameState
  GameState startGame(Difficulty difficulty);

  /// 指定された問題に対する的のリストを生成
  /// [question] 現在の問題
  /// [difficulty] 選択された難易度
  /// Returns: 正解1つと不正解を含む的のリスト
  List<Target> generateTargets(Question question, Difficulty difficulty);

  /// スワイプ方向に基づいて回答を判定
  /// [state] 現在のゲーム状態
  /// [direction] スワイプ方向
  /// Returns: 更新されたGameState
  GameState processAnswer(GameState state, SwipeDirection direction);

  /// ゲーム結果を生成
  /// [state] 終了時のゲーム状態
  /// Returns: ゲーム結果
  GameResult getResult(GameState state);
}
```

### 実装詳細

```dart
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
      final multiplier = _random.nextInt(8) + 2;   // 2-9
      final question = Question(
        multiplicand: multiplicand,
        multiplier: multiplier,
      );
      // 重複を避ける
      if (!questions.any((q) =>
          q.multiplicand == question.multiplicand &&
          q.multiplier == question.multiplier)) {
        questions.add(question);
      }
    }
    return questions;
  }

  @override
  List<Target> generateTargets(Question question, Difficulty difficulty) {
    final correctAnswer = question.answer;
    final directions = difficulty.directions;

    // 正解の配置方向をランダムに決定
    final correctDirection = directions[_random.nextInt(directions.length)];

    // 不正解の選択肢を生成
    final wrongAnswers = _generateWrongAnswers(correctAnswer, directions.length - 1);

    // 的のリストを作成
    final targets = <Target>[];
    var wrongIndex = 0;

    for (final direction in directions) {
      if (direction == correctDirection) {
        targets.add(Target(
          value: correctAnswer,
          direction: direction,
          isCorrect: true,
        ));
      } else {
        targets.add(Target(
          value: wrongAnswers[wrongIndex++],
          direction: direction,
          isCorrect: false,
        ));
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
```

---

## 2. AudioUseCase

効果音の再生を担当するユースケース。

### インターフェース

```dart
/// 効果音再生を提供するユースケース
abstract class AudioUseCase {
  /// 正解時の効果音を再生
  Future<void> playCorrectSound();

  /// 不正解時の効果音を再生
  Future<void> playWrongSound();

  /// リソースを解放
  Future<void> dispose();
}
```

### 実装詳細

```dart
class AudioUseCaseImpl implements AudioUseCase {
  final AudioPlayer _player;

  AudioUseCaseImpl() : _player = AudioPlayer();

  @override
  Future<void> playCorrectSound() async {
    await _player.play(AssetSource('sounds/correct.mp3'));
  }

  @override
  Future<void> playWrongSound() async {
    await _player.play(AssetSource('sounds/wrong.mp3'));
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}
```

### テスト用モック

```dart
/// テスト用のサイレントモック
class MockAudioUseCase implements AudioUseCase {
  bool correctSoundPlayed = false;
  bool wrongSoundPlayed = false;

  @override
  Future<void> playCorrectSound() async {
    correctSoundPlayed = true;
  }

  @override
  Future<void> playWrongSound() async {
    wrongSoundPlayed = true;
  }

  @override
  Future<void> dispose() async {}

  void reset() {
    correctSoundPlayed = false;
    wrongSoundPlayed = false;
  }
}
```

---

## 依存関係図

```
┌─────────────────┐
│   GameScreen    │
└────────┬────────┘
         │
         │ uses
         ▼
┌─────────────────┐     ┌─────────────────┐
│   GameUseCase   │     │  AudioUseCase   │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │ creates/updates       │ plays
         ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│    GameState    │     │   AudioPlayer   │
│    GameResult   │     │  (audioplayers) │
│    Question     │     └─────────────────┘
│    Target       │
└─────────────────┘
```
