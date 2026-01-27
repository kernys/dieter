import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../services/api_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../providers/camera_provider.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  double _baseZoom = 1.0;
  double _currentZoom = 1.0;
  MobileScannerController? _barcodeScannerController;
  bool _isProcessingBarcode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cameraAsync = ref.watch(cameraControllerProvider);
    final scanMode = ref.watch(scanModeProvider);
    final analysisState = ref.watch(analysisStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview - switch between regular camera and barcode scanner
          if (scanMode == ScanMode.barcode)
            _buildBarcodeScanner(l10n)
          else
            cameraAsync.when(
              data: (controller) {
                if (controller == null || !controller.value.isInitialized) {
                  return Center(
                    child: Text(
                      l10n.cameraNotAvailable,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return GestureDetector(
                  onScaleStart: (details) {
                    _baseZoom = _currentZoom;
                  },
                  onScaleUpdate: (details) {
                    final cameraNotifier = ref.read(cameraControllerProvider.notifier);
                    final newZoom = (_baseZoom * details.scale).clamp(
                      cameraNotifier.minZoom,
                      cameraNotifier.maxZoom,
                    );
                    setState(() {
                      _currentZoom = newZoom;
                    });
                    cameraNotifier.setZoomLevel(newZoom);
                  },
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.value.previewSize?.height ?? 0,
                        height: controller.value.previewSize?.width ?? 0,
                        child: CameraPreview(controller),
                      ),
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
                      l10n.cameraError(error.toString()),
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _pickFromGallery(),
                      child: Text(l10n.pickFromGallery),
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
                          const Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.appTitle,
                            style: const TextStyle(
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
                          _showHelpDialog(l10n);
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
                        label: l10n.scanFood,
                        icon: Icons.restaurant_outlined,
                        isSelected: scanMode == ScanMode.food,
                        onPressed: () {
                          ref.read(scanModeProvider.notifier).state = ScanMode.food;
                        },
                      ),
                      _ScanModeButton(
                        label: l10n.barcode,
                        icon: Icons.qr_code,
                        isSelected: scanMode == ScanMode.barcode,
                        onPressed: () {
                          ref.read(scanModeProvider.notifier).state = ScanMode.barcode;
                          _showBarcodeInfo();
                        },
                      ),
                      _ScanModeButton(
                        label: l10n.foodLabel,
                        icon: Icons.description_outlined,
                        isSelected: scanMode == ScanMode.label,
                        onPressed: () {
                          ref.read(scanModeProvider.notifier).state = ScanMode.label;
                          _showNutritionLabelInfo();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Zoom Indicator
                _buildZoomControls(ref),
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
                      Text(
                        l10n.analyzingFood,
                        style: const TextStyle(
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.failedToCaptureImage)),
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
      final locale = Localizations.localeOf(context).languageCode;
      final l10n = AppLocalizations.of(context)!;
      
      // Get the selected date from home screen
      final selectedDate = ref.read(selectedDateProvider);

      // Analyze and auto-register the food in one API call
      final result = await apiService.analyzeFoodAndRegister(
        imageBytes,
        locale: locale,
        autoRegister: true,
        loggedAt: selectedDate, // Use selected date for registration
      );

      ref.read(analysisResultProvider.notifier).state = result;
      ref.read(analysisStateProvider.notifier).state = AnalysisState.success;

      // Refresh the daily summary and progress data
      ref.invalidate(dailySummaryProvider(selectedDate));
      ref.invalidate(weeklyEnergyDataProvider);
      ref.invalidate(streakDataProvider);
      ref.invalidate(dailyAverageCaloriesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.foodRegistered),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      ref.read(analysisStateProvider.notifier).state = AnalysisState.error;
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.analysisFailed(e.toString()))),
        );
      }
    }
  }

  Widget _buildZoomControls(WidgetRef ref) {
    final cameraNotifier = ref.read(cameraControllerProvider.notifier);
    final minZoom = cameraNotifier.minZoom;
    final maxZoom = cameraNotifier.maxZoom;

    // Determine which button should be selected based on closest zoom level
    String selectedZoom;
    if (_currentZoom < 0.75) {
      selectedZoom = '.5x';
    } else if (_currentZoom < 1.5) {
      selectedZoom = '1x';
    } else {
      selectedZoom = '2x';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 0.5x button
          GestureDetector(
            onTap: () {
              final newZoom = 0.5.clamp(minZoom, maxZoom);
              setState(() => _currentZoom = newZoom);
              cameraNotifier.setZoomLevel(newZoom);
            },
            child: _buildZoomButton(
              label: '.5x',
              isSelected: selectedZoom == '.5x',
              enabled: minZoom <= 0.5,
            ),
          ),
          const SizedBox(width: 8),
          // 1x button
          GestureDetector(
            onTap: () {
              final newZoom = 1.0.clamp(minZoom, maxZoom);
              setState(() => _currentZoom = newZoom);
              cameraNotifier.setZoomLevel(newZoom);
            },
            child: _buildZoomButton(
              label: '1x',
              isSelected: selectedZoom == '1x',
            ),
          ),
          const SizedBox(width: 8),
          // 2x button
          GestureDetector(
            onTap: () {
              if (maxZoom >= 2.0) {
                setState(() => _currentZoom = 2.0);
                cameraNotifier.setZoomLevel(2.0);
              }
            },
            child: _buildZoomButton(
              label: '2x',
              isSelected: selectedZoom == '2x',
              enabled: maxZoom >= 2.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton({
    required String label,
    required bool isSelected,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white24 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: enabled ? (isSelected ? Colors.white : Colors.white54) : Colors.white24,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  void _showHelpDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.howToUse),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.howToUseStep1),
            const SizedBox(height: 8),
            Text(l10n.howToUseStep2),
            const SizedBox(height: 8),
            Text(l10n.howToUseStep3),
            const SizedBox(height: 8),
            Text(l10n.howToUseStep4),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.gotIt),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeScanner(AppLocalizations l10n) {
    _barcodeScannerController ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    return Stack(
      children: [
        MobileScanner(
          controller: _barcodeScannerController!,
          onDetect: (capture) {
            if (_isProcessingBarcode) return;

            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                _handleBarcodeDetected(barcode.rawValue!, l10n);
                break;
              }
            }
          },
        ),
        // Dimming overlay with scan box
        _buildScanOverlay(l10n, isBarcode: true),
      ],
    );
  }

  Widget _buildScanOverlay(AppLocalizations l10n, {required bool isBarcode}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // Scan box dimensions
        final boxWidth = screenWidth * 0.75;
        final boxHeight = isBarcode ? 120.0 : screenWidth * 0.6;
        final boxLeft = (screenWidth - boxWidth) / 2;
        final boxTop = (screenHeight - boxHeight) / 2 - 50;

        return Stack(
          children: [
            // Top dimming
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: boxTop,
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),
            // Bottom dimming
            Positioned(
              top: boxTop + boxHeight,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),
            // Left dimming
            Positioned(
              top: boxTop,
              left: 0,
              width: boxLeft,
              height: boxHeight,
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),
            // Right dimming
            Positioned(
              top: boxTop,
              right: 0,
              width: boxLeft,
              height: boxHeight,
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
            ),
            // Scan box border with corner accents
            Positioned(
              top: boxTop,
              left: boxLeft,
              child: SizedBox(
                width: boxWidth,
                height: boxHeight,
                child: CustomPaint(
                  painter: _ScanBoxPainter(),
                ),
              ),
            ),
            // Hint text below box
            Positioned(
              top: boxTop + boxHeight + 24,
              left: 0,
              right: 0,
              child: Text(
                l10n.positionBarcodeInFrame,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleBarcodeDetected(String barcodeValue, AppLocalizations l10n) async {
    if (_isProcessingBarcode) return;

    setState(() => _isProcessingBarcode = true);
    ref.read(analysisStateProvider.notifier).state = AnalysisState.analyzing;

    try {
      final apiService = ref.read(apiServiceProvider);
      final result = await apiService.searchBarcode(barcodeValue);

      if (result.found && result.name != null) {
        // Show result dialog
        if (mounted) {
          _showBarcodeResultDialog(result, l10n);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noSearchResults)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.analysisFailed(e.toString()))),
        );
      }
    } finally {
      ref.read(analysisStateProvider.notifier).state = AnalysisState.idle;
      // Allow scanning again after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isProcessingBarcode = false);
        }
      });
    }
  }

  void _showBarcodeResultDialog(BarcodeSearchResult result, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.name ?? l10n.unknownProduct,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (result.brand != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.brand!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildNutrientRowBarcode(l10n.calories, '${result.calories ?? 0}', l10n.cal),
                        const SizedBox(height: 8),
                        _buildNutrientRowBarcode(l10n.protein, '${result.protein?.toStringAsFixed(1) ?? 0}', 'g'),
                        const SizedBox(height: 8),
                        _buildNutrientRowBarcode(l10n.carbs, '${result.carbs?.toStringAsFixed(1) ?? 0}', 'g'),
                        const SizedBox(height: 8),
                        _buildNutrientRowBarcode(l10n.fat, '${result.fat?.toStringAsFixed(1) ?? 0}', 'g'),
                      ],
                    ),
                  ),
                  if (result.servingSize != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.servings}: ${result.servingSize}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logBarcodeFood(result, l10n);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        l10n.log,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRowBarcode(String label, String value, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _logBarcodeFood(BarcodeSearchResult result, AppLocalizations l10n) async {
    final authState = ref.read(authStateProvider);
    if (authState.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSignInToLogFood)),
      );
      return;
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      final selectedDate = ref.read(selectedDateProvider);
      
      await apiService.createFoodEntry(
        name: result.name ?? l10n.unknownProduct,
        calories: result.calories ?? 0,
        protein: result.protein ?? 0,
        carbs: result.carbs ?? 0,
        fat: result.fat ?? 0,
        loggedAt: selectedDate,
      );

      // Refresh daily summary and progress data
      ref.invalidate(dailySummaryProvider(selectedDate));
      ref.invalidate(weeklyEnergyDataProvider);
      ref.invalidate(streakDataProvider);
      ref.invalidate(dailyAverageCaloriesProvider);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.foodLogged)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorLoggingFood)),
        );
      }
    }
  }

  @override
  void dispose() {
    _barcodeScannerController?.dispose();
    super.dispose();
  }

  void _showBarcodeInfo() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showHelpDialog(AppLocalizations.of(context)!),
                    child: const Icon(Icons.help_outline, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
            // Barcode illustration
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 48),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    size: 80,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      12,
                      (index) => Container(
                        width: index % 3 == 0 ? 4 : 2,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              l10n.barcodeScanner,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.barcodeScannerDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _buildBarcodeTip(Icons.lightbulb_outline, l10n.barcodeTip1),
                  const SizedBox(height: 8),
                  _buildBarcodeTip(Icons.center_focus_strong, l10n.barcodeTip2),
                  const SizedBox(height: 8),
                  _buildBarcodeTip(Icons.straighten, l10n.barcodeTip3),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Got it button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  l10n.gotIt,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeTip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }

  void _showNutritionLabelInfo() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showHelpDialog(AppLocalizations.of(context)!),
                    child: const Icon(Icons.help_outline, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
            // Nutrition Facts Image
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 48),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nutrition Facts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    '2 servings per container',
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const Text(
                    'Serving size    3/4 cup (170g)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(color: Colors.black, thickness: 8, height: 16),
                  const Text(
                    'Amount per serving',
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Calories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '130',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.black, thickness: 4, height: 8),
                  _buildNutritionRow('Total Fat', '4g', '5%'),
                  _buildNutritionRow('  Saturated Fat', '2.5g', '13%', isIndented: true),
                  _buildNutritionRow('Cholesterol', '15mg', '5%'),
                  _buildNutritionRow('Sodium', '55mg', '2%'),
                  _buildNutritionRow('Total Carbohydrate', '6g', '2%'),
                  _buildNutritionRow('Protein', '15g', '5%'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Text(
              l10n.nutritionLabelScanner,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                l10n.nutritionLabelDescription,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Got it button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  l10n.gotIt,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, String percent, {bool isIndented = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isIndented ? 10 : 11,
                fontWeight: isIndented ? FontWeight.normal : FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Text(
            percent,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const cornerLength = 24.0;
    const radius = 8.0;

    // Top-left corner
    final topLeftPath = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..lineTo(cornerLength, 0);
    canvas.drawPath(topLeftPath, paint);

    // Top-right corner
    final topRightPath = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(topRightPath, paint);

    // Bottom-left corner
    final bottomLeftPath = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - radius)
      ..quadraticBezierTo(0, size.height, radius, size.height)
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(bottomLeftPath, paint);

    // Bottom-right corner
    final bottomRightPath = Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, size.height - cornerLength);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
