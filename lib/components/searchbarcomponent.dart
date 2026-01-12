import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/banner/bannercontroller.dart';
import '../controllers/utilitycontroller/utilitycontroller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/responsive_widgets.dart';
import '../widgets/responsive_spacing.dart';
import '../utils/navigation_helper.dart';
import '../widgets/shimmers.dart';
import '../services/speech_recognition_service.dart';

class SearchComponent extends StatelessWidget {
  const SearchComponent({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search products...',
  }) : super(key: key);

  final Function(String) onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/search');
      },
      child: ResponsiveContainer(
        height: ResponsiveUtils.rp(44),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(14.0)),
        backgroundColor: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: ResponsiveUtils.rp(8),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
        child: Row(
          children: [
            ResponsiveIcon(Icons.search,
                color: AppColors.textSecondary, size: 20),
            ResponsiveSpacing.horizontal(10),
            Expanded(
              child: ResponsiveText(
                hintText,
                style: ResponsiveTextStyles.bodyMedium(
                    color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenSearchPage extends StatefulWidget {
  const FullScreenSearchPage({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search products...',
  }) : super(key: key);

  final Function(String) onSearch;
  final String hintText;

  @override
  State<FullScreenSearchPage> createState() => _FullScreenSearchPageState();
}

class _FullScreenSearchPageState extends State<FullScreenSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  final _speechService = SpeechRecognitionService();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    
    // Initialize speech recognition
    _speechService.initialize();
    
    // Check if speech recognition should start automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args['startSpeechRecognition'] == true) {
        _startSpeechRecognition();
      }
    });
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final text = _controller.text.trim();
      widget.onSearch(text); // trigger BannerController search
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _speechService.stopListening();
    _controller.dispose();
    super.dispose();
  }

  /// Show voice search dialog
  void _showVoiceSearchDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => VoiceSearchDialog(
        speechService: _speechService,
        isListening: _isListening,
        onListeningStateChanged: (listening) {
      setState(() {
            _isListening = listening;
    });
        },
      onResult: (text) {
        if (mounted) {
          setState(() {
            _controller.text = text;
            _isListening = _speechService.isListening;
          });
          
          // Trigger search when final result is received
          if (!_speechService.isListening && text.isNotEmpty) {
            widget.onSearch(text);
            final bannerController = Get.find<BannerController>();
            bannerController.searchProducts({'term': text});
          }
            
            // Close dialog when done listening
            if (!_speechService.isListening) {
              Navigator.of(dialogContext).pop();
            }
        }
      },
      onError: () {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
          Get.snackbar(
            'Error',
            'Could not start speech recognition. Please check microphone permissions.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.card,
            colorText: AppColors.textPrimary,
          );
        }
      },
      ),
    );
  }

  /// Start speech recognition - shows dialog
  void _startSpeechRecognition() {
    _showVoiceSearchDialog();
  }

  @override
  Widget build(BuildContext context) {
    final BannerController bannerController = Get.find<BannerController>();
    final UtilityController utilityController = Get.find<UtilityController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Microphone icon
                IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.red : AppColors.textSecondary,
                  ),
                  onPressed: _startSpeechRecognition,
                  tooltip: _isListening ? 'Stop listening' : 'Start voice search',
                ),
                // Clear icon (if text exists)
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      bannerController.searchResults.clear(); // reset results
                    },
                  ),
              ],
            ),
          ),
          style: TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Obx(() {
        final results = bannerController.searchResults;
        final isLoading = utilityController.isLoadingRx.value;

        if (isLoading && results.isEmpty) {
          return _buildShimmerList();
        }

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: ResponsiveUtils.rp(64),
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: ResponsiveSpacing.padding(all: 16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return _buildSearchResultCard(item);
          },
        );
      }),
    );
  }

  /// Build search result card with box structure
  Widget _buildSearchResultCard(item) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.1),
            blurRadius: ResponsiveUtils.rp(4),
            offset: Offset(0, ResponsiveUtils.rp(2)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            NavigationHelper.navigateToProductDetail(
              productId: item.productId,
              productName: item.productName,
            );
          },
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
            child: Row(
              children: [
                // Product Image with shimmer
                ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  child: _buildProductImage(item.productAsset?.preview),
                ),
                ResponsiveSpacing.horizontal(12),
                // Product Name
                Expanded(
                  child: Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: AppColors.icon.withValues(alpha: 0.5),
                  size: ResponsiveUtils.rp(24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build shimmer list for loading state
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: ResponsiveSpacing.padding(all: 16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(12)),
          padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Image shimmer
              Skeletons.imageRect(
                height: ResponsiveUtils.rp(80),
                width: ResponsiveUtils.rp(80),
                radius: 8,
              ),
              ResponsiveSpacing.horizontal(12),
              // Text shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeletons.textLine(
                      height: ResponsiveUtils.rp(16),
                      width: double.infinity,
                    ),
                    SizedBox(height: ResponsiveUtils.rp(8)),
                    Skeletons.textLine(
                      height: ResponsiveUtils.rp(14),
                      width: ResponsiveUtils.rp(120),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build product image with shimmer on loading and error
  Widget _buildProductImage(String? imageUrl) {
    final imageSize = ResponsiveUtils.rp(80);
    
    // Show shimmer if no image URL
    if (imageUrl == null || imageUrl.isEmpty) {
      return Skeletons.imageRect(
        height: imageSize,
        width: imageSize,
        radius: 8,
      );
    }

    return SizedBox(
      width: imageSize,
      height: imageSize,
      child: Image.network(
        imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          // Show shimmer while loading
          return Skeletons.imageRect(
            height: imageSize,
            width: imageSize,
            radius: 8,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Show shimmer on error instead of error message
          return Skeletons.imageRect(
            height: imageSize,
            width: imageSize,
            radius: 8,
          );
        },
      ),
    );
  }
}

/// Voice Search Dialog Widget
class VoiceSearchDialog extends StatefulWidget {
  final SpeechRecognitionService speechService;
  final bool isListening;
  final Function(bool) onListeningStateChanged;
  final Function(String) onResult;
  final Function() onError;

  const VoiceSearchDialog({
    Key? key,
    required this.speechService,
    required this.isListening,
    required this.onListeningStateChanged,
    required this.onResult,
    required this.onError,
  }) : super(key: key);

  @override
  State<VoiceSearchDialog> createState() => _VoiceSearchDialogState();
}

class _VoiceSearchDialogState extends State<VoiceSearchDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _isListening = widget.isListening;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Start listening if not already listening
    if (!_isListening) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _toggleListening();
      });
    } else {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      // Stop listening
      await widget.speechService.stopListening();
      setState(() {
        _isListening = false;
      });
      widget.onListeningStateChanged(false);
      _animationController.stop();
    } else {
      // Start listening
      setState(() {
        _isListening = true;
        _recognizedText = '';
      });
      widget.onListeningStateChanged(true);
      _animationController.repeat(reverse: true);

      await widget.speechService.startListening(
        onResult: (text) {
          if (mounted) {
            setState(() {
              _recognizedText = text;
              _isListening = widget.speechService.isListening;
            });

            // If listening stopped, update state
            if (!_isListening) {
              widget.onListeningStateChanged(false);
              _animationController.stop();
              widget.onResult(text);
              // Close dialog after a short delay
              Future.delayed(Duration(milliseconds: 500), () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              });
            } else {
              // Update recognized text in real-time
              widget.onResult(text);
            }
          }
        },
        onError: () {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
            widget.onListeningStateChanged(false);
            _animationController.stop();
            widget.onError();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(24)),
        constraints: BoxConstraints(
          maxWidth: ResponsiveUtils.rp(320),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Voice Search',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(20),
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(24)),
            
            // Listening indicator
            Text(
              _isListening ? 'Listening...' : 'Tap mic to start listening',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16),
                color: _isListening ? AppColors.success : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(20)),
            
            // Recognized text display
            if (_recognizedText.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                constraints: BoxConstraints(
                  maxHeight: ResponsiveUtils.rp(100),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _recognizedText,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(14),
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.rp(20)),
            ],
            
            // Animated microphone button
            GestureDetector(
              onTap: _toggleListening,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    width: ResponsiveUtils.rp(80),
                    height: ResponsiveUtils.rp(80),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isListening
                          ? AppColors.error.withValues(alpha: 0.2 + (_animationController.value * 0.3))
                          : AppColors.button.withValues(alpha: 0.1),
                      border: Border.all(
                        color: _isListening
                            ? AppColors.error
                            : AppColors.button,
                        width: ResponsiveUtils.rp(3),
                      ),
                    ),
                    child: Icon(
                      Icons.mic,
                      size: ResponsiveUtils.rp(40),
                      color: _isListening ? AppColors.error : AppColors.button,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(24)),
            
            // Close button
            TextButton(
              onPressed: () {
                if (_isListening) {
                  widget.speechService.stopListening();
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
