import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/deep_links/deep_link_service.dart';
import 'app_services.dart';
import 'router.dart';
import 'theme.dart';

class TripmeterApp extends ConsumerStatefulWidget {
  const TripmeterApp({super.key});

  @override
  ConsumerState<TripmeterApp> createState() => _TripmeterAppState();
}

class _TripmeterAppState extends ConsumerState<TripmeterApp>
    with WidgetsBindingObserver {
  late final GoRouter _router;
  DeepLinkService? _deepLinks;

  @override
  void initState() {
    super.initState();
    final services = ref.read(appServicesProvider);
    _router = buildRouter(services.session);
    _deepLinks = DeepLinkService(
      session: services.session,
      router: _router,
    );
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinks?.initialize();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appServicesProvider).sync.onAppResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinks?.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TripMeter',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
