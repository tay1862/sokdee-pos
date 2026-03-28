import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'setup_wizard_screen.g.dart';

// ─── Wizard State ─────────────────────────────────────────────────────────────

class WizardData {
  const WizardData({
    this.storeName = '',
    this.storeType = '',
    this.planId = '',
    this.maxEmployees = 10,
    this.tableCount = 0,
    this.enableKds = false,
    this.defaultLang = 'lo',
    this.baseCurrency = 'LAK',
  });

  final String storeName;
  final String storeType;
  final String planId;
  final int maxEmployees;
  final int tableCount;
  final bool enableKds;
  final String defaultLang;
  final String baseCurrency;

  bool get isRestaurant => storeType == 'restaurant';

  WizardData copyWith({
    String? storeName,
    String? storeType,
    String? planId,
    int? maxEmployees,
    int? tableCount,
    bool? enableKds,
    String? defaultLang,
    String? baseCurrency,
  }) =>
      WizardData(
        storeName: storeName ?? this.storeName,
        storeType: storeType ?? this.storeType,
        planId: planId ?? this.planId,
        maxEmployees: maxEmployees ?? this.maxEmployees,
        tableCount: tableCount ?? this.tableCount,
        enableKds: enableKds ?? this.enableKds,
        defaultLang: defaultLang ?? this.defaultLang,
        baseCurrency: baseCurrency ?? this.baseCurrency,
      );

  Map<String, dynamic> toJson() => {
        'name': storeName,
        'store_type': storeType,
        'plan_id': planId,
        'max_employees': maxEmployees,
        'table_count': tableCount,
        'enable_kds': enableKds,
        'default_lang': defaultLang,
        'base_currency': baseCurrency,
      };
}

@riverpod
class WizardNotifier extends _$WizardNotifier {
  @override
  WizardData build() => const WizardData();

  void update(WizardData Function(WizardData) updater) {
    state = updater(state);
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class SetupWizardScreen extends ConsumerStatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  ConsumerState<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends ConsumerState<SetupWizardScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;
  String? _error;

  // Steps: 0=StoreName, 1=StoreType, 2=Plan, 3=Employees, 4=Restaurant(optional)
  int get _totalSteps {
    final data = ref.read(wizardNotifierProvider);
    return data.isRestaurant ? 5 : 4;
  }

  void _next() {
    final data = ref.read(wizardNotifierProvider);
    // Skip restaurant step if not restaurant
    if (_currentStep == 3 && !data.isRestaurant) {
      _submit();
      return;
    }
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final data = ref.read(wizardNotifierProvider);
      final client = ref.read(apiClientProvider);
      final result = await client.post('/admin/tenants', body: data.toJson());
      if (!mounted) return;
      // Show credentials dialog
      await _showCredentialsDialog(result);
      if (mounted) context.go('/super-admin/tenants');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showCredentialsDialog(Map<String, dynamic> result) async {
    final creds = result['credentials'] as Map<String, dynamic>?;
    if (creds == null) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Tenant Created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Share these credentials with the store owner:'),
            const SizedBox(height: 16),
            _CredRow(label: 'Tenant ID', value: creds['tenant_id'] as String? ?? ''),
            _CredRow(label: 'Username', value: creds['username'] as String? ?? ''),
            _CredRow(label: 'PIN', value: creds['pin'] as String? ?? ''),
            const SizedBox(height: 8),
            const Text(
              'The PIN will not be shown again.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(wizardNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tenant Setup'),
        leading: _currentStep > 0
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _back)
            : null,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Step ${_currentStep + 1} of $_totalSteps',
              style: theme.textTheme.bodySmall,
            ),
          ),

          // Pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StoreNameStep(data: data, onChanged: (v) => ref.read(wizardNotifierProvider.notifier).update((d) => d.copyWith(storeName: v))),
                _StoreTypeStep(data: data, onChanged: (v) => ref.read(wizardNotifierProvider.notifier).update((d) => d.copyWith(storeType: v))),
                _PlanStep(data: data, onChanged: (v) => ref.read(wizardNotifierProvider.notifier).update((d) => d.copyWith(planId: v))),
                _EmployeesStep(data: data, onChanged: (v) => ref.read(wizardNotifierProvider.notifier).update((d) => d.copyWith(maxEmployees: v))),
                if (data.isRestaurant)
                  _RestaurantStep(
                    data: data,
                    onTableCountChanged: (v) => ref.read(wizardNotifierProvider.notifier).update((d) => d.copyWith(tableCount: v)),
                    onKdsChanged: (v) => ref.read(wizardNotifierProvider.notifier).update((d) => d.copyWith(enableKds: v)),
                  ),
              ],
            ),
          ),

          // Error
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ),

          // Next button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _next,
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_currentStep == _totalSteps - 1 ? 'Create Tenant' : 'Next'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Step Widgets ─────────────────────────────────────────────────────────────

class _StoreNameStep extends StatefulWidget {
  const _StoreNameStep({required this.data, required this.onChanged});
  final WizardData data;
  final ValueChanged<String> onChanged;

  @override
  State<_StoreNameStep> createState() => _StoreNameStepState();
}

