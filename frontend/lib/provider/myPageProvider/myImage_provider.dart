import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageNotifier extends StateNotifier<Uint8List?> {
  ImageNotifier() : super(null);

  void updateImage(Uint8List? newImage) {
    state = newImage; // 상태 업데이트
  }
}

// Provider 정의
final imageProvider = StateNotifierProvider<ImageNotifier, Uint8List?>((ref) {
  return ImageNotifier();
});
