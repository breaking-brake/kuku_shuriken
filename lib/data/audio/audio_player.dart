import 'package:audioplayers/audioplayers.dart';

import '../../domain/usecases/audio_usecase.dart';

/// AudioUseCaseの実装
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
