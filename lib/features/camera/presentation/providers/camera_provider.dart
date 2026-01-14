import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../../../../services/api_service.dart';

// Camera controller provider
final cameraControllerProvider = StateNotifierProvider<CameraControllerNotifier, AsyncValue<CameraController?>>((ref) {
  return CameraControllerNotifier();
});

class CameraControllerNotifier extends StateNotifier<AsyncValue<CameraController?>> {
  CameraControllerNotifier() : super(const AsyncValue.loading()) {
    _initCamera();
  }

  CameraController? _controller;

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        state = AsyncValue.error('No cameras available', StackTrace.current);
        return;
      }

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      state = AsyncValue.data(_controller);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<Uint8List?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      final XFile file = await _controller!.takePicture();
      return await file.readAsBytes();
    } catch (e) {
      return null;
    }
  }

  void toggleFlash() async {
    if (_controller == null) return;

    final currentFlashMode = _controller!.value.flashMode;
    FlashMode newMode;

    switch (currentFlashMode) {
      case FlashMode.off:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.always;
        break;
      case FlashMode.always:
        newMode = FlashMode.off;
        break;
      default:
        newMode = FlashMode.off;
    }

    await _controller!.setFlashMode(newMode);
    state = AsyncValue.data(_controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

// Analysis state provider
enum AnalysisState { idle, capturing, analyzing, success, error }

final analysisStateProvider = StateProvider<AnalysisState>((ref) {
  return AnalysisState.idle;
});

// Analysis result provider - now uses API response type
final analysisResultProvider = StateProvider<FoodAnalysisResult?>((ref) {
  return null;
});

// Captured image provider
final capturedImageProvider = StateProvider<Uint8List?>((ref) {
  return null;
});

// Scan mode provider
enum ScanMode { food, barcode, label }

final scanModeProvider = StateProvider<ScanMode>((ref) {
  return ScanMode.food;
});

// Food analyzer notifier - handles the analysis process
class FoodAnalyzerNotifier extends StateNotifier<AsyncValue<FoodAnalysisResult?>> {
  final ApiService _apiService;

  FoodAnalyzerNotifier(this._apiService) : super(const AsyncValue.data(null));

  Future<FoodAnalysisResult?> analyzeFood(Uint8List imageBytes) async {
    state = const AsyncValue.loading();

    try {
      final result = await _apiService.analyzeFood(imageBytes);
      state = AsyncValue.data(result);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final foodAnalyzerProvider = StateNotifierProvider<FoodAnalyzerNotifier, AsyncValue<FoodAnalysisResult?>>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FoodAnalyzerNotifier(apiService);
});
