import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<Color> getAverageColorCustom(String imageUrl) async {
  if (imageUrl.isEmpty) return const Color(0xFF1E88E5);

  try {
    final response = await Dio().get<List<int>>(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) return const Color(0xFF1E88E5);

    final image = await decodeImageFromList(Uint8List.fromList(bytes));
    final pixelData = await image.toByteData();

    if (pixelData == null) return const Color(0xFF1E88E5);

    // Sample 100 points from the image
    final samplePoints = [
      Offset(0, 0),
      Offset(image.width.toDouble(), 0),
      Offset(0, image.height.toDouble()),
      Offset(image.width.toDouble(), image.height.toDouble()),
      Offset(image.width / 2, image.height / 2),
    ];

    int r = 0, g = 0, b = 0;
    int sampleCount = 0;

    for (final point in samplePoints) {
      final pixelOffset = ((point.dy * image.width) + point.dx).toInt() * 4;
      r += pixelData.getUint8(pixelOffset);
      g += pixelData.getUint8(pixelOffset + 1);
      b += pixelData.getUint8(pixelOffset + 2);
      sampleCount++;
    }

    return Color.fromRGBO(
      r ~/ sampleCount,
      g ~/ sampleCount,
      b ~/ sampleCount,
      1,
    );
  } catch (e) {
    debugPrint("Error in fast color extraction: $e");
    return const Color(0xFF1E88E5);
  }
}
