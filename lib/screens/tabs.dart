  
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Tabs extends StatefulWidget {
  const Tabs({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  State<Tabs> createState() => _TabsState();

}
class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.child.currentIndex);
    
    super.initState();
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
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(

          backgroundColor: ProjectPalette.secondary5,
          title: Image.asset('assets/images/logo_rectangular.png'),
          bottom:  TabBar(
            onTap: (index) {
              widget.child.goBranch(
                index,
                initialLocation: index == widget.child.currentIndex,
              );
              setState(() {});
            },
            controller: _tabController,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.apply),
              Tab(text: AppLocalizations.of(context)!.profile),
              Tab(text: AppLocalizations.of(context)!.news),
            ],
          )
        ),
        body: widget.child
      ),
    );
  }
}