class _StoreNameStepState extends State<_StoreNameStep> {
  late final _ctrl = TextEditingController(text: widget.data.storeName);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StepPadding(
      title: 'Store Name',
      subtitle: 'What is the name of this store?',
      child: TextField(
        controller: _ctrl,
        onChanged: widget.onChanged,
        decoration: const InputDecoration(labelText: 'Store Name', prefixIcon: Icon(Icons.store)),
        autofocus: true,
      ),
    );
  }
}

class _StoreTypeStep extends StatelessWidget {
  const _StoreTypeStep({required this.data, required this.onChanged});
  final WizardData data;
  final ValueChanged<String> onChanged;

  static const _types = [
    ('restaurant', Icons.restaurant, 'Restaurant', 'ຮ້ານອາຫານ / ร้านอาหาร'),
    ('retail', Icons.shopping_bag_outlined, 'Retail', 'ຮ້ານຂາຍຍ່ອຍ / ร้านค้าทั่วไป'),
    ('warehouse', Icons.warehouse_outlined, 'Warehouse', 'ສາງສິນຄ້າ / คลังสินค้า'),
    ('auto_parts', Icons.car_repair, 'Auto Parts', 'ຮ້ານອາໄຫຼ່ / ร้านอะไหล่'),
    ('other', Icons.store_mall_directory_outlined, 'Other', 'ອື່ນໆ / อื่นๆ'),
  ];

  @override
  Widget build(BuildContext context) {
    return _StepPadding(
      title: 'Store Type',
      subtitle: 'Select the type of business',
      child: Column(
        children: _types.map((t) {
          final (value, icon, label, sublabel) = t;
          return RadioListTile<String>(
            value: value,
            groupValue: data.storeType,
            onChanged: (v) => onChanged(v!),
            title: Row(children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(label)]),
            subtitle: Text(sublabel, style: const TextStyle(fontSize: 12)),
          );
        }).toList(),
      ),
    );
  }
}

class _PlanStep extends ConsumerWidget {
  const _PlanStep({required this.data, required this.onChanged});
  final WizardData data;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _StepPadding(
      title: 'Subscription Plan',
      subtitle: 'Choose a plan for this tenant',
      child: Column(
        children: [
          _PlanCard(id: 'starter', name: 'Starter', desc: '3 users • 100 products', selected: data.planId == 'starter', onTap: () => onChanged('starter')),
          _PlanCard(id: 'basic', name: 'Basic', desc: '10 users • 500 products • Inventory', selected: data.planId == 'basic', onTap: () => onChanged('basic')),
          _PlanCard(id: 'pro', name: 'Pro', desc: '30 users • 2000 products • KDS • Reports', selected: data.planId == 'pro', onTap: () => onChanged('pro')),
          _PlanCard(id: 'enterprise', name: 'Enterprise', desc: 'Unlimited • All features', selected: data.planId == 'enterprise', onTap: () => onChanged('enterprise')),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.id, required this.name, required this.desc, required this.selected, required this.onTap});
  final String id, name, desc;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: selected ? theme.colorScheme.primaryContainer : null,
      child: ListTile(
        onTap: onTap,
        leading: Icon(selected ? Icons.check_circle : Icons.circle_outlined, color: selected ? theme.colorScheme.primary : null),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(desc),
      ),
    );
  }
}

class _EmployeesStep extends StatefulWidget {
  const _EmployeesStep({required this.data, required this.onChanged});
  final WizardData data;
  final ValueChanged<int> onChanged;

  @override
  State<_EmployeesStep> createState() => _EmployeesStepState();
}

class _EmployeesStepState extends State<_EmployeesStep> {
  late final _ctrl = TextEditingController(text: widget.data.maxEmployees.toString());

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StepPadding(
      title: 'Max Employees',
      subtitle: 'Maximum number of staff accounts',
      child: TextField(
        controller: _ctrl,
        keyboardType: TextInputType.number,
        onChanged: (v) => widget.onChanged(int.tryParse(v) ?? 10),
        decoration: const InputDecoration(labelText: 'Max Employees', prefixIcon: Icon(Icons.people_outline)),
      ),
    );
  }
}

class _RestaurantStep extends StatelessWidget {
  const _RestaurantStep({required this.data, required this.onTableCountChanged, required this.onKdsChanged});
  final WizardData data;
  final ValueChanged<int> onTableCountChanged;
  final ValueChanged<bool> onKdsChanged;

  @override
  Widget build(BuildContext context) {
    return _StepPadding(
      title: 'Restaurant Setup',
      subtitle: 'Configure tables and kitchen display',
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (v) => onTableCountChanged(int.tryParse(v) ?? 0),
            decoration: const InputDecoration(labelText: 'Number of Tables', prefixIcon: Icon(Icons.table_restaurant)),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: data.enableKds,
            onChanged: onKdsChanged,
            title: const Text('Enable Kitchen Display (KDS)'),
            subtitle: const Text('Requires Pro or Enterprise plan'),
          ),
        ],
      ),
    );
  }
}

class _StepPadding extends StatelessWidget {
  const _StepPadding({required this.title, required this.subtitle, required this.child});
  final String title, subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _CredRow extends StatelessWidget {
  const _CredRow({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
          SelectableText(value, style: const TextStyle(fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
