# クイックスタート: 九九手裏剣 MVP

**作成日**: 2025-12-27
**ステータス**: 完了

## 前提条件

- Flutter SDK 3.10.4 以上
- Dart SDK 3.10.4 以上
- Xcode（iOS開発用）
- iOS Simulator または実機

## 環境セットアップ

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd kuku_shuriken
```

### 2. 依存関係のインストール

```bash
flutter pub get
```

### 3. iOS シミュレータの起動

```bash
open -a Simulator
```

### 4. アプリの実行

```bash
flutter run
```

## プロジェクト構成

```
kuku_shuriken/
├── lib/
│   ├── main.dart                    # エントリーポイント
│   ├── domain/                      # Domain層
│   │   ├── entities/                # エンティティ
│   │   └── usecases/                # ユースケース
│   ├── presentation/                # Presentation層
│   │   ├── screens/                 # 画面Widget
│   │   └── widgets/                 # 再利用可能なWidget
│   └── data/                        # Data層
│       └── audio/                   # 音声サービス
├── test/                            # テストコード
├── assets/                          # アセット（画像、音声）
│   ├── sounds/
│   └── images/
├── specs/                           # 設計ドキュメント
│   └── 001-kuku-shuriken-mvp/
├── pubspec.yaml                     # パッケージ設定
└── README.md
```

## 依存パッケージ

`pubspec.yaml` に以下を追加:

```yaml
dependencies:
  flutter:
    sdk: flutter
  appinio_swiper: ^2.1.1      # カードスワイプUI
  audioplayers: ^6.0.0        # 効果音再生

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0       # リンター
```

## アセット設定

`pubspec.yaml` にアセットを追加:

```yaml
flutter:
  assets:
    - assets/sounds/
    - assets/images/
```

## 開発ワークフロー

### テスト実行

```bash
# 全テスト実行
flutter test

# 特定のテストファイル実行
flutter test test/domain/usecases/game_usecase_test.dart

# カバレッジ付きテスト
flutter test --coverage
```

### コード品質チェック

```bash
# 静的解析
flutter analyze

# フォーマット
dart format lib/
```

### ビルド

```bash
# iOS用ビルド
flutter build ios

# デバッグビルド
flutter build ios --debug
```

## 実装順序（推奨）

### Phase 1: Domain層

1. `lib/domain/entities/` 配下のエンティティ実装
   - `question.dart`
   - `target.dart`
   - `game_state.dart`
   - `game_result.dart`

2. `lib/domain/usecases/game_usecase.dart` 実装

3. ユニットテスト作成
   - `test/domain/usecases/game_usecase_test.dart`

### Phase 2: Data層

1. `lib/data/audio/audio_player.dart` 実装

2. 音声アセット追加
   - `assets/sounds/correct.mp3`
   - `assets/sounds/wrong.mp3`

### Phase 3: Presentation層

1. 基本Widget実装
   - `lib/presentation/widgets/question_card.dart`
   - `lib/presentation/widgets/target_widget.dart`

2. 画面実装
   - `lib/presentation/screens/difficulty_screen.dart`
   - `lib/presentation/screens/game_screen.dart`
   - `lib/presentation/screens/result_screen.dart`

3. アニメーション追加
   - `lib/presentation/widgets/shuriken_animation.dart`

### Phase 4: 統合

1. `lib/main.dart` でルーティング設定
2. E2Eテスト
3. パフォーマンス確認（60fps維持）

## トラブルシューティング

### audioplayers でエラーが発生する場合

iOS の `Info.plist` に以下を追加:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

### appinio_swiper のジェスチャーが反応しない場合

カードのサイズが十分に大きいか確認してください。最小サイズは 100x100 程度を推奨します。

### アセットが読み込まれない場合

1. `pubspec.yaml` のインデントを確認
2. `flutter clean && flutter pub get` を実行
3. アセットファイルのパスを確認

## 参考リンク

- [appinio_swiper パッケージ](https://pub.dev/packages/appinio_swiper)
- [audioplayers パッケージ](https://pub.dev/packages/audioplayers)
- [Flutter 公式ドキュメント](https://docs.flutter.dev/)
- [プロジェクト憲章](/.specify/memory/constitution.md)
