# 九九手裏剣 開発ガイドライン

すべての機能計画から自動生成。最終更新: 2025-12-27

## 使用中の技術

| カテゴリ | 技術 |
|---------|------|
| フレームワーク | Flutter |
| 言語 | Dart SDK ^3.10.4 |
| プラットフォーム | iOS |
| カードスワイプ | appinio_swiper |
| 音声再生 | audioplayers |
| テスト | flutter_test |
| リンター | flutter_lints |

## プロジェクト構造

```text
lib/
├── main.dart                    # エントリーポイント
├── domain/                      # Domain層（フレームワーク非依存）
│   ├── entities/
│   │   ├── question.dart        # 九九問題エンティティ
│   │   ├── target.dart          # 的エンティティ
│   │   ├── game_state.dart      # ゲーム状態エンティティ
│   │   └── game_result.dart     # ゲーム結果エンティティ
│   └── usecases/
│       ├── game_usecase.dart    # ゲームロジック
│       └── audio_usecase.dart   # 音声再生ロジック
├── presentation/                # Presentation層
│   ├── screens/
│   │   ├── difficulty_screen.dart   # 難易度選択画面
│   │   ├── game_screen.dart         # ゲーム画面
│   │   └── result_screen.dart       # リザルト画面
│   └── widgets/
│       ├── question_card.dart       # 問題カードWidget
│       ├── target_widget.dart       # 的Widget
│       └── shuriken_animation.dart  # 手裏剣アニメーション
└── data/                        # Data層
    └── audio/
        └── audio_player.dart    # 音声再生サービス

test/
├── domain/
│   └── usecases/
│       └── game_usecase_test.dart
└── presentation/
    └── widgets/
        └── question_card_test.dart

assets/
├── sounds/
│   ├── correct.mp3
│   └── wrong.mp3
└── images/
    └── target.png
```

## コマンド

```bash
# 依存関係インストール
flutter pub get

# アプリ実行
flutter run

# テスト実行
flutter test

# 静的解析
flutter analyze

# コードフォーマット
dart format lib/

# iOS ビルド
flutter build ios
```

## コードスタイル

### Dart / Flutter

- クリーンアーキテクチャ（Domain/Presentation/Data層分離）
- Domain層はフレームワーク非依存
- 状態管理はStatefulWidget（MVPフェーズ）
- 60fps維持を意識した実装
- flutter_lints 準拠

### 命名規則

- ファイル名: snake_case（例: `game_usecase.dart`）
- クラス名: PascalCase（例: `GameUseCase`）
- 変数名/メソッド名: camelCase（例: `currentQuestion`）
- 定数: camelCase または SCREAMING_SNAKE_CASE

## 最近の変更

### 001-kuku-shuriken-mvp

- カードフリック式九九学習ゲームのMVP実装
- appinio_swiperによるカードスワイプUI
- 3段階の難易度（かんたん/ふつう/むずかしい）
- 正解・不正解のアニメーションと効果音

<!-- 手動追加開始 -->
<!-- 手動追加終了 -->
