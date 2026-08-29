import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';

class CustomDialpad extends StatelessWidget {
  final String currentValue;
  final Function(String) onDigitPressed;
  final VoidCallback onBackspace;
  final VoidCallback onBlankPressed;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const CustomDialpad({
    super.key,
    required this.currentValue,
    required this.onDigitPressed,
    required this.onBackspace,
    required this.onBlankPressed,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  void _triggerHaptic() {
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? AppColors.cardDark : Colors.white;
    final btnBorder = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display Value Bar
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131C2E) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: currentValue.isNotEmpty ? AppColors.primary : btnBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jawaban Anda:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              Text(
                currentValue.isEmpty
                    ? 'Pilih angka...'
                    : (currentValue == 'BLANK' ? 'Tidak Terlihat' : currentValue),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: currentValue.isEmpty
                      ? (isDark ? Colors.white30 : Colors.black26)
                      : (currentValue == 'BLANK' ? AppColors.warning : AppColors.primary),
                  letterSpacing: currentValue == 'BLANK' ? 0.5 : 2.0,
                ),
              ),
            ],
          ),
        ),

        // Keypad Grid 3x4
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 2.1,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            _buildNumberBtn('1', textColor, btnBg, btnBorder),
            _buildNumberBtn('2', textColor, btnBg, btnBorder),
            _buildNumberBtn('3', textColor, btnBg, btnBorder),
            _buildNumberBtn('4', textColor, btnBg, btnBorder),
            _buildNumberBtn('5', textColor, btnBg, btnBorder),
            _buildNumberBtn('6', textColor, btnBg, btnBorder),
            _buildNumberBtn('7', textColor, btnBg, btnBorder),
            _buildNumberBtn('8', textColor, btnBg, btnBorder),
            _buildNumberBtn('9', textColor, btnBg, btnBorder),
            _buildBlankBtn(isDark, btnBorder),
            _buildNumberBtn('0', textColor, btnBg, btnBorder),
            _buildBackspaceBtn(isDark, btnBorder),
          ],
        ),

        const SizedBox(height: 12),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: isSubmitting
                ? null
                : () {
                    _triggerHaptic();
                    onSubmit();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentValue.isEmpty ? 'Lewati / Konfirmasi' : 'Lanjut ke Pelat Berikutnya',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberBtn(String digit, Color textColor, Color bg, Color border) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _triggerHaptic();
          onDigitPressed(digit);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            digit,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlankBtn(bool isDark, Color border) {
    return Material(
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _triggerHaptic();
          onBlankPressed();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 1),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: const Text(
            'Tidak\nTerlihat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.warning,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceBtn(bool isDark, Color border) {
    return Material(
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _triggerHaptic();
          onBackspace();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 1),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.backspace_outlined,
            size: 20,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}
