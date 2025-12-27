# 画面コントラクト: 九九手裏剣 MVP

**作成日**: 2025-12-27
**ステータス**: 完了

## 画面一覧

1. **DifficultyScreen** - 難易度選択画面
2. **GameScreen** - ゲームプレイ画面
3. **ResultScreen** - リザルト画面

---

## 1. DifficultyScreen（難易度選択画面）

### 概要
ゲーム開始前に難易度を選択する画面。

### 入力パラメータ
なし（初期画面）

### 出力（画面遷移）
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GameScreen(difficulty: selectedDifficulty),
  ),
);
```

### UI要素
| 要素 | 説明 | アクション |
|------|------|-----------|
| タイトル | 「九九手裏剣」ロゴ/テキスト | なし |
| かんたんボタン | 2方向モード選択 | GameScreen(Difficulty.easy)へ遷移 |
| ふつうボタン | 3方向モード選択 | GameScreen(Difficulty.normal)へ遷移 |
| むずかしいボタン | 4方向モード選択 | GameScreen(Difficulty.hard)へ遷移 |

### ワイヤーフレーム
```
┌─────────────────────────┐
│                         │
│      九九手裏剣         │
│                         │
│   ┌─────────────────┐   │
│   │    かんたん     │   │
│   │    (2方向)      │   │
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │     ふつう      │   │
│   │    (3方向)      │   │
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │   むずかしい    │   │
│   │    (4方向)      │   │
│   └─────────────────┘   │
│                         │
└─────────────────────────┘
```

---

## 2. GameScreen（ゲームプレイ画面）

### 概要
九九の問題にフリック操作で回答するメイン画面。

### 入力パラメータ
```dart
class GameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const GameScreen({
    Key? key,
    required this.difficulty,
  }) : super(key: key);
}
```

### 出力（画面遷移）
```dart
// ゲーム終了時（10問回答後）
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => ResultScreen(result: gameResult),
  ),
);
```

### UI要素
| 要素 | 説明 | アクション |
|------|------|-----------|
| 進捗表示 | 「3/10」形式で現在の問題番号 | なし |
| 連続正解数 | 現在のストリーク表示 | なし |
| 問題カード | 九九の式を表示（例: 7×8） | スワイプで回答 |
| 的（上） | 回答選択肢 | カードを上方向にスワイプで選択 |
| 的（下） | 回答選択肢（かんたん/むずかしいのみ） | カードを下方向にスワイプで選択 |
| 的（左） | 回答選択肢（ふつう/むずかしいのみ） | カードを左方向にスワイプで選択 |
| 的（右） | 回答選択肢（ふつう/むずかしいのみ） | カードを右方向にスワイプで選択 |

### ワイヤーフレーム（むずかしいモード）
```
┌─────────────────────────┐
│  3/10        🔥3連続    │
│                         │
│          [24]           │  ← 的（上）
│           ▲             │
│                         │
│   [48]  ◀ 7×8 ▶  [56]   │  ← 的（左）、問題カード、的（右）
│                         │
│           ▼             │
│          [42]           │  ← 的（下）
│                         │
└─────────────────────────┘
```

### 状態管理
```dart
class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  late AppinioSwiperController _swiperController;

  void _handleSwipe(SwipeDirection direction) {
    // 1. 正解判定
    // 2. アニメーション再生
    // 3. 効果音再生
    // 4. 状態更新
    // 5. 10問完了ならリザルト画面へ
  }
}
```

---

## 3. ResultScreen（リザルト画面）

### 概要
ゲーム終了後の結果を表示する画面。

### 入力パラメータ
```dart
class ResultScreen extends StatelessWidget {
  final GameResult result;

  const ResultScreen({
    Key? key,
    required this.result,
  }) : super(key: key);
}
```

### 出力（画面遷移）
```dart
// 「もう一度」ボタン
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => GameScreen(difficulty: result.difficulty),
  ),
);

// 「難易度を変える」ボタン
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => DifficultyScreen()),
  (route) => false,
);
```

### UI要素
| 要素 | 説明 | アクション |
|------|------|-----------|
| タイトル | 「けっか」または難易度に応じたメッセージ | なし |
| 正答数 | 「8/10問 正解！」形式 | なし |
| 正答率 | 「80%」形式 | なし |
| 最大連続正解数 | 「最大 5連続」形式 | なし |
| もう一度ボタン | 同じ難易度で再プレイ | GameScreenへ遷移 |
| 難易度を変えるボタン | 難易度選択に戻る | DifficultyScreenへ遷移 |

### ワイヤーフレーム
```
┌─────────────────────────┐
│                         │
│         けっか          │
│                         │
│      ┌───────────┐      │
│      │  8/10問   │      │
│      │  正解！   │      │
│      └───────────┘      │
│                         │
│      正答率: 80%        │
│      最大: 5連続        │
│                         │
│   ┌─────────────────┐   │
│   │    もう一度     │   │
│   └─────────────────┘   │
│                         │
│   ┌─────────────────┐   │
│   │  難易度を変える │   │
│   └─────────────────┘   │
│                         │
└─────────────────────────┘
```

---

## 画面遷移図

```
┌─────────────────┐
│ DifficultyScreen│
└────────┬────────┘
         │
         │ 難易度選択
         ▼
┌─────────────────┐
│   GameScreen    │◀─────────┐
└────────┬────────┘          │
         │                   │
         │ 10問回答完了      │ もう一度
         ▼                   │
┌─────────────────┐          │
│  ResultScreen   │──────────┘
└────────┬────────┘
         │
         │ 難易度を変える
         ▼
┌─────────────────┐
│ DifficultyScreen│
└─────────────────┘
```
