# データモデル: 九九手裏剣 MVP

**作成日**: 2025-12-27
**ステータス**: 完了

## エンティティ一覧

### 1. Question（問題）

九九の問題を表すエンティティ。

```dart
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
```

**バリデーションルール**:
- `multiplicand`: 2以上9以下の整数
- `multiplier`: 2以上9以下の整数

---

### 2. Target（的）

回答の選択肢を表すエンティティ。

```dart
/// 的（回答選択肢）を表すエンティティ
class Target {
  /// 的に表示する数値
  final int value;

  /// 的の配置方向
  final SwipeDirection direction;

  /// この的が正解かどうか
  final bool isCorrect;

  const Target({
    required this.value,
    required this.direction,
    required this.isCorrect,
  });
}
```

---

### 3. SwipeDirection（スワイプ方向）

フリック方向を表すEnum。

```dart
/// スワイプ方向を表すEnum
enum SwipeDirection {
  up,
  down,
  left,
  right,
}
```

---

### 4. Difficulty（難易度）

ゲームの難易度を表すEnum。

```dart
/// 難易度を表すEnum
enum Difficulty {
  /// かんたん: 2方向（上下）
  easy(
    label: 'かんたん',
    targetCount: 2,
    directions: [SwipeDirection.up, SwipeDirection.down],
  ),

  /// ふつう: 3方向（上左右）
  normal(
    label: 'ふつう',
    targetCount: 3,
    directions: [SwipeDirection.up, SwipeDirection.left, SwipeDirection.right],
  ),

  /// むずかしい: 4方向（上下左右）
  hard(
    label: 'むずかしい',
    targetCount: 4,
    directions: SwipeDirection.values,
  );

  final String label;
  final int targetCount;
  final List<SwipeDirection> directions;

  const Difficulty({
    required this.label,
    required this.targetCount,
    required this.directions,
  });
}
```

---

### 5. GameState（ゲーム状態）

ゲームセッションの状態を表すエンティティ。

```dart
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
```

---

### 6. GameResult（ゲーム結果）

ゲーム終了時の結果を表すエンティティ。

```dart
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
```

---

## エンティティ関連図

```
┌─────────────┐     ┌─────────────┐
│  Difficulty │────▶│  GameState  │
└─────────────┘     └──────┬──────┘
                           │
                           │ contains
                           ▼
                    ┌─────────────┐
                    │  Question   │
                    └─────────────┘
                           │
                           │ generates
                           ▼
                    ┌─────────────┐     ┌─────────────┐
                    │   Target    │────▶│SwipeDirection│
                    └─────────────┘     └─────────────┘
                           │
                           │ produces
                           ▼
                    ┌─────────────┐
                    │ GameResult  │
                    └─────────────┘
```

---

## 状態遷移

### GameState の状態遷移

```
[Initial] ─────────────────▶ [Playing] ─────────────────▶ [GameOver]
           startGame()                  answer() × 10
                                         (10問回答後)
```

### 回答時の状態更新フロー

```
1. ユーザーがスワイプ
2. スワイプ方向を検出
3. 正解判定
   ├─ 正解の場合:
   │   ├─ correctCount++
   │   ├─ currentStreak++
   │   └─ maxStreak = max(maxStreak, currentStreak)
   └─ 不正解の場合:
       └─ currentStreak = 0
4. currentQuestionIndex++
5. 新しい問題と的を生成
6. isGameOver == true の場合、GameResult を生成
```
