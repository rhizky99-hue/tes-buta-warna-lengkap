import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../data/local_storage_service.dart';
import '../data/models/test_result.dart';
import 'test_result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _storage = LocalStorageService();
  List<TestResult> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await _storage.getHistory();
    if (mounted) {
      setState(() {
        _history = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(String id) async {
    await _storage.deleteTestResult(id);
    _loadHistory();
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text('Seluruh catatan hasil tes yang tersimpan offline akan dihapus secara permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.clearAllHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemeriksaan'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              tooltip: 'Hapus Semua',
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  itemCount: _history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final isNormal = item.diagnosis == DiagnosisType.normal;
                    final statusColor = isNormal
                        ? AppColors.success
                        : (item.scorePercentage > 60 ? AppColors.warning : AppColors.error);

                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.delete_rounded, color: Colors.white),
                      ),
                      onDismissed: (_) => _deleteItem(item.id),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isNormal ? Icons.check_circle_rounded : Icons.info_rounded,
                              color: statusColor,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            item.diagnosisTitle,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                '${dateFormat.format(item.timestamp)} • ${item.testMode == 'quick' ? 'Tes Cepat (12)' : 'Tes Lengkap (24)'}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Akurasi: ${item.scorePercentage.toStringAsFixed(0)}% (${item.correctCount}/${item.totalPlates} Benar)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded, size: 22),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TestResultScreen(result: item),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history_toggle_off_rounded, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Riwayat Tes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Setelah Anda menyelesaikan tes buta warna, ringkasan hasil dan diagnosis Anda akan tercatat di sini secara offline.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
