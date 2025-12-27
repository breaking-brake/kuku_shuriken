# タスク: 九九手裏剣 MVP

**入力**: `/specs/001-kuku-shuriken-mvp/` からの設計ドキュメント
**前提条件**: plan.md、spec.md、research.md、data-model.md、contracts/

**テスト**: 仕様書でテストが明示的に要求されていないため、テストタスクは含まれていません。

**構成**: タスクはユーザーストーリーごとにグループ化され、各ストーリーの独立した実装とテストが可能です。

## フォーマット: `[ID] [P?] [Story] 説明`

- **[P]**: 並列実行可能（異なるファイル、依存関係なし）
- **[Story]**: このタスクが属するユーザーストーリー（例：US1、US2、US3）
- 説明に正確なファイルパスを含める

## パス規則

- **モバイル（Flutter）**: `lib/` 配下にdomain/presentation/dataの3層構造
- アセット: `assets/sounds/`、`assets/images/`

---

## フェーズ1: セットアップ（プロジェクト初期化）

**目的**: Flutterプロジェクトの初期化と基本構造の作成

- [x] T001 Flutterプロジェクト構造を作成（lib/domain/、lib/presentation/、lib/data/）
- [x] T002 pubspec.yamlに依存パッケージを追加（appinio_swiper、audioplayers、flutter_lints）
- [x] T003 [P] pubspec.yamlにアセットパスを設定（assets/sounds/、assets/images/）
- [x] T004 [P] 分析オプションを設定（analysis_options.yaml）

---

## フェーズ2: 基盤（Domain層エンティティ）

**目的**: すべてのユーザーストーリーで使用するコアエンティティとユースケースの実装

**⚠️ 重要**: このフェーズが完了するまでユーザーストーリーの作業を開始できません

### エンティティ

- [x] T005 [P] SwipeDirection enumを作成（lib/domain/entities/swipe_direction.dart）
- [x] T006 [P] Difficulty enumを作成（lib/domain/entities/difficulty.dart）
- [x] T007 [P] Questionエンティティを作成（lib/domain/entities/question.dart）
- [x] T008 [P] Targetエンティティを作成（lib/domain/entities/target.dart）
- [x] T009 GameStateエンティティを作成（lib/domain/entities/game_state.dart）※T005-T008に依存
- [x] T010 GameResultエンティティを作成（lib/domain/entities/game_result.dart）※T009に依存

### ユースケース

- [x] T011 GameUseCaseインターフェースと実装を作成（lib/domain/usecases/game_usecase.dart）※T005-T010に依存
- [x] T012 AudioUseCaseインターフェースを作成（lib/domain/usecases/audio_usecase.dart）

### 音声サービス

- [x] T013 AudioUseCaseImplを実装（lib/data/audio/audio_player.dart）※T012に依存
- [x] T014 [P] 正解効果音ファイルを追加（assets/sounds/correct.mp3）
- [x] T015 [P] 不正解効果音ファイルを追加（assets/sounds/wrong.mp3）

**チェックポイント**: 基盤準備完了 - ユーザーストーリーの実装を開始可能

---

## フェーズ3: ユーザーストーリー1 - 九九問題にフリックで回答する (優先度: P1) 🎯 MVP

**ゴール**: 画面中央の九九問題カードを正解の的の方向へフリックして回答。正解時は手裏剣が的に刺さるアニメーション、不正解時は外れるアニメーションと効果音を再生。

**独立テスト**: 4方向モード（むずかしい）で1つの九九問題を表示し、フリック操作で正解・不正解の判定とアニメーション・効果音が動作することを確認。

### ユーザーストーリー1の実装

