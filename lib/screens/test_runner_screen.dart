import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/ishihara_dataset.dart';
import '../data/local_storage_service.dart';
import '../data/models/ishihara_plate.dart';
import '../data/models/test_result.dart';
import '../widgets/custom_dialpad.dart';
import '../widgets/ishihara_canvas.dart';
import '../core/services/unity_ads_service.dart';
import 'test_result_screen.dart';

class TestRunnerScreen extends StatefulWidget {
  final String testMode;
  final int timerPerPlate; // 0 = unlimited, 3, 5

  const TestRunnerScreen({
    super.key,
    required this.testMode,
    this.timerPerPlate = 0,
  });

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen> {
  late List<IshiharaPlate> _plates;
  int _currentIndex = 0;
  String _currentInput = '';
  final List<UserPlateAnswer> _answers = [];

  Timer? _countdownTimer;
  int _secondsLeft = 0;
  int _plateStartTime = 0;
  bool _hapticEnabled = true;

  @override
  void initState() {
    super.initState();
    _plates = IshiharaDataset.getPlatesForMode(widget.testMode);
    _loadHapticSetting();
    // Pra-muat iklan interstitial agar siap tampil di akhir tes
    UnityAdsService().loadInterstitial();
    _startPlateTimer();
  }

  Future<void> _loadHapticSetting() async {
    final haptic = await LocalStorageService().getHapticEnabled();
    if (mounted) {
      setState(() {
        _hapticEnabled = haptic;
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startPlateTimer() {
    _plateStartTime = DateTime.now().millisecondsSinceEpoch;
    _currentInput = '';

    _countdownTimer?.cancel();
    if (widget.timerPerPlate > 0) {
      _secondsLeft = widget.timerPerPlate;
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_secondsLeft > 1) {
            _secondsLeft--;
          } else {
            _countdownTimer?.cancel();
            _submitAnswer();
          }
        });
      });
    }
  }

  void _onDigitPressed(String digit) {
    if (_currentInput == 'BLANK') {
      _currentInput = '';
    }
    if (_currentInput.length < 3) {
      setState(() {
        _currentInput += digit;
      });
    }
  }

  void _onBackspace() {
    if (_currentInput.isNotEmpty) {
      setState(() {
        if (_currentInput == 'BLANK') {
          _currentInput = '';
        } else {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
        }
      });
    }
  }

  void _onBlankPressed() {
    setState(() {
      _currentInput = 'BLANK';
    });
  }

  void _submitAnswer() {
    final responseTime = DateTime.now().millisecondsSinceEpoch - _plateStartTime;
    final currentPlate = _plates[_currentIndex];
    final isCorrect = currentPlate.isCorrect(_currentInput);

    _answers.add(
      UserPlateAnswer(
        plateId: currentPlate.id,
        plateNumber: currentPlate.plateNumber,
        userAnswer: _currentInput,
        normalAnswer: currentPlate.normalAnswer,
        deficiencyAnswer: currentPlate.deficiencyAnswer,
        plateType: currentPlate.plateType,
        isCorrect: isCorrect,
        responseTimeMs: responseTime,
      ),
    );

    if (_currentIndex < _plates.length - 1) {
      setState(() {
        _currentIndex++;
        _startPlateTimer();
      });
    } else {
      _finishTest();
    }
  }

  Future<void> _finishTest() async {
    _countdownTimer?.cancel();

    final result = IshiharaDataset.evaluateTest(
      testMode: widget.testMode,
      answers: _answers,
    );

    await LocalStorageService().saveTestResult(result);

    if (!mounted) return;

    UnityAdsService().showInterstitial(
      onDismissed: () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TestResultScreen(result: result),
          ),
        );
      },
    );
  }

  Future<void> _showExitConfirmDialog() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hentikan Tes?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text(
          'Proses pemeriksaan yang sedang berlangsung tidak akan tersimpan jika Anda keluar sekarang.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjutkan'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldLeave == true && mounted) {
      Navigator.pop(context);
    }
  }

  String _getPlateTypeLabel(PlateType type) {
    switch (type) {
      case PlateType.introductory:
        return 'Pelat Kontrol / Pengenalan';
      case PlateType.transformation:
        return 'Pelat Transformasi';
      case PlateType.vanishing:
        return 'Pelat Memudar (Vanishing)';
      case PlateType.hiddenDigit:
        return 'Pelat Angka Tersembunyi';
      case PlateType.diagnostic:
        return 'Pelat Diagnostik Kuantitatif';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentPlate = _plates[_currentIndex];
    final progress = (_currentIndex + 1) / _plates.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitConfirmDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _showExitConfirmDialog,
          ),
          title: Text(
            'Pelat ${_currentIndex + 1} dari ${_plates.length}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          actions: [
            if (widget.timerPerPlate > 0)
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _secondsLeft <= 1 ? AppColors.error.withAlpha(30) : AppColors.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _secondsLeft <= 1 ? AppColors.error : AppColors.primary,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: _secondsLeft <= 1 ? AppColors.error : AppColors.primary,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_secondsLeft}s',
                      style: TextStyle(
                        color: _secondsLeft <= 1 ? AppColors.error : AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? AppColors.cardDark : AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  // Plate Category Sub-header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getPlateTypeLabel(currentPlate.plateType),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.pinch_rounded, size: 14, color: isDark ? Colors.white38 : Colors.black38),
                            const SizedBox(width: 4),
                            Text(
                              'Pinch zoom',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white38 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Main Test Area: Canvas & Dialpad
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          // Authentic Ishihara Plate Canvas
                          Center(
                            child: IshiharaCanvas(
                              key: ValueKey('plate_${currentPlate.id}'),
                              plate: currentPlate,
                              size: 250,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Dialpad
                          CustomDialpad(
                            currentValue: _currentInput,
                            hapticEnabled: _hapticEnabled,
                            onDigitPressed: _onDigitPressed,
                            onBackspace: _onBackspace,
                            onBlankPressed: _onBlankPressed,
                            onSubmit: _submitAnswer,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
