/// 効果音再生を提供するユースケース
abstract class AudioUseCase {
  /// 正解時の効果音を再生
  Future<void> playCorrectSound();

  /// 不正解時の効果音を再生
  Future<void> playWrongSound();

  /// リソースを解放
  Future<void> dispose();
}