- [ ] T016 [P] [US1] QuestionCardウィジェットを作成（lib/presentation/widgets/question_card.dart）
- [ ] T017 [P] [US1] TargetWidgetを作成（lib/presentation/widgets/target_widget.dart）
- [ ] T018 [US1] ShurikenAnimationウィジェットを作成（lib/presentation/widgets/shuriken_animation.dart）
- [ ] T019 [US1] GameScreenを実装 - appinio_swiperでカードスワイプUI（lib/presentation/screens/game_screen.dart）※T016-T018に依存
- [ ] T020 [US1] GameScreenにスワイプ方向判定と正解判定ロジックを追加
- [ ] T021 [US1] GameScreenに正解時アニメーション（手裏剣が的に刺さる）を実装
- [ ] T022 [US1] GameScreenに不正解時アニメーション（手裏剣が外れる）を実装
- [ ] T023 [US1] GameScreenに効果音再生を統合（AudioUseCase使用）

**チェックポイント**: フリック操作で九九問題に回答でき、正解・不正解のフィードバックが動作

---

## フェーズ4: ユーザーストーリー2 - 難易度を選択してゲームを開始する (優先度: P1)

**ゴール**: ゲーム開始前に難易度（かんたん：2方向、ふつう：3方向、むずかしい：4方向）を選択し、選んだ難易度に応じた的の配置でゲームを開始。

**独立テスト**: 難易度選択画面で各難易度を選択し、ゲーム画面に遷移後、選択した難易度に応じた数の的が表示されることを確認。

### ユーザーストーリー2の実装

- [ ] T024 [US2] DifficultyScreenを実装 - 3つの難易度ボタン（lib/presentation/screens/difficulty_screen.dart）
- [ ] T025 [US2] DifficultyScreenからGameScreenへの画面遷移を実装
- [ ] T026 [US2] GameScreenを難易度に応じた的の配置に対応させる
- [ ] T027 [US2] main.dartでルーティング設定 - DifficultyScreenを初期画面に（lib/main.dart）

**チェックポイント**: 難易度選択後、選択に応じた的の数でゲームが開始される

---

## フェーズ5: ユーザーストーリー3 - ゲーム中のスコアを確認する (優先度: P2)

**ゴール**: ゲームプレイ中に連続正解数を確認でき、10問回答後にリザルト画面で結果（正答数、正答率、最大連続正解数）を確認。

**独立テスト**: ゲームを10問プレイし、プレイ中のスコア表示と終了時のリザルト画面の表示内容を確認。

### ユーザーストーリー3の実装

- [ ] T028 [US3] GameScreenに進捗表示（n/10問）を追加
- [ ] T029 [US3] GameScreenに連続正解数表示を追加
- [ ] T030 [US3] ResultScreenを実装 - 正答数、正答率、最大連続正解数を表示（lib/presentation/screens/result_screen.dart）
- [ ] T031 [US3] ResultScreenに「もう一度」ボタンを追加 - 同じ難易度でGameScreenへ遷移
- [ ] T032 [US3] ResultScreenに「難易度を変える」ボタンを追加 - DifficultyScreenへ遷移
- [ ] T033 [US3] GameScreenから10問回答後にResultScreenへ遷移するロジックを追加

**チェックポイント**: ゲーム中のスコア表示と終了時のリザルト表示が動作

---

## フェーズ6: 仕上げ & 横断的関心事

**目的**: パフォーマンス最適化とコード品質向上

- [ ] T034 60fps維持の確認とパフォーマンス最適化
- [ ] T035 [P] flutter analyzeで静的解析エラーを解消
- [ ] T036 [P] dart format lib/ でコードフォーマット
- [ ] T037 エッジケース対応 - 斜め方向フリックの方向正規化を確認
- [ ] T038 エッジケース対応 - 短いフリック（閾値未満）の無効化を確認
- [ ] T039 エッジケース対応 - 連続フリックのアニメーション完了待機を確認
- [ ] T040 iOSシミュレータでE2Eテスト実行

---

## 依存関係 & 実行順序

### フェーズ依存関係

