import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../../data/local_storage_service.dart';

class UnityAdsService {
  static final UnityAdsService _instance = UnityAdsService._internal();
  factory UnityAdsService() => _instance;
  UnityAdsService._internal();

  // Exact Game IDs from Unity Dashboard
  static String androidGameId = '6185002'; 
  static String iosGameId = '6185003';

  // Placement IDs (Default from Unity Dashboard)
  static String interstitialPlacementId = 'Interstitial_Android';
  static String rewardedPlacementId = 'Rewarded_Android';
  static String bannerPlacementId = 'Banner_Android';

  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;

  String _lastStatusMessage = 'Belum diinisialisasi';
  String _lastError = '';
  final List<String> _logs = [];

  bool get isInitialized => _isInitialized;
  bool get isInterstitialReady => _isInterstitialReady;
  bool get isRewardedReady => _isRewardedReady;
  String get lastStatusMessage => _lastStatusMessage;
  String get lastError => _lastError;
  List<String> get logs => List.unmodifiable(_logs);

  void _addLog(String msg) {
    final time = DateTime.now();
    final timeStr = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    _logs.insert(0, '[$timeStr] $msg');
    if (_logs.length > 15) {
      _logs.removeLast();
    }
  }

  /// Check if the current platform supports Unity Ads natively
  static bool get isSupportedPlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Initialize Unity Ads SDK (Production Mode by default)
  Future<bool> init({bool testMode = false, String? gameId, bool force = false}) async {
    if (!isSupportedPlatform) {
      _lastStatusMessage = 'Platform Web/Desktop tidak didukung Unity Ads';
      _addLog(_lastStatusMessage);
      debugPrint('ℹ️ [UnityAds] Unity Ads dilewati pada Web/Desktop platform.');
      return false;
    }

    try {
      final savedGameId = await LocalStorageService().getUnityGameId();
      if (savedGameId != null && savedGameId.isNotEmpty) {
        androidGameId = savedGameId;
      }
    } catch (_) {}

    if (gameId != null && gameId.isNotEmpty) {
      androidGameId = gameId;
    }

    if (_isInitialized && !force) {
      _lastStatusMessage = 'SDK Sudah Aktif (Game ID: $androidGameId)';
      return true;
    }

    if (_isInitializing && !force) {
      return false;
    }

    _isInitialized = false;
    _isInitializing = true;
    _lastStatusMessage = 'Menghubungkan ke server Unity Ads...';
    _addLog('Memulai init SDK (Game ID: $androidGameId, Mode Uji: $testMode)');

    final completer = Completer<bool>();

    try {
      final targetGameId = Platform.isAndroid ? androidGameId : iosGameId;

      await UnityAds.init(
        gameId: targetGameId,
        testMode: testMode,
        onComplete: () {
          _isInitialized = true;
          _isInitializing = false;
          _lastStatusMessage = 'Terhubung Aktif (Game ID: $targetGameId)';
          _lastError = '';
          _addLog('Init SDK Berhasil!');
          debugPrint('✅ [UnityAds] Inisialisasi berhasil.');
          loadInterstitial();
          loadRewarded();
          if (!completer.isCompleted) completer.complete(true);
        },
        onFailed: (error, message) {
          _isInitialized = false;
          _isInitializing = false;
          _lastError = '$error: $message';
          _lastStatusMessage = 'Gagal init: $error ($message)';
          _addLog('Init Gagal: $error - $message');
          debugPrint('❌ [UnityAds] Inisialisasi gagal: $error - $message');
          if (!completer.isCompleted) completer.complete(false);
        },
      );
    } catch (e) {
      _isInitialized = false;
      _isInitializing = false;
      _lastError = e.toString();
      _lastStatusMessage = 'Exception saat init: $e';
      _addLog('Exception init: $e');
      debugPrint('⚠️ [UnityAds] Exception saat init: $e');
      if (!completer.isCompleted) completer.complete(false);
    }

    return completer.future.timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        _isInitializing = false;
        return _isInitialized;
      },
    );
  }

  /// Check initialization state directly from native SDK if possible
  Future<bool> checkInitializationStatus() async {
    if (!isSupportedPlatform) return false;
    try {
      final nativeStatus = await UnityAds.isInitialized();
      if (nativeStatus) {
        _isInitialized = true;
        _lastStatusMessage = 'Terhubung (SDK Aktif)';
      }
      return nativeStatus;
    } catch (_) {
      return _isInitialized;
    }
  }

  /// Ensure SDK is initialized
  Future<void> ensureInitialized() async {
    if (!_isInitialized && !_isInitializing) {
      await init(testMode: true);
    }
  }

  /// Pre-load Interstitial Ad
  Future<void> loadInterstitial({Function(bool success, String message)? onResult}) async {
    if (!isSupportedPlatform) return;

    await ensureInitialized();

    try {
      _addLog('Meminta pemuatan Interstitial ($interstitialPlacementId)...');
      await UnityAds.load(
        placementId: interstitialPlacementId,
        onComplete: (placementId) {
          _isInterstitialReady = true;
          _addLog('✅ Interstitial Siap Tayang ($placementId)');
          debugPrint('✅ [UnityAds] Interstitial siap: $placementId');
          onResult?.call(true, 'Iklan Interstitial siap ditayangkan.');
        },
        onFailed: (placementId, error, message) {
          _isInterstitialReady = false;
          _lastError = '$error: $message';
          _addLog('❌ Gagal load interstitial: $error ($message)');
          debugPrint('❌ [UnityAds] Gagal load interstitial: $error - $message');
          onResult?.call(false, 'Gagal memuat: $error ($message)');
        },
      );
    } catch (e) {
      _isInterstitialReady = false;
      _lastError = e.toString();
      _addLog('Exception load interstitial: $e');
      debugPrint('⚠️ [UnityAds] Exception saat load interstitial: $e');
      onResult?.call(false, 'Exception: $e');
    }
  }

  /// Pre-load Rewarded Ad
  Future<void> loadRewarded({Function(bool success, String message)? onResult}) async {
    if (!isSupportedPlatform) return;

    await ensureInitialized();

    try {
      _addLog('Meminta pemuatan Rewarded ($rewardedPlacementId)...');
      await UnityAds.load(
        placementId: rewardedPlacementId,
        onComplete: (placementId) {
          _isRewardedReady = true;
          _addLog('✅ Rewarded Siap Tayang ($placementId)');
          debugPrint('✅ [UnityAds] Rewarded siap: $placementId');
          onResult?.call(true, 'Iklan Rewarded siap ditayangkan.');
        },
        onFailed: (placementId, error, message) {
          _isRewardedReady = false;
          _lastError = '$error: $message';
          _addLog('❌ Gagal load rewarded: $error ($message)');
          debugPrint('❌ [UnityAds] Gagal load rewarded: $error - $message');
          onResult?.call(false, 'Gagal memuat: $error ($message)');
        },
      );
    } catch (e) {
      _isRewardedReady = false;
      _lastError = e.toString();
      _addLog('Exception load rewarded: $e');
      debugPrint('⚠️ [UnityAds] Exception saat load rewarded: $e');
      onResult?.call(false, 'Exception: $e');
    }
  }

  /// Show Interstitial Ad (e.g. after test completes or via settings test)
  void showInterstitial({
    VoidCallback? onDismissed,
    Function(String error)? onError,
  }) {
    if (!isSupportedPlatform) {
      onDismissed?.call();
      return;
    }

    bool hasDismissed = false;
    Timer? safetyTimer;

    void safeDismiss() {
      safetyTimer?.cancel();
      if (!hasDismissed) {
        hasDismissed = true;
        onDismissed?.call();
      }
    }

    // Safety timeout: jika ad tidak responsif dalam 20 detik, jangan buat user stuck
    safetyTimer = Timer(const Duration(seconds: 20), () {
      _addLog('⏰ Timeout safety timer triggered untuk interstitial.');
      debugPrint('⏰ [UnityAds] Timeout safety timer triggered untuk interstitial.');
      safeDismiss();
    });

    _addLog('Memanggil showVideoAd ($interstitialPlacementId)...');

    try {
      UnityAds.showVideoAd(
        placementId: interstitialPlacementId,
        onStart: (placementId) {
          _addLog('▶️ Iklan Interstitial mulai tayang ($placementId)');
        },
        onComplete: (placementId) {
          _isInterstitialReady = false;
          _addLog('🎬 Iklan Interstitial selesai ($placementId)');
          debugPrint('🎬 [UnityAds] Interstitial selesai: $placementId');
          loadInterstitial();
          safeDismiss();
        },
        onFailed: (placementId, error, message) {
          _isInterstitialReady = false;
          _lastError = '$error: $message';
          final errStr = 'Gagal tayang: $error ($message)';
          _addLog('❌ $errStr');
          debugPrint('❌ [UnityAds] Gagal menampilkan interstitial: $error - $message');
          onError?.call(errStr);
          // Request reload
          loadInterstitial();
          safeDismiss();
        },
        onSkipped: (placementId) {
          _isInterstitialReady = false;
          _addLog('⏭️ Iklan Interstitial dilewati/skip ($placementId)');
          debugPrint('⏭️ [UnityAds] Interstitial dilewati: $placementId');
          loadInterstitial();
          safeDismiss();
        },
        onClick: (placementId) {
          _addLog('👆 Iklan diklik ($placementId)');
          debugPrint('👆 [UnityAds] Iklan diklik: $placementId');
        },
      );
    } catch (e) {
      _isInterstitialReady = false;
      _lastError = e.toString();
      _addLog('Exception show interstitial: $e');
      debugPrint('⚠️ [UnityAds] Exception saat tampilkan interstitial: $e');
      onError?.call('Exception: $e');
      safeDismiss();
    }
  }

  /// Show Rewarded Video Ad
  void showRewarded({
    required VoidCallback onRewardEarned,
    VoidCallback? onDismissed,
    Function(String error)? onError,
  }) {
    if (!isSupportedPlatform) {
      onRewardEarned();
      onDismissed?.call();
      return;
    }

    bool hasDismissed = false;
    Timer? safetyTimer;

    void safeDismiss() {
      safetyTimer?.cancel();
      if (!hasDismissed) {
        hasDismissed = true;
        onDismissed?.call();
      }
    }

    safetyTimer = Timer(const Duration(seconds: 25), () {
      _addLog('⏰ Timeout safety timer triggered untuk rewarded.');
      safeDismiss();
    });

    _addLog('Memanggil showVideoAd ($rewardedPlacementId)...');

    try {
      UnityAds.showVideoAd(
        placementId: rewardedPlacementId,
        onStart: (placementId) {
          _addLog('▶️ Video Rewarded mulai tayang ($placementId)');
        },
        onComplete: (placementId) {
          _isRewardedReady = false;
          _addLog('🎁 Video Rewarded selesai, reward diberikan ($placementId)');
          debugPrint('🎁 [UnityAds] Reward diperoleh: $placementId');
          onRewardEarned();
          loadRewarded();
          safeDismiss();
        },
        onFailed: (placementId, error, message) {
          _isRewardedReady = false;
          _lastError = '$error: $message';
          final errStr = 'Gagal tayang rewarded: $error ($message)';
          _addLog('❌ $errStr');
          debugPrint('❌ [UnityAds] Gagal tampilkan rewarded: $error - $message');
          onError?.call(errStr);
          loadRewarded();
          safeDismiss();
        },
        onSkipped: (placementId) {
          _isRewardedReady = false;
          _addLog('⚠️ Video Rewarded dilewati sebelum selesai ($placementId)');
          debugPrint('⚠️ [UnityAds] Rewarded dilewati sebelum selesai');
          loadRewarded();
          safeDismiss();
        },
      );
    } catch (e) {
      _isRewardedReady = false;
      _lastError = e.toString();
      _addLog('Exception show rewarded: $e');
      debugPrint('⚠️ [UnityAds] Exception saat show rewarded: $e');
      onError?.call('Exception: $e');
      safeDismiss();
    }
  }

  /// Widget banner yang aman untuk platform Android/iOS
  Widget buildBannerAd() {
    if (!isSupportedPlatform || !_isInitialized) {
      return const SizedBox.shrink();
    }
    return UnityBannerAd(
      placementId: bannerPlacementId,
      onLoad: (placementId) {
        _addLog('✅ Banner ter-load ($placementId)');
        debugPrint('✅ [UnityAds] Banner ter-load: $placementId');
      },
      onClick: (placementId) => debugPrint('👆 [UnityAds] Banner diklik: $placementId'),
      onFailed: (placementId, error, message) {
        _addLog('❌ Banner gagal load: $error ($message)');
        debugPrint('❌ [UnityAds] Gagal load banner: $error - $message');
      },
    );
  }
}
