# 技術調査: 九九手裏剣 MVP

**作成日**: 2025-12-27
**ステータス**: 完了

## 調査項目

### 1. カードスワイプUI: appinio_swiper

**決定**: `appinio_swiper` パッケージを採用

**根拠**:
- ユーザー指定のパッケージであり、要件に適合
- 全方向スワイプ（上下左右）に対応
- `threshold`パラメータでスワイプ判定の閾値を設定可能（仕様の「短いフリックは無効」に対応）
- `AppinioSwiperController`でプログラマティックな制御が可能
- MIT ライセンス

**主要パラメータ設定**:
```dart
AppinioSwiper(
  cardsCount: 10,              // 1セッション10問
  threshold: 50,               // スワイプ判定閾値（調整可能）
  maxAngle: 30,                // スワイプ時の傾き
  duration: Duration(milliseconds: 200),  // アニメーション速度
  onSwipe: (int index, AppinioSwiperDirection direction) {
    // 方向に基づいて正解判定
  },
)
```

**検討した代替案**:
- `flutter_card_swiper`: 類似機能だが、appinio_swiperの方がドキュメントが充実
- 自作実装: GestureDetector + AnimatedPositionedで可能だが、開発工数増加

---

### 2. 音声再生パッケージ

**決定**: `audioplayers` を採用

**根拠**:
- **シンプルなAPI**: 短い効果音再生に最適化されたシンプルなインターフェース
- **iOS対応**: `audioplayers_darwin`経由で安定したiOSサポート
- **複数音声同時再生**: 正解/不正解の効果音を素早く連続再生可能
- **軽量**: 効果音再生のみの用途には十分な機能
- **実績**: 563k以上のダウンロード、活発なメンテナンス

**実装例**:
```dart
final player = AudioPlayer();
// アセットから効果音を再生
await player.play(AssetSource('sounds/correct.mp3'));
```

**検討した代替案**:
| パッケージ | 長所 | 短所 | 判断 |
|-----------|------|------|------|
| `just_audio` | 高機能、プレイリスト対応 | 設定複雑、オーバースペック | 不採用 |
| `audioplayers` | シンプル、軽量、iOS対応良好 | 高度な機能は限定的 | **採用** |

**不採用理由（just_audio）**:
- 効果音再生のみの用途にはオーバースペック
- Info.plistへの追加設定が必要
- プレイリストやストリーミング機能は不要

---

### 3. フリック方向判定ロジック

**決定**: `appinio_swiper`の`onSwipe`コールバック + 角度正規化

**根拠**:
- `appinio_swiper`は`AppinioSwiperDirection`（left, right, top, bottom）を返す
- 斜め方向のスワイプは自動的に最も近い方向に正規化される
- カスタム方向判定は不要（パッケージ内蔵機能で十分）

**難易度別の的配置**:
```dart
enum Difficulty {
  easy,    // 2方向: top, bottom
  normal,  // 3方向: top, left, right
  hard,    // 4方向: top, bottom, left, right
}
```

---

### 4. アニメーション実装方針

**決定**: Flutter標準アニメーションAPI + 手裏剣カスタムWidget

**根拠**:
- `AnimationController` + `AnimatedBuilder` で60fps維持可能
- `appinio_swiper`のスワイプアニメーションは内蔵
- 手裏剣が飛ぶ演出は`AnimatedPositioned` + 回転アニメーションで実装

**アニメーションフロー**:
1. ユーザーがカードをスワイプ → `appinio_swiper`がスワイプアニメーション処理
2. スワイプ完了 → 手裏剣が的に向かって飛ぶアニメーション開始
3. 的に到達 → 正解時: 刺さる効果音 + 振動、不正解時: 外れる効果音
4. アニメーション完了 → 次の問題表示

---

### 5. 状態管理

**決定**: StatefulWidget（シンプルな実装）

**根拠**:
- MVP段階では3画面のみ、状態もシンプル
- Riverpod/BLoCは過剰な複雑性を追加
- 憲章「シンプルさ優先」に準拠

**管理する状態**:
- 現在の難易度（Difficulty enum）
- 現在の問題インデックス（int, 0-9）
- 現在の問題（Question entity）
- 連続正解数（int）
- セッション結果（正答数、正答率、最大連続正解数）

---

## 未解決事項

なし - すべての技術調査項目が解決済み

## 次のステップ

1. data-model.md の作成（エンティティ定義）
2. contracts/ の作成（画面間のインターフェース定義）
3. quickstart.md の作成（開発環境セットアップガイド）
