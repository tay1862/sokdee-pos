import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps a widget tree and intercepts HID keyboard input from barcode scanners.
///
/// Barcode scanners act as HID keyboards — they type characters very fast
/// (< [_scanThresholdMs] ms between keystrokes) followed by an Enter key.
/// This widget distinguishes scanner input from normal keyboard typing.
class BarcodeHandler extends StatefulWidget {
  const BarcodeHandler({
    super.key,
    required this.child,
    required this.onBarcode,
  });

  final Widget child;
  final ValueChanged<String> onBarcode;

  @override
  State<BarcodeHandler> createState() => _BarcodeHandlerState();
}

class _BarcodeHandlerState extends State<BarcodeHandler> {
  static const int _scanThresholdMs = 100;
  static const int _minBarcodeLength = 3;

  final StringBuffer _buffer = StringBuffer();
  DateTime? _lastKeyTime;
  Timer? _resetTimer;

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    final now = DateTime.now();
    final key = event.logicalKey;

    // Enter key = end of barcode
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      final barcode = _buffer.toString().trim();
      _buffer.clear();
      _lastKeyTime = null;
      _resetTimer?.cancel();

      if (barcode.length >= _minBarcodeLength) {
        widget.onBarcode(barcode);
      }
      return;
    }

    // Check if this keystroke is fast enough to be from a scanner
    if (_lastKeyTime != null) {
      final elapsed = now.difference(_lastKeyTime!).inMilliseconds;
      if (elapsed > _scanThresholdMs) {
        // Too slow — likely manual typing, reset buffer
        _buffer.clear();
      }
    }

    _lastKeyTime = now;

    // Append printable character
    final char = event.character;
    if (char != null && char.isNotEmpty) {
      _buffer.write(char);
    }

    // Auto-reset buffer after 500ms of inactivity
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(milliseconds: 500), () {
      _buffer.clear();
      _lastKeyTime = null;
    });
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: _handleKey,
      child: widget.child,
    );
  }
}
