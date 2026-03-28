import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/auth/auth_provider.dart';
import 'package:sokdee_pos/core/auth/auth_state.dart';
import 'package:sokdee_pos/features/kds/kds_screen.dart';
import 'package:sokdee_pos/features/pos/pos_screen.dart';
import 'package:sokdee_pos/features/reports/reports_screen.dart';
import 'package:sokdee_pos/features/settings/settings_screen.dart';
import 'package:sokdee_pos/features/setup_wizard/setup_wizard_screen.dart';
import 'package:sokdee_pos/features/shifts/shifts_screen.dart';
import 'package:sokdee_pos/features/super_admin/super_admin_screen.dart';
import 'package:sokdee_pos/features/super_admin/tenant_detail_screen.dart';
import 'package:sokdee_pos/features/super_admin/tenant_list_screen.dart';
import 'package:sokdee_pos/features/tables/table_floor_plan_screen.dart';
import 'package:sokdee_pos/features/inventory/inventory_screen.dart';
import 'package:sokdee_pos/features/pos/payment_screen.dart';
import 'package:sokdee_pos/features/pos/order_screen.dart';
import 'package:sokdee_pos/features/auth/login_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authAsync = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final auth = authAsync.valueOrNull;
      final isLoginRoute = state.matchedLocation == '/login';

      // Still loading — stay put
      if (auth == null || auth is AuthLoading) return null;

      final isAuthenticated = auth is AuthAuthenticated;

      if (!isAuthenticated && !isLoginRoute) return '/login';
      if (isAuthenticated && isLoginRoute) {
        // Route super_admin to admin dashboard, others to POS
        final role = (auth as AuthAuthenticated).role;
        return role == 'super_admin' ? '/super-admin' : '/pos';
      }
      return null;
    },
    routes: [
      // ── Public ──────────────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Super Admin ──────────────────────────────────────────────────────
      GoRoute(
        path: '/setup-wizard',
        name: 'setup-wizard',
        builder: (context, state) => const SetupWizardScreen(),
      ),
      GoRoute(
        path: '/super-admin',
        name: 'super-admin',
        builder: (context, state) => const SuperAdminScreen(),
        routes: [
          GoRoute(
            path: 'tenants',
            name: 'tenants',
            builder: (context, state) => const TenantListScreen(),
          ),
          GoRoute(
            path: 'tenants/:id',
            name: 'tenant-detail',
            builder: (context, state) => TenantDetailScreen(
              tenantId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),

      // ── POS Shell ────────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => _PosShell(child: child),
        routes: [
          GoRoute(
            path: '/pos',
            name: 'pos',
            builder: (context, state) => const PosScreen(),
            routes: [
              GoRoute(
                path: 'tables',
                name: 'tables',
                builder: (context, state) => const TableFloorPlanScreen(),
              ),
              GoRoute(
                path: 'order/:tableId',
                name: 'order',
                builder: (context, state) => OrderScreen(
                  tableId: state.pathParameters['tableId'],
                ),
              ),
              GoRoute(
                path: 'payment/:orderId',
                name: 'payment',
                builder: (context, state) => PaymentScreen(
                  orderId: state.pathParameters['orderId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/kds',
            name: 'kds',
            builder: (context, state) => const KdsScreen(),
          ),
          GoRoute(
            path: '/inventory',
            name: 'inventory',
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/shifts',
            name: 'shifts',
            builder: (context, state) => const ShiftsScreen(),
          ),
        ],
      ),
    ],
  );
}

/// Shell wrapper for the main POS navigation
class _PosShell extends StatelessWidget {
  const _PosShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
