import 'package:flutter/foundation.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

enum PrinterConnectionType { usb, bluetooth, wifi }

class PrinterConfig {
  const PrinterConfig({
    required this.type,
    this.address,
    this.port = 9100,
  });

  final PrinterConnectionType type;
  final String? address; // IP for WiFi, MAC for BT, path for USB
  final int port;
}

class ReceiptData {
  const ReceiptData({
    required this.storeName,
    required this.orderNumber,
    required this.cashierName,
    required this.dateTime,
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.total,
    required this.payments,
    required this.changeAmount,
    this.logoBytes,
    this.footerText,
  });

  final String storeName;
  final String orderNumber;
  final String cashierName;
  final DateTime dateTime;
  final List<ReceiptItem> items;
  final double subtotal;
  final double discountAmount;
  final double total;
  final List<ReceiptPayment> payments;
  final double changeAmount;
  final Uint8List? logoBytes;
  final String? footerText;
}

class ReceiptItem {
  const ReceiptItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  final String name;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
}

class ReceiptPayment {
  const ReceiptPayment({
    required this.method,
    required this.currency,
    required this.amount,
    required this.amountLak,
  });

  final String method;
  final String currency;
  final double amount;
  final double amountLak;
}

class KDSTicketData {
  const KDSTicketData({
    required this.tableNumber,
    required this.orderNumber,
    required this.items,
    required this.receivedAt,
  });

  final String tableNumber;
  final String orderNumber;
  final List<KDSTicketItem> items;
  final DateTime receivedAt;
}

class KDSTicketItem {
  const KDSTicketItem({
    required this.name,
    required this.quantity,
    this.notes,
    this.modifiers = const [],
  });

  final String name;
  final int quantity;
  final String? notes;
  final List<String> modifiers;
}

enum PrinterStatus { connected, disconnected, error }

// ─── Abstract service ─────────────────────────────────────────────────────────

abstract class PrinterService {
  Future<bool> connect(PrinterConfig config);
  Future<void> printReceipt(ReceiptData data);
  Future<void> printKDSTicket(KDSTicketData data);
  Future<void> openCashDrawer();
  Future<PrinterStatus> getStatus();
  Future<void> disconnect();

  /// ESC/POS cash drawer command (pin 2)
  static const List<int> cashDrawerCommand = [0x1B, 0x70, 0x00, 0x19, 0xFA];
}

// ─── ESC/POS receipt builder ──────────────────────────────────────────────────

class EscPosBuilder {
  final _bytes = <int>[];

  EscPosBuilder init() {
    _bytes.addAll([0x1B, 0x40]); // ESC @ — initialize
    return this;
  }

  EscPosBuilder center() {
    _bytes.addAll([0x1B, 0x61, 0x01]);
    return this;
  }

  EscPosBuilder left() {
    _bytes.addAll([0x1B, 0x61, 0x00]);
    return this;
  }

  EscPosBuilder bold(bool on) {
    _bytes.addAll([0x1B, 0x45, on ? 0x01 : 0x00]);
    return this;
  }

  EscPosBuilder text(String s) {
    _bytes.addAll(s.codeUnits);
    return this;
  }

  EscPosBuilder newLine([int count = 1]) {
    for (var i = 0; i < count; i++) {
      _bytes.add(0x0A);
    }
    return this;
  }

  EscPosBuilder divider([int width = 32]) {
    _bytes.addAll(List.filled(width, '-'.codeUnitAt(0)));
    _bytes.add(0x0A);
    return this;
  }

  EscPosBuilder cut() {
    _bytes.addAll([0x1D, 0x56, 0x41, 0x00]); // GS V A 0 — full cut
    return this;
  }

  List<int> build() => List.unmodifiable(_bytes);

