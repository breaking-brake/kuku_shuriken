# 実装計画: 九九手裏剣（Kuku Shuriken）MVP

**ブランチ**: `feat/001-kuku-shuriken-mvp` | **日付**: 2025-12-27 | **仕様書**: `/specs/001-kuku-shuriken-mvp/spec.md`
**入力**: `/specs/001-kuku-shuriken-mvp/spec.md` からの機能仕様書

## 概要

九九手裏剣は、小学生（6-12歳）向けの九九学習ゲームアプリです。カードフリック操作で九九の問題に回答し、手裏剣が的に刺さるアニメーションで正解・不正解をフィードバックします。

**コア技術アプローチ**:
- **カードスワイプ**: `appinio_swiper` パッケージを使用（全方向スワイプ対応、閾値設定可能）
- **アニメーション**: Flutterの標準アニメーションAPI（AnimatedBuilder、AnimatedPositioned等）
- **状態管理**: シンプルなStatefulWidget（MVP段階ではRiverpod/BLoC不要）
- **音声**: `audioplayers` または `just_audio` パッケージ

## 技術コンテキスト

**言語/バージョン**: Dart SDK ^3.10.4
**フレームワーク**: Flutter
**主要依存関係**:
- `appinio_swiper` - カードスワイプUI（ユーザー指定）
- `audioplayers` または `just_audio` - 効果音再生（要調査）
- `flutter_lints` - コード品質

**ストレージ**: N/A（MVP段階ではローカル永続化不要、セッションスコアはメモリ内管理）
**テスト**: flutter_test
**ターゲットプラットフォーム**: iOS
**プロジェクトタイプ**: mobile
**パフォーマンス目標**: 60fps維持、アニメーション滑らか
**制約**: フリック誤検出率5%未満、1問平均5秒以内の回答
**スケール/スコープ**: 3画面（難易度選択、ゲーム、リザルト）、10問/セッション

## 憲章チェック

*ゲート: フェーズ0調査の前に通過必須。フェーズ1設計後に再チェック。*

### I. クリーンアーキテクチャ ✅
- **Presentation層**: ゲーム画面Widget、難易度選択Widget、リザルトWidget
- **Domain層**: QuestionEntity、SessionEntity、GameUseCase（問題生成・回答判定ロジック）
- **Data層**: MVP段階では永続化不要のためシンプルなインメモリ実装
- **準拠**: Domain層はフレームワーク非依存で実装

### II. ゲーム体験優先 ✅
- **60fps維持**: `appinio_swiper`は最適化済み、追加アニメーションはFlutter標準APIを使用
- **滑らかなアニメーション**: 手裏剣が飛ぶ・刺さる演出にAnimationController使用
- **重い処理の分離**: 問題生成は軽量なため不要

### III. シンプルさ優先 ✅
- **YAGNI**: MVP機能のみ実装（難易度選択、ゲームプレイ、リザルト表示）
- **抽象化の制限**: 状態管理はStatefulWidgetで十分（Riverpod/BLoC未使用）
- **最小限の複雑さ**: 3画面構成、セッション内スコアのみ

### IV. テスタビリティ ✅
- **DI**: GameUseCaseはテスト時にモック可能
- **ビジネスロジック分離**: 問題生成・正解判定ロジックはWidget外に配置
- **外部依存**: 音声再生は抽象化し、テスト時にサイレントモック可能

### V. 段階的品質向上 ✅
- **MVP優先**: まず動作する最小限の実装（P1機能）を完了
- **リファクタリング計画**: 機能追加後に必要に応じてコード整理

## プロジェクト構造

### ドキュメント（この機能用）

```text
specs/[###-feature]/
├── plan.md              # このファイル (/speckit.plan コマンド出力)
├── research.md          # フェーズ0出力 (/speckit.plan コマンド)
├── data-model.md        # フェーズ1出力 (/speckit.plan コマンド)
├── quickstart.md        # フェーズ1出力 (/speckit.plan コマンド)
├── contracts/           # フェーズ1出力 (/speckit.plan コマンド)
└── tasks.md             # フェーズ2出力 (/speckit.tasks コマンド - /speckit.plan では作成されません)
```

### ソースコード（リポジトリルート）

```text
lib/
├── main.dart                    # エントリーポイント
├── domain/                      # Domain層（フレームワーク非依存）
│   ├── entities/
│   │   ├── question.dart        # 九九問題エンティティ
│   │   ├── answer.dart          # 回答エンティティ
│   │   └── session.dart         # ゲームセッションエンティティ
│   └── usecases/
│       └── game_usecase.dart    # ゲームロジック（問題生成、正解判定）
├── presentation/                # Presentation層
│   ├── screens/
│   │   ├── difficulty_screen.dart   # 難易度選択画面
│   │   ├── game_screen.dart         # ゲーム画面
│   │   └── result_screen.dart       # リザルト画面
│   └── widgets/
│       ├── question_card.dart       # 問題カードWidget
│       ├── target_widget.dart       # 的Widget
│       └── shuriken_animation.dart  # 手裏剣アニメーション
└── data/                        # Data層（MVP段階ではシンプル）
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

**構造決定**: Flutter標準のlib/構造を採用し、クリーンアーキテクチャに沿ってdomain/presentation/dataの3層に分離

## 複雑性トラッキング

> **憲章チェックに正当化が必要な違反がある場合のみ記入**

| 違反 | 必要な理由 | 却下されたよりシンプルな代替案の理由 |
|-----------|------------|-------------------------------------|
| なし | - | - |

**備考**: MVP段階では憲章に違反する複雑性は導入しない。シンプルさ優先原則に従い、必要最小限の実装を行う。
