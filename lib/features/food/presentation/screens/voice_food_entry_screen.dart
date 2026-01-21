import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../services/api_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/home_provider.dart';

class VoiceFoodEntryScreen extends ConsumerStatefulWidget {
  const VoiceFoodEntryScreen({super.key});

  @override
  ConsumerState<VoiceFoodEntryScreen> createState() => _VoiceFoodEntryScreenState();
}

class _VoiceFoodEntryScreenState extends ConsumerState<VoiceFoodEntryScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isAnalyzing = false;
  bool _speechAvailable = false;
  String _transcribedText = '';
  FoodAnalysisResult? _analysisResult;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (_isListening) {
            setState(() => _isListening = false);
            if (_transcribedText.isNotEmpty) {
              _analyzeFood();
            }
          }
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
      },
    );
    setState(() {});
  }

  Future<void> _startListening() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    setState(() {
      _isListening = true;
      _transcribedText = '';
      _analysisResult = null;
    });

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _transcribedText = result.recognizedWords;
        });
      },
      localeId: Localizations.localeOf(context).languageCode,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    if (_transcribedText.isNotEmpty) {
      _analyzeFood();
    }
  }

  Future<void> _analyzeFood() async {
    if (_transcribedText.isEmpty) return;

    setState(() => _isAnalyzing = true);

    try {
      // Use the text to create a food entry with estimated values
      // In a real app, you'd call an AI API to analyze the text
      final result = await _estimateFoodFromText(_transcribedText);
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error analyzing: $e')),
        );
      }
    }
  }

  Future<FoodAnalysisResult> _estimateFoodFromText(String text) async {
    // Simple estimation based on common foods
    // In production, this would call an AI API
    final lowerText = text.toLowerCase();

    int calories = 200;
    double protein = 10;
    double carbs = 25;
    double fat = 8;
    String name = text;

    // Simple keyword matching for demo
    if (lowerText.contains('chicken') || lowerText.contains('닭')) {
      calories = 250;
      protein = 30;
      carbs = 0;
      fat = 10;
    } else if (lowerText.contains('rice') || lowerText.contains('밥')) {
      calories = 200;
      protein = 4;
      carbs = 45;
      fat = 0;
    } else if (lowerText.contains('salad') || lowerText.contains('샐러드')) {
      calories = 150;
      protein = 5;
      carbs = 15;
      fat = 8;
    } else if (lowerText.contains('pizza') || lowerText.contains('피자')) {
      calories = 350;
      protein = 15;
      carbs = 40;
      fat = 15;
    } else if (lowerText.contains('burger') || lowerText.contains('버거')) {
      calories = 500;
      protein = 25;
      carbs = 40;
      fat = 25;
    } else if (lowerText.contains('egg') || lowerText.contains('계란')) {
      calories = 78;
      protein = 6;
      carbs = 1;
      fat = 5;
    } else if (lowerText.contains('apple') || lowerText.contains('사과')) {
      calories = 95;
      protein = 0;
      carbs = 25;
      fat = 0;
    } else if (lowerText.contains('banana') || lowerText.contains('바나나')) {
      calories = 105;
      protein = 1;
      carbs = 27;
      fat = 0;
    }

    return FoodAnalysisResult(
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      fiber: 2.0,
      sugar: 5.0,
      sodium: 200.0,
      healthScore: 70,
      ingredients: [],
    );
  }

  Future<void> _logFood() async {
    if (_analysisResult == null) return;

    final l10n = AppLocalizations.of(context)!;
    final authState = ref.read(authStateProvider);

    if (authState.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSignInToLogFood)),
      );
      return;
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.createFoodEntry(
        userId: authState.userId!,
        name: _analysisResult!.name,
        calories: _analysisResult!.calories,
        protein: _analysisResult!.protein,
        carbs: _analysisResult!.carbs,
        fat: _analysisResult!.fat,
      );

      ref.invalidate(dailySummaryProvider(DateTime.now()));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 8),
                Text(l10n.foodLogged),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
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
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.cardColor,
            ),
            child: Icon(
              Icons.arrow_back,
              color: context.textPrimaryColor,
              size: 20,
            ),
          ),
        ),
        title: Text(
          l10n.voiceRecording,
          style: TextStyle(
            color: context.textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            // Microphone button
            GestureDetector(
              onTap: _isListening ? _stopListening : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isListening ? 160 : 120,
                height: _isListening ? 160 : 120,
                decoration: BoxDecoration(
                  color: _isListening ? AppColors.error : AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? AppColors.error : AppColors.primary)
                          .withValues(alpha: 0.3),
                      blurRadius: _isListening ? 30 : 20,
                      spreadRadius: _isListening ? 10 : 5,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  size: 48,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Status text
            Text(
              _isListening
                  ? l10n.recording
                  : _isAnalyzing
                      ? l10n.analyzing
                      : l10n.tapToRecord,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isListening ? l10n.speakNow : '',
              style: TextStyle(
                fontSize: 14,
                color: context.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),

            // Transcribed text
            if (_transcribedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recognized:',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _transcribedText,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),

            // Analysis result
            if (_analysisResult != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _analysisResult!.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNutrientInfo(l10n.calories, '${_analysisResult!.calories}', 'cal'),
                        _buildNutrientInfo(l10n.protein, _analysisResult!.protein.toStringAsFixed(0), 'g'),
                        _buildNutrientInfo(l10n.carbs, _analysisResult!.carbs.toStringAsFixed(0), 'g'),
                        _buildNutrientInfo(l10n.fat, _analysisResult!.fat.toStringAsFixed(0), 'g'),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Loading indicator
            if (_isAnalyzing)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),

            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: _analysisResult != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _logFood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.log,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildNutrientInfo(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value$unit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: context.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}
