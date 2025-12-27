import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';

import '../../data/audio/audio_player.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/swipe_direction.dart';
import '../../domain/usecases/audio_usecase.dart';
import '../../domain/usecases/game_usecase.dart';
import '../widgets/question_card.dart';
import '../widgets/shuriken_animation.dart';
import '../widgets/target_widget.dart';

/// ゲームプレイ画面
class GameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const GameScreen({
    super.key,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameUseCase _gameUseCase;
  late AudioUseCase _audioUseCase;
  late GameState _gameState;
  late AppinioSwiperController _swiperController;

  bool _isAnimating = false;
  SwipeDirection? _lastSwipeDirection;
  bool? _lastAnswerCorrect;

  @override
  void initState() {
    super.initState();
    _gameUseCase = GameUseCaseImpl();
    _audioUseCase = AudioUseCaseImpl();
    _swiperController = AppinioSwiperController();
    _gameState = _gameUseCase.startGame(widget.difficulty);
  }

  @override
  void dispose() {
    _audioUseCase.dispose();
    super.dispose();
  }

  SwipeDirection _convertDirection(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return SwipeDirection.up;
      case AxisDirection.down:
        return SwipeDirection.down;
      case AxisDirection.left:
        return SwipeDirection.left;
      case AxisDirection.right:
        return SwipeDirection.right;
    }
  }

  void _handleSwipe(int index, AxisDirection direction) {
    if (_isAnimating) return;

    final swipeDirection = _convertDirection(direction);

    // この方向に的があるか確認
    final hasTarget = _gameState.currentTargets.any(
      (t) => t.direction == swipeDirection,
    );

    if (!hasTarget) {
      // この難易度では使用しない方向へのスワイプは無視
      return;
    }

    final selectedTarget = _gameState.currentTargets.firstWhere(
      (t) => t.direction == swipeDirection,
    );

    setState(() {
      _isAnimating = true;
      _lastSwipeDirection = swipeDirection;
      _lastAnswerCorrect = selectedTarget.isCorrect;
    });

    // 効果音再生
    if (selectedTarget.isCorrect) {
      _audioUseCase.playCorrectSound();
    } else {
      _audioUseCase.playWrongSound();
    }
  }

  void _onAnimationComplete() {
    final newState = _gameUseCase.processAnswer(
      _gameState,
      _lastSwipeDirection!,
    );

    setState(() {
      _gameState = newState;
      _isAnimating = false;
      _lastSwipeDirection = null;
      _lastAnswerCorrect = null;
    });

    // ゲーム終了判定
    if (_gameState.isGameOver) {
      _navigateToResult();
    }
  }

  void _navigateToResult() {
    final result = _gameUseCase.getResult(_gameState);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => _ResultPlaceholder(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Stack(
          children: [
            // 的の配置
            ..._buildTargets(),

            // カードスワイプエリア
            Center(
              child: _gameState.currentQuestion != null && !_isAnimating
                  ? SizedBox(
                      width: 250,
                      height: 250,
                      child: AppinioSwiper(
                        controller: _swiperController,
                        cardCount: 1,
                        swipeOptions: const SwipeOptions.all(),
                        threshold: 50,
                        onSwipeEnd: (previousIndex, targetIndex, activity) {
                          if (activity is Swipe) {
                            _handleSwipe(previousIndex, activity.direction);
                          }
                        },
                        cardBuilder: (context, index) {
                          return QuestionCard(
                            question: _gameState.currentQuestion!,
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // 手裏剣アニメーション
            if (_isAnimating && _lastSwipeDirection != null)
              Center(
                child: ShurikenAnimation(
                  direction: _lastSwipeDirection!,
                  isCorrect: _lastAnswerCorrect ?? false,
                  onComplete: _onAnimationComplete,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTargets() {
    return _gameState.currentTargets.map((target) {
      return Align(
        alignment: TargetWidget.getAlignment(target.direction),
        child: Padding(
          padding: TargetWidget.getPadding(target.direction),
          child: TargetWidget(
            target: target,
            showHit: _isAnimating &&
                _lastSwipeDirection == target.direction,
          ),
        ),
      );
    }).toList();
  }
}

/// リザルト画面のプレースホルダー（フェーズ5で正式に実装）
class _ResultPlaceholder extends StatelessWidget {
  final GameResult result;

  const _ResultPlaceholder({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'けっか',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              '${result.correctCount}/${result.totalQuestions}問 正解！',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '正答率: ${result.accuracy.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              '最大: ${result.maxStreak}連続',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      difficulty: result.difficulty,
                    ),
                  ),
                );
              },
              child: const Text('もう一度'),
            ),
          ],
        ),
      ),
    );
  }
}
