  
import 'package:damm_2024/widgets/tokens/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      
      child: Scaffold(
        appBar: AppBar(

          backgroundColor: ProjectPalette.secondary5,
          title: Image.asset('lib/widgets/atoms/logo_rectangular.png'),
          bottom:  TabBar(
            onTap: (index) {
              widget.child.goBranch(
                index,
                initialLocation: index == widget.child.currentIndex,
              );
              setState(() {});
            },
            controller: _tabController,
            tabs: const [
              Tab(text: 'Postularse'),
              Tab(text: 'Mi perfil'),
              Tab(text: 'Novedades'),
            ],
          )
        ),
        body: widget.child
      ),
    );
  }
}