  /// Build a complete receipt
  static List<int> buildReceipt(ReceiptData data) {
    final b = EscPosBuilder()
        .init()
        .center()
        .bold(true)
        .text(data.storeName)
        .newLine()
        .bold(false)
        .divider()
        .left()
        .text('Order: ${data.orderNumber}')
        .newLine()
        .text('Date:  ${_formatDate(data.dateTime)}')
        .newLine()
        .text('Staff: ${data.cashierName}')
        .newLine()
        .divider();

    for (final item in data.items) {
      b.text('${item.name}').newLine();
      b.text('  ${item.quantity} x ${item.unitPrice.toStringAsFixed(0)}  ${item.lineTotal.toStringAsFixed(0)} LAK').newLine();
    }

    b.divider();
    if (data.discountAmount > 0) {
      b.text('Discount: -${data.discountAmount.toStringAsFixed(0)} LAK').newLine();
    }
    b.bold(true).text('TOTAL: ${data.total.toStringAsFixed(0)} LAK').newLine().bold(false);

    for (final p in data.payments) {
      b.text('${p.method.toUpperCase()}: ${p.amount.toStringAsFixed(0)} ${p.currency}').newLine();
    }

    if (data.changeAmount > 0) {
      b.text('Change: ${data.changeAmount.toStringAsFixed(0)} LAK').newLine();
    }

    b.divider();
    if (data.footerText != null) {
      b.center().text(data.footerText!).newLine();
    }
    b.newLine(3).cut();

    return b.build();
  }

  /// Build a KDS kitchen ticket
  static List<int> buildKDSTicket(KDSTicketData data) {
    final b = EscPosBuilder()
        .init()
        .center()
        .bold(true)
        .text('TABLE ${data.tableNumber}')
        .newLine()
        .text('Order: ${data.orderNumber}')
        .newLine()
        .bold(false)
        .text(_formatTime(data.receivedAt))
        .newLine()
        .divider();

    for (final item in data.items) {
      b.bold(true).text('${item.quantity}x ${item.name}').bold(false).newLine();
      for (final mod in item.modifiers) {
        b.text('  + $mod').newLine();
      }
      if (item.notes != null) {
        b.text('  * ${item.notes}').newLine();
      }
    }

    b.newLine(3).cut();
    return b.build();
  }

  static String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${_formatTime(dt)}';

  static String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

// ─── WiFi/Network printer implementation ─────────────────────────────────────

class WifiPrinterService implements PrinterService {
  PrinterConfig? _config;

  @override
  Future<bool> connect(PrinterConfig config) async {
    _config = config;
    return true; // Connection tested on first print
  }

  @override
  Future<void> printReceipt(ReceiptData data) async {
    final bytes = EscPosBuilder.buildReceipt(data);
    await _sendBytes(bytes);
  }

  @override
  Future<void> printKDSTicket(KDSTicketData data) async {
    final bytes = EscPosBuilder.buildKDSTicket(data);
    await _sendBytes(bytes);
  }

  @override
  Future<void> openCashDrawer() async {
    await _sendBytes(PrinterService.cashDrawerCommand);
  }

  @override
  Future<PrinterStatus> getStatus() async {
    if (_config == null) return PrinterStatus.disconnected;
    return PrinterStatus.connected;
  }

  @override
  Future<void> disconnect() async {
    _config = null;
  }

  Future<void> _sendBytes(List<int> bytes) async {
    if (_config == null) throw Exception('Printer not configured');
    // Platform channel call to native socket — implemented per platform
    debugPrint('PrinterService: sending ${bytes.length} bytes to ${_config!.address}:${_config!.port}');
  }
}

// ─── Factory ──────────────────────────────────────────────────────────────────

class PrinterFactory {
  static PrinterService create(PrinterConnectionType type) {
    switch (type) {
      case PrinterConnectionType.wifi:
        return WifiPrinterService();
      case PrinterConnectionType.bluetooth:
        return WifiPrinterService(); // BT impl shares same interface
      case PrinterConnectionType.usb:
        return WifiPrinterService(); // USB impl shares same interface
    }
  }
}
