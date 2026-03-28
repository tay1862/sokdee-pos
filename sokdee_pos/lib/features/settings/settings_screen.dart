import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/i18n/locale_provider.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeNotifierProvider);
    final currentLocale = localeAsync.valueOrNull?.languageCode ?? 'lo';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Language
          _SectionHeader(title: 'Language / ພາສາ / ภาษา'),
          RadioListTile<String>(
            value: 'lo',
            groupValue: currentLocale,
            onChanged: (v) => ref.read(localeNotifierProvider.notifier).setLocale(const Locale('lo')),
            title: const Text('ລາວ (Lao)'),
          ),
          RadioListTile<String>(
            value: 'th',
            groupValue: currentLocale,
            onChanged: (v) => ref.read(localeNotifierProvider.notifier).setLocale(const Locale('th')),
            title: const Text('ไทย (Thai)'),
          ),
          RadioListTile<String>(
            value: 'en',
            groupValue: currentLocale,
            onChanged: (v) => ref.read(localeNotifierProvider.notifier).setLocale(const Locale('en')),
            title: const Text('English'),
          ),

          const Divider(),

          // Hardware
          _SectionHeader(title: 'Hardware'),
          ListTile(
            leading: const Icon(Icons.print_outlined),
            title: const Text('Thermal Printer'),
            subtitle: const Text('Configure printer connection'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('Barcode Scanner'),
            subtitle: const Text('HID keyboard mode'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),

          const Divider(),

          // Security
          _SectionHeader(title: 'Security'),
          ListTile(
            leading: const Icon(Icons.devices_outlined),
            title: const Text('Registered Devices'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Audit Log'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),

          const Divider(),

          // Account
          _SectionHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
