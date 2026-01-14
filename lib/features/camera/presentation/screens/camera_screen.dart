import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../services/api_service.dart';
import '../providers/camera_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final cameraAsync = ref.watch(cameraControllerProvider);
    final scanMode = ref.watch(scanModeProvider);
    final analysisState = ref.watch(analysisStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          cameraAsync.when(
            data: (controller) {
              if (controller == null || !controller.value.isInitialized) {
                return const Center(
                  child: Text(
                    'Camera not available',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.previewSize?.height ?? 0,
                    height: controller.value.previewSize?.width ?? 0,
                    child: CameraPreview(controller),
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Camera error: $error',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _pickFromGallery(),
                    child: const Text('Pick from Gallery'),
                  ),
                ],
              ),
            ),
          ),

          // Overlay UI
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _IconButton(
                        icon: Icons.close,
                        onPressed: () => context.pop(),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.apple,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Dieter AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      _IconButton(
                        icon: Icons.help_outline,
                        onPressed: () {
                          _showHelpDialog();
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Scan Mode Selector
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 48),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      _ScanModeButton(
                        label: 'Scan Food',
                        icon: Icons.restaurant_outlined,
                        isSelected: scanMode == ScanMode.food,
                        onPressed: () {
                          ref.read(scanModeProvider.notifier).state = ScanMode.food;
                        },
                      ),
                      _ScanModeButton(
                        label: 'Barcode',
                        icon: Icons.qr_code,
                        isSelected: scanMode == ScanMode.barcode,
                        onPressed: () {
                          ref.read(scanModeProvider.notifier).state = ScanMode.barcode;
                        },
                      ),
                      _ScanModeButton(
                        label: 'Food Label',
                        icon: Icons.description_outlined,
                        isSelected: scanMode == ScanMode.label,
                        onPressed: () {
                          ref.read(scanModeProvider.notifier).state = ScanMode.label;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Zoom Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '.5x',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '1x',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Flash Button
                      _IconButton(
                        icon: _getFlashIcon(cameraAsync.valueOrNull),
                        onPressed: () {
                          ref.read(cameraControllerProvider.notifier).toggleFlash();
                        },
                      ),

                      // Capture Button
                      GestureDetector(
                        onTap: analysisState == AnalysisState.analyzing
                            ? null
                            : () => _captureAndAnalyze(),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Center(
                            child: analysisState == AnalysisState.analyzing
                                ? const SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Container(
                                    width: 56,
                                    height: 56,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      // Gallery Button
                      _IconButton(
                        icon: Icons.photo_library_outlined,
                        onPressed: () => _pickFromGallery(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),

          // Loading Overlay
          if (analysisState == AnalysisState.analyzing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text(
                        'Analyzing food...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getFlashIcon(CameraController? controller) {
    if (controller == null) return Icons.flash_off;

    switch (controller.value.flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }

  Future<void> _captureAndAnalyze() async {
    ref.read(analysisStateProvider.notifier).state = AnalysisState.capturing;

    final imageBytes = await ref.read(cameraControllerProvider.notifier).takePicture();

    if (imageBytes != null) {
      await _analyzeImage(imageBytes);
    } else {
      ref.read(analysisStateProvider.notifier).state = AnalysisState.error;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      await _analyzeImage(bytes);
    }
  }

  Future<void> _analyzeImage(Uint8List imageBytes) async {
    ref.read(analysisStateProvider.notifier).state = AnalysisState.analyzing;
    ref.read(capturedImageProvider.notifier).state = imageBytes;

    try {
      final apiService = ref.read(apiServiceProvider);
      final result = await apiService.analyzeFood(imageBytes);

      ref.read(analysisResultProvider.notifier).state = result;
      ref.read(analysisStateProvider.notifier).state = AnalysisState.success;

      if (mounted) {
        context.push('/food/new', extra: {
          'imageBytes': imageBytes,
          'analysisResult': result,
        });
      }
    } catch (e) {
      ref.read(analysisStateProvider.notifier).state = AnalysisState.error;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to use'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Point your camera at the food'),
            SizedBox(height: 8),
            Text('2. Make sure the food is well-lit'),
            SizedBox(height: 8),
            Text('3. Tap the capture button'),
            SizedBox(height: 8),
            Text('4. Our AI will analyze the nutritional content'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _ScanModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ScanModeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.black : Colors.white70,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.white70,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
