// ignore_for_file: library_private_types_in_public_api

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lyrica/modules/library/music_equalizer/equalizer_provider.dart';
import 'package:lyrica/services/audio_player_handler.dart';
import 'package:provider/provider.dart';

class MusicEqualizerScreen extends StatefulWidget {
  const MusicEqualizerScreen({super.key});

  @override
  _MusicEqualizerScreenState createState() => _MusicEqualizerScreenState();
}

class _MusicEqualizerScreenState extends State<MusicEqualizerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final equalizerProvider = Provider.of<EqualizerProvider>(
        context,
        listen: false,
      );
      if (!equalizerProvider.isInitialized) {
        equalizerProvider.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final equalizerProvider = Provider.of<EqualizerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Equalizer'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          if (equalizerProvider.isInitialized &&
              equalizerProvider.deviceSupportsEqualizer)
            IconButton(
              icon: const Icon(Icons.settings_backup_restore),
              onPressed: equalizerProvider.resetToFlat,
              tooltip: 'Reset to flat',
            ),
          if (equalizerProvider.errorMessage != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: equalizerProvider.retryInitialization,
              tooltip: 'Retry initialization',
            ),
        ],
      ),
      body: _buildBody(equalizerProvider),
    );
  }

  Widget _buildBody(EqualizerProvider provider) {
    if (!provider.isInitialized) {
      return _buildLoadingState(provider);
    }

    if (!provider.deviceSupportsEqualizer) {
      return _buildUnsupportedDeviceState(provider);
    }

    if (provider.errorMessage != null) {
      return _buildErrorState(provider);
    }

    // Try to get audio handler, but don't fail if not available
    AudioPlayerHandler? audioHandler;
    try {
      audioHandler = Provider.of<AudioPlayerHandler>(context, listen: false);
    } catch (e) {
      debugPrint('AudioPlayerHandler not available: $e');
    }

    return _buildEqualizerContent(provider, audioHandler);
  }

  Widget _buildLoadingState(EqualizerProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text('Initializing Equalizer...'),
        ],
      ),
    );
  }

  Widget _buildUnsupportedDeviceState(EqualizerProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.audio_file, size: 64, color: Colors.blueGrey),
            const SizedBox(height: 20),
            const Text(
              'Equalizer Not Supported',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your device does not support audio equalizer effects.\n\nThis is a hardware limitation of your device.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.retryInitialization,
              child: const Text('Retry Detection'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(EqualizerProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Equalizer Error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              provider.errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.retryInitialization,
              child: const Text('Retry Initialization'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEqualizerContent(
    EqualizerProvider provider,
    AudioPlayerHandler? audioHandler,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current playing song info
          if (audioHandler != null) _buildNowPlayingInfo(audioHandler),

          if (audioHandler == null) _buildNoAudioHandlerWarning(),

          const SizedBox(height: 24),

          // Equalizer enable/disable switch
          _buildEnableSwitch(provider),

          const SizedBox(height: 24),

          // Show equalizer controls only if enabled
          if (provider.isEnabled) ...[
            if (provider.centerBandFreqs.isNotEmpty) ...[
              _buildCustomEqualizer(provider),
              const SizedBox(height: 24),
            ],

            if (provider.presets.isNotEmpty) ...[
              _buildPresetsDropdown(provider),
              const SizedBox(height: 24),
            ],
          ],

          // Open device equalizer button
          _buildDeviceEqualizerButton(provider),

          // Debug information (optional)
          if (kDebugMode) ...[
            const SizedBox(height: 24),
            _buildDebugInfo(provider),
          ],
        ],
      ),
    );
  }

  Widget _buildEnableSwitch(EqualizerProvider provider) {
    return Card(
      elevation: 2,
      child: SwitchListTile(
        title: const Text(
          'Enable Equalizer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Turn on/off audio effects'),
        value: provider.isEnabled,
        onChanged:
            provider.deviceSupportsEqualizer
                ? (value) => provider.setEnabled(value)
                : null,
        secondary: const Icon(Icons.equalizer),
      ),
    );
  }

  Widget _buildCustomEqualizer(EqualizerProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Equalizer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (provider.centerBandFreqs.isEmpty)
              const Text('No equalizer bands available')
            else
              _buildEqualizerSliders(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlayingInfo(AudioPlayerHandler audioHandler) {
    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        if (mediaItem == null) {
          return const ListTile(
            leading: Icon(Icons.music_note, size: 40),
            title: Text('No song playing'),
            subtitle: Text('Play a song to use equalizer'),
          );
        }

        return Card(
          elevation: 2,
          child: ListTile(
            leading:
                mediaItem.artUri != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        mediaItem.artUri.toString(),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                                const Icon(Icons.music_note, size: 40),
                      ),
                    )
                    : const Icon(Icons.music_note, size: 40),
            title: Text(
              mediaItem.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              mediaItem.artist ?? 'Unknown Artist',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEqualizerSliders(EqualizerProvider provider) {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            provider.centerBandFreqs.asMap().entries.map((entry) {
              final index = entry.key;
              final freq = entry.value;
              return _buildBandSlider(index, freq, provider);
            }).toList(),
      ),
    );
  }

  Widget _buildBandSlider(int bandId, int freq, EqualizerProvider provider) {
    final level = provider.bandLevels[bandId] ?? 0;
    final min =
        provider.bandLevelRange.isNotEmpty
            ? provider.bandLevelRange[0].toDouble()
            : -15.0;
    final max =
        provider.bandLevelRange.isNotEmpty
            ? provider.bandLevelRange[1].toDouble()
            : 15.0;

    return Container(
      width: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Frequency label
          Text(
            '${freq ~/ 1000} Hz',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Slider
          Expanded(
            child: RotatedBox(
              quarterTurns: 3, // Rotate to make vertical
              child: Slider(
                min: min,
                max: max,
                value: level.toDouble(),
                onChanged:
                    (value) => provider.setBandLevel(bandId, value.toInt()),
                divisions: (max - min).toInt(),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Value indicator
          Text(
            '${level > 0 ? '+' : ''}$level dB',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetsDropdown(EqualizerProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Presets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: provider.selectedPreset,
              decoration: InputDecoration(
                labelText: 'Select Preset',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              items:
                  provider.presets.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.setPreset(value);
                }
              },
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAudioHandlerWarning() {
    return const Card(
      color: Colors.orangeAccent,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Audio service not available. Song information may not be displayed.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceEqualizerButton(EqualizerProvider provider) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.settings),
      label: const Text('Open Device Equalizer'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: provider.openDeviceEqualizer,
    );
  }

  Widget _buildDebugInfo(EqualizerProvider provider) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Debug Information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Bands: ${provider.centerBandFreqs.length}'),
            Text('Range: ${provider.bandLevelRange}'),
            Text('Presets: ${provider.presets.length}'),
            if (provider.errorMessage != null)
              Text('Error: ${provider.errorMessage}'),
          ],
        ),
      ),
    );
  }
}
