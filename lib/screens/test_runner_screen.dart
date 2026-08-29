import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../data/ishihara_dataset.dart';
import '../data/local_storage_service.dart';
import '../data/models/ishihara_plate.dart';
import '../data/models/test_result.dart';
import '../widgets/custom_dialpad.dart';
import '../widgets/ishihara_canvas.dart';
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

  @override
  void initState() {
    super.initState();
    _plates = IshiharaDataset.getPlatesForMode(widget.testMode);
    _startPlateTimer();
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
            // Auto submit when time runs out
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
      // Completed all plates!
      _finishTest();
    }
  }

  Future<void> _finishTest() async {
    _countdownTimer?.cancel();

    // Evaluate diagnostic result
    final result = IshiharaDataset.evaluateTest(
      testMode: widget.testMode,
      answers: _answers,
    );

    // Save offline
    await LocalStorageService().saveTestResult(result);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TestResultScreen(result: result),
      ),
    );
  }

  Future<void> _showExitConfirmDialog() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hentikan Tes?'),
        content: const Text('Proses tes yang sedang berjalan tidak akan tersimpan jika Anda keluar sekarang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjutkan Tes'),
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
          title: Text('Pelat ${_currentIndex + 1} dari ${_plates.length}'),
          actions: [
            if (widget.timerPerPlate > 0)
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _secondsLeft <= 1 ? AppColors.error : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${_secondsLeft}s',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: progress,
                backgroundColor: isDark ? AppColors.cardDark : AppColors.borderLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 4,
              ),

              // Main Test Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Column(
                    children: [
                      // Zoom & Inspection Hint
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pinch_rounded,
                            size: 16,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Cubit / Zoom untuk memperbesar pelat',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Authentic Ishihara Plate Canvas
                      Center(
                        child: IshiharaCanvas(
                          key: ValueKey('plate_${currentPlate.id}'),
                          plate: currentPlate,
                          size: 260,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Interactive Dialpad
                      CustomDialpad(
                        currentValue: _currentInput,
                        onDigitPressed: _onDigitPressed,
                        onBackspace: _onBackspace,
                        onBlankPressed: _onBlankPressed,
                        onSubmit: _submitAnswer,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
