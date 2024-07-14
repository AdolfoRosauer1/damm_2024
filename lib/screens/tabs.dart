import 'package:damm_2024/providers/connectivity_provider.dart';
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  ConsumerState<Tabs> createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.child.currentIndex);
  }

  @override
  void didUpdateWidget(Tabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child.currentIndex != _tabController.index) {
      _tabController.index = widget.child.currentIndex;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(internetConnectionProvider);
    final internet = internetStatus.value! == InternetStatus.connected;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              backgroundColor: ProjectPalette.secondary5,
              title: Row(
                children: [
                  Image.asset('assets/images/logo_rectangular.png'),
                  if (!internet)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.cloud_off, color: Colors.red),
                        ],
                      ),
                    ),
                ],
              ),
              bottom: TabBar(
                onTap: (index) {
                  widget.child.goBranch(
                    index,
                    initialLocation: index == widget.child.currentIndex,
                  );
                },
                controller: _tabController,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.apply),
                  Tab(text: AppLocalizations.of(context)!.profile),
                  Tab(text: AppLocalizations.of(context)!.news),
                ],
              )),
          body: widget.child),
    );
  }
}
