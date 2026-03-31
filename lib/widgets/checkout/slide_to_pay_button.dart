import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';

class SlideToPayButton extends StatefulWidget {
  final String text;
  final String amount;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onSubmit;
  final GlobalKey<SlideToPayButtonState>? buttonKey;

  const SlideToPayButton({
    super.key,
    required this.text,
    this.amount = '',
    this.isEnabled = true,
    this.isLoading = false,
    required this.onSubmit,
    this.buttonKey,
  });

  @override
  State<SlideToPayButton> createState() => SlideToPayButtonState();
}

class SlideToPayButtonState extends State<SlideToPayButton>
    with TickerProviderStateMixin {
  double _dragPosition = 0;
  double _dragPercentage = 0;
  bool _isSubmitted = false;
  bool _isDragging = false;

  late AnimationController _hintAnimationController;
  late Animation<double> _hintAnimation;

  late AnimationController _successAnimationController;
  late Animation<double> _successAnimation;

  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  double get _buttonSize => ResponsiveUtils.rp(52);
  double get _containerHeight => ResponsiveUtils.rp(64);
  double get _horizontalPadding => ResponsiveUtils.rp(6);

  @override
  void initState() {
    super.initState();
    _initAnimations();

    // Start hint animation after a delay when entering the page
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && widget.isEnabled && !_isSubmitted) {
        _startHintAnimation();
      }
    });
  }

  void _initAnimations() {
    // Hint animation - shows user to swipe right
    _hintAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _hintAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(
        parent: _hintAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _hintAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _hintAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed && mounted && !_isDragging && !_isSubmitted) {
        // Repeat hint animation
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_isDragging && !_isSubmitted && widget.isEnabled) {
            _hintAnimationController.forward();
          }
        });
      }
    });

    // Success animation
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _successAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _successAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Pulse animation for the arrow
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startHintAnimation() {
    if (_hintAnimationController.isAnimating) return;
    _hintAnimationController.forward();
  }

  void reset() {
    if (!mounted) return;

    setState(() {
      _dragPosition = 0;
      _dragPercentage = 0;
      _isSubmitted = false;
      _isDragging = false;
    });
    _successAnimationController.reset();

    // Restart pulse and hint animations
    if (!_pulseAnimationController.isAnimating) {
      _pulseAnimationController.repeat(reverse: true);
    }
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && widget.isEnabled && !_isSubmitted && !widget.isLoading) {
        _startHintAnimation();
      }
    });
  }

  double _getMaxDragDistance(double containerWidth) {
    return containerWidth - _buttonSize - (_horizontalPadding * 2);
  }

  void _onDragStart(DragStartDetails details, double containerWidth) {
    if (!widget.isEnabled || _isSubmitted || widget.isLoading) return;

    _hintAnimationController.stop();
    _hintAnimationController.reset();
    _pulseAnimationController.stop();

    setState(() {
      _isDragging = true;
    });
  }

  void _onDragUpdate(DragUpdateDetails details, double containerWidth) {
    if (!widget.isEnabled || _isSubmitted || widget.isLoading) return;

    final maxDrag = _getMaxDragDistance(containerWidth);

    setState(() {
      // Allow dragging from any position - this fixes the "middle to right" bug
      _dragPosition = (_dragPosition + details.delta.dx).clamp(0, maxDrag);
      _dragPercentage = _dragPosition / maxDrag;
    });
  }

  void _onDragEnd(DragEndDetails details, double containerWidth) {
    if (!widget.isEnabled || _isSubmitted || widget.isLoading) return;

    final maxDrag = _getMaxDragDistance(containerWidth);

    // If dragged more than 85%, consider it submitted
    if (_dragPercentage >= 0.85) {
      setState(() {
        _dragPosition = maxDrag;
        _dragPercentage = 1.0;
        _isSubmitted = true;
        _isDragging = false;
      });

      // Haptic feedback
      HapticFeedback.mediumImpact();

      // Play success animation
      _successAnimationController.forward();

      // Trigger callback
      widget.onSubmit();
    } else {
      // Spring back to start
      _animateToPosition(0, containerWidth);
    }
  }

  void _animateToPosition(double targetPosition, double containerWidth) {
    final startPosition = _dragPosition;
    final maxDrag = _getMaxDragDistance(containerWidth);

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    final animation = Tween<double>(
      begin: startPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          _dragPosition = animation.value;
          _dragPercentage = _dragPosition / maxDrag;
        });
      }
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        setState(() {
          _isDragging = false;
        });

        // Restart hint animation after spring back
        if (targetPosition == 0 && widget.isEnabled && !_isSubmitted) {
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted && !_isDragging && !_isSubmitted) {
              _startHintAnimation();
            }
          });
        }
      }
    });

    controller.forward();
  }

  @override
  void didUpdateWidget(SlideToPayButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Prevent unnecessary rebuilds when only isLoading changes during payment
    if (oldWidget.isLoading != widget.isLoading && widget.isLoading) {
      // When loading starts, stop all animations to prevent flickering
      _hintAnimationController.stop();
      _pulseAnimationController.stop();
    }
  }

  @override
  void dispose() {
    _hintAnimationController.dispose();
    _successAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return RepaintBoundary(
        child: _buildLoadingState(),
      );
    }

    return RepaintBoundary(
      child: LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth;
        final maxDrag = _getMaxDragDistance(containerWidth);

        return GestureDetector(
          onHorizontalDragStart: widget.isLoading ? null : (details) => _onDragStart(details, containerWidth),
          onHorizontalDragUpdate: widget.isLoading ? null : (details) => _onDragUpdate(details, containerWidth),
          onHorizontalDragEnd: widget.isLoading ? null : (details) => _onDragEnd(details, containerWidth),
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
          animation: Listenable.merge([_hintAnimation, _pulseAnimation]),
          builder: (context, child) {
            // Calculate position including hint animation
            double displayPosition = _dragPosition;
            if (!_isDragging && !_isSubmitted && _dragPosition == 0 && !widget.isLoading) {
              displayPosition = _hintAnimation.value * maxDrag;
            }

            return Container(
              height: _containerHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                gradient: LinearGradient(
                  colors: widget.isEnabled
                      ? [
                          AppColors.button,
                          AppColors.buttonLight,
                        ]
                      : [
                          AppColors.inputBorder,
                          AppColors.inputBorder,
                        ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: widget.isEnabled
                    ? [
                        BoxShadow(
                          color: AppColors.button.withValues(alpha: 0.3),
                          blurRadius: ResponsiveUtils.rp(12),
                          offset: Offset(0, ResponsiveUtils.rp(4)),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  // Progress fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                    width: displayPosition + _buttonSize + _horizontalPadding,
                    height: _containerHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
                      color: Colors.white.withValues(alpha: 0.15 * _dragPercentage),
                    ),
                  ),

                  // Center text with arrows
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _isSubmitted ? 0 : (1 - _dragPercentage * 0.7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Left animated arrows
                          if (widget.isEnabled && !_isSubmitted) ...[
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _pulseAnimation.value * 0.5,
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white,
                                    size: ResponsiveUtils.rp(20),
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _pulseAnimation.value * 0.7,
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white,
                                    size: ResponsiveUtils.rp(20),
                                  ),
                                );
                              },
                            ),
                          ],
                          SizedBox(width: ResponsiveUtils.rp(4)),
                          // Text
                          Text(
                            widget.amount.isNotEmpty
                                ? '${widget.text} - ${widget.amount}'
                                : widget.text,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(15),
                              fontWeight: FontWeight.bold,
                              color: widget.isEnabled
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: ResponsiveUtils.rp(4)),
                          // Right animated arrows
                          if (widget.isEnabled && !_isSubmitted) ...[
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _pulseAnimation.value * 0.7,
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white,
                                    size: ResponsiveUtils.rp(20),
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _pulseAnimation.value * 0.5,
                                  child: Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white,
                                    size: ResponsiveUtils.rp(20),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Success checkmark
                  if (_isSubmitted)
                    Center(
                      child: AnimatedBuilder(
                        animation: _successAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _successAnimation.value,
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: ResponsiveUtils.rp(32),
                            ),
                          );
                        },
                      ),
                    ),

                  // Draggable button
                  Positioned(
                    left: _horizontalPadding + displayPosition,
                    top: (_containerHeight - _buttonSize) / 2,
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        width: _buttonSize,
                        height: _buttonSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(14)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: ResponsiveUtils.rp(8),
                              offset: Offset(ResponsiveUtils.rp(2), ResponsiveUtils.rp(2)),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isSubmitted
                              ? Icon(
                                  Icons.check_rounded,
                                  color: AppColors.button,
                                  size: ResponsiveUtils.rp(24),
                                )
                              : Icon(
                                  Icons.arrow_forward_rounded,
                                  color: widget.isEnabled
                                      ? AppColors.button
                                      : AppColors.textSecondary,
                                  size: ResponsiveUtils.rp(24),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        );
      },
      ),
    );
  }

  Widget _buildLoadingState() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      height: _containerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        color: AppColors.inputBorder,
      ),
      child: Center(
        child: SizedBox(
          width: ResponsiveUtils.rp(24),
          height: ResponsiveUtils.rp(24),
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
          ),
        ),
      ),
    );
  }
}
