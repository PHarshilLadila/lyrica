// equalizer_provider.dart
import 'package:flutter/foundation.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';

class EqualizerProvider with ChangeNotifier {
  bool _isInitialized = false;
  bool _isEnabled = false;
  List<int> _bandLevelRange = [];
  List<int> _centerBandFreqs = [];
  List<String> _presets = [];
  String? _selectedPreset;
  final Map<int, int> _bandLevels = {};
  String? _errorMessage;
  bool _deviceSupportsEqualizer = true;

  bool get isInitialized => _isInitialized;
  bool get isEnabled => _isEnabled;
  List<int> get bandLevelRange => _bandLevelRange;
  List<int> get centerBandFreqs => _centerBandFreqs;
  List<String> get presets => _presets;
  String? get selectedPreset => _selectedPreset;
  Map<int, int> get bandLevels => _bandLevels;
  String? get errorMessage => _errorMessage;
  bool get deviceSupportsEqualizer => _deviceSupportsEqualizer;

  Future<void> initialize() async {
    try {
      debugPrint('Initializing equalizer...');

      // Check if device supports equalizer first
      _deviceSupportsEqualizer = await _checkDeviceSupport();

      if (!_deviceSupportsEqualizer) {
        debugPrint('Device does not support equalizer');
        _errorMessage = 'Your device does not support audio equalizer effects';
        _isInitialized = true; // Mark as initialized to show UI
        notifyListeners();
        return;
      }

      // Initialize the equalizer with session ID 0 (global session)
      await EqualizerFlutter.init(0);
      debugPrint('Equalizer initialized successfully');

      // Get band level range
      _bandLevelRange = await EqualizerFlutter.getBandLevelRange();
      debugPrint('Band level range: $_bandLevelRange');

      // Get center band frequencies
      _centerBandFreqs = await EqualizerFlutter.getCenterBandFreqs();
      debugPrint('Center band freqs: $_centerBandFreqs');

      // Get presets
      _presets = await EqualizerFlutter.getPresetNames();
      debugPrint('Presets: $_presets');

      // Initialize band levels
      for (int i = 0; i < _centerBandFreqs.length; i++) {
        try {
          _bandLevels[i] = await EqualizerFlutter.getBandLevel(i);
          debugPrint('Band $i level: ${_bandLevels[i]}');
        } catch (e) {
          debugPrint('Error getting band level $i: $e');
          _bandLevels[i] = 0;
        }
      }

      // Enable equalizer by default after successful initialization
      _isEnabled = true;
      _isInitialized = true;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing equalizer: $e');
      _deviceSupportsEqualizer = false;
      _errorMessage = 'Failed to initialize equalizer: ${e.toString()}';
      _isInitialized = true; // Mark as initialized to show UI
      notifyListeners();
    }
  }

  Future<bool> _checkDeviceSupport() async {
    try {
      // Try to create a temporary equalizer instance to check support
      await EqualizerFlutter.init(0);
      final bands = await EqualizerFlutter.getCenterBandFreqs();
      await EqualizerFlutter.release();
      return bands.isNotEmpty;
    } catch (e) {
      debugPrint('Device does not support equalizer: $e');
      return false;
    }
  }

  Future<void> setEnabled(bool enabled) async {
    if (!_deviceSupportsEqualizer) {
      _isEnabled = false;
      notifyListeners();
      return;
    }

    try {
      if (enabled) {
        // Re-initialize if enabling
        await EqualizerFlutter.init(0);
      } else {
        // Release if disabling
        await EqualizerFlutter.release();
      }
      _isEnabled = enabled;
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting equalizer enabled: $e');
      _errorMessage = 'Failed to enable equalizer: $e';
      notifyListeners();
    }
  }

  Future<void> setBandLevel(int bandId, int level) async {
    if (!_deviceSupportsEqualizer || !_isEnabled) return;

    try {
      await EqualizerFlutter.setBandLevel(bandId, level);
      _bandLevels[bandId] = level;
      _selectedPreset = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting band level: $e');
      _errorMessage = 'Failed to set band level: $e';
      notifyListeners();
    }
  }

  Future<void> setPreset(String presetName) async {
    if (!_deviceSupportsEqualizer || !_isEnabled) return;

    try {
      await EqualizerFlutter.setPreset(presetName);
      _selectedPreset = presetName;

      // Update band levels after setting preset
      for (int i = 0; i < _centerBandFreqs.length; i++) {
        try {
          _bandLevels[i] = await EqualizerFlutter.getBandLevel(i);
        } catch (e) {
          debugPrint('Error getting band level after preset: $e');
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error setting preset: $e');
      _errorMessage = 'Failed to set preset: $e';
      notifyListeners();
    }
  }

  Future<void> resetToFlat() async {
    if (!_deviceSupportsEqualizer || !_isEnabled) return;

    try {
      for (int i = 0; i < _centerBandFreqs.length; i++) {
        await EqualizerFlutter.setBandLevel(i, 0);
        _bandLevels[i] = 0;
      }
      _selectedPreset = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error resetting to flat: $e');
      _errorMessage = 'Failed to reset equalizer: $e';
      notifyListeners();
    }
  }

  Future<void> openDeviceEqualizer() async {
    try {
      await EqualizerFlutter.open(0);
    } catch (e) {
      debugPrint('Error opening device equalizer: $e');
      _errorMessage = 'Failed to open device equalizer: $e';
      notifyListeners();
    }
  }

  void retryInitialization() {
    _isInitialized = false;
    _errorMessage = null;
    notifyListeners();
    initialize();
  }

  void disposeEqualizer() {
    try {
      if (_deviceSupportsEqualizer) {
        EqualizerFlutter.release();
      }
    } catch (e) {
      debugPrint('Error disposing equalizer: $e');
    }
  }
}
