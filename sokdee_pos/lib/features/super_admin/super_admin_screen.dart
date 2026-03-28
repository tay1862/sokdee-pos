import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuperAdminScreen extends StatelessWidget {
  const SuperAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super Admin')),
      drawer: NavigationDrawer(
        children: [
          const DrawerHeader(
            child: Text(
              'SOKDEE POS\nSuper Admin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () => context.go('/super-admin'),
          ),
          ListTile(
            leading: const Icon(Icons.store_outlined),
            title: const Text('Tenants'),
            onTap: () => context.go('/super-admin/tenants'),
          ),
          ListTile(
            leading: const Icon(Icons.card_membership_outlined),
            title: const Text('Plans'),
            onTap: () {},
          ),
        ],
      ),
      body: const Center(child: Text('Super Admin Dashboard')),
    );
  }
}
