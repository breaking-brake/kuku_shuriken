import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';

import '../../data/audio/audio_player.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/swipe_direction.dart';
import '../../domain/usecases/audio_usecase.dart';
import '../../domain/usecases/game_usecase.dart';
import '../widgets/question_card.dart';
import '../widgets/shuriken_animation.dart';
import '../widgets/target_widget.dart';
import 'result_screen.dart';

/// ゲームプレイ画面
class GameScreen extends StatefulWidget {
  final Difficulty difficulty;

  const GameScreen({super.key, required this.difficulty});

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
  Question? _lastQuestion;

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

  /// 難易度に応じたスワイプ方向を制限する
  SwipeOptions _getAllowedSwipeOptions() {
    final directions = _gameState.currentTargets
        .map((t) => t.direction)
        .toSet();
    return SwipeOptions.only(
      up: directions.contains(SwipeDirection.up),
      down: directions.contains(SwipeDirection.down),
      left: directions.contains(SwipeDirection.left),
      right: directions.contains(SwipeDirection.right),
    );
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
      _lastQuestion = _gameState.currentQuestion;
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
      _lastQuestion = null;
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
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Stack(
          children: [
            // ヘッダー（戻るボタン、進捗表示、連続正解数）
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // 戻るボタン
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.indigo,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 進捗表示
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${_gameState.currentQuestionIndex + 1}/${_gameState.questions.length}もん',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // 連続正解数表示
                    if (_gameState.currentStreak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 4),
                            Text(
                              '${_gameState.currentStreak}れんぞく',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 的の配置
            ..._buildTargets(),

            // カードスワイプエリア
            Center(
              child: _gameState.currentQuestion != null && !_isAnimating
                  ? SizedBox(
                      width: 180,
                      height: 180,
                      child: AppinioSwiper(
                        controller: _swiperController,
                        cardCount: 1,
                        swipeOptions: _getAllowedSwipeOptions(),
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
            if (_isAnimating &&
                _lastSwipeDirection != null &&
                _lastQuestion != null)
              Center(
                child: ShurikenAnimation(
                  direction: _lastSwipeDirection!,
                  isCorrect: _lastAnswerCorrect ?? false,
                  onComplete: _onAnimationComplete,
                  question: _lastQuestion!,
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
            showHit: _isAnimating && _lastSwipeDirection == target.direction,
          ),
        ),
      );
    }).toList();
  }
}