- **セットアップ（フェーズ1）**: 依存関係なし - すぐに開始可能
- **基盤（フェーズ2）**: セットアップ完了に依存 - すべてのユーザーストーリーをブロック
- **ユーザーストーリー1（フェーズ3）**: 基盤フェーズの完了に依存
- **ユーザーストーリー2（フェーズ4）**: 基盤フェーズの完了に依存、US1との並列実行可能
- **ユーザーストーリー3（フェーズ5）**: US1およびUS2の完了に依存（GameScreen、ResultScreenの前提）
- **仕上げ（フェーズ6）**: すべてのユーザーストーリーの完了に依存

### ユーザーストーリー依存関係

```
基盤(Phase2)
    │
    ├──▶ US1(Phase3): フリック回答 ──┐
    │                                │
    └──▶ US2(Phase4): 難易度選択 ────┼──▶ US3(Phase5): スコア表示 ──▶ 仕上げ(Phase6)
```

- **ユーザーストーリー1（P1）**: 基盤完了後に開始可能
- **ユーザーストーリー2（P1）**: 基盤完了後に開始可能（US1と並列可能）
- **ユーザーストーリー3（P2）**: US1とUS2の完了後に開始可能（GameScreenとResultScreenの両方が必要）

### 各フェーズ内の依存関係

**フェーズ2（基盤）**:
- T005-T008は並列実行可能
- T009はT005-T008に依存
- T010はT009に依存
- T011はT005-T010に依存
- T013はT012に依存
- T014-T015は並列実行可能

**フェーズ3（US1）**:
- T016-T017は並列実行可能
- T018-T023は順次実行

**フェーズ4（US2）**:
- T024-T027は順次実行

**フェーズ5（US3）**:
- T028-T033は順次実行

---

## 並列実行例

### フェーズ2: エンティティ作成

```bash
# 以下のタスクを同時実行可能:
タスク: "SwipeDirection enumを作成（lib/domain/entities/swipe_direction.dart）"
タスク: "Difficulty enumを作成（lib/domain/entities/difficulty.dart）"
タスク: "Questionエンティティを作成（lib/domain/entities/question.dart）"
タスク: "Targetエンティティを作成（lib/domain/entities/target.dart）"
```

### フェーズ2: 音声アセット追加

```bash
# 以下のタスクを同時実行可能:
タスク: "正解効果音ファイルを追加（assets/sounds/correct.mp3）"
タスク: "不正解効果音ファイルを追加（assets/sounds/wrong.mp3）"
```

### フェーズ3-4: ユーザーストーリー1と2の並列開始

```bash
# 基盤完了後、以下を並列で開始可能（別々の開発者が担当する場合）:
タスク: "[US1] QuestionCardウィジェットを作成"
タスク: "[US2] DifficultyScreenを実装"
```

---

## 実装戦略

### MVPファースト（ユーザーストーリー1のみ）

1. フェーズ1を完了: セットアップ
2. フェーズ2を完了: 基盤
3. フェーズ3を完了: ユーザーストーリー1
4. **停止して検証**: フリック回答機能が動作することを確認
5. 準備ができたらデモ可能

### 増分デリバリー

1. セットアップ + 基盤を完了 → 基盤準備完了
2. ユーザーストーリー1を追加 → 独立してテスト → デモ（MVP！）
3. ユーザーストーリー2を追加 → 難易度選択が動作 → デモ
4. ユーザーストーリー3を追加 → スコア表示とリザルト画面が動作 → デモ
5. 仕上げ → パフォーマンス最適化とE2Eテスト → リリース準備完了

### ソロ開発者戦略

1. セットアップ + 基盤を順次完了
2. 優先度順にユーザーストーリーを実装（P1 → P2）
3. 各ストーリー完了後に動作確認
4. 仕上げフェーズで品質向上

---

## 備考

- [P]タスク = 異なるファイル、依存関係なし
- [Story]ラベルはタスクを特定のユーザーストーリーにマッピング
- 各ユーザーストーリーは独立して完了・テスト可能であるべき
- 各タスクまたは論理グループの後にコミット推奨
- 避けるべきこと: 曖昧なタスク、同一ファイルの競合、独立性を損なうクロスストーリー依存関係
