import 'package:flutter/material.dart';
import 'package:stopwatch/app/tabs/tabs.dart';
import 'package:stopwatch/app/widgets/app_drawer.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;

  final List<Widget> _tabs = const [
    AlarmTab(),
    StopwatchTab(),
    TimmerTab(),
    ClocksTab(),
  ];

  final List<String> _tabsName = const [
    'Alarm',
    'Stopwatch',
    'Timmer',
    'Clock'
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: _currentIndex,
      length: 4,
      vsync: this,
    );

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    _tabController.addListener(() {
      if (_tabController.index != _currentIndex &&
          !_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      _tabController.animateTo(
        index,
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        drawer: const AppDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            AnimatedBuilder(
                animation: _animationController,
                builder: (context, animation) {
                  return IconButton(
                    onPressed: () {
                      _animationController.forward();
                      Scaffold.of(context).openDrawer();
                    },
                    icon: AnimatedIcon(
                        color: Colors.black,
                        icon: AnimatedIcons.arrow_menu,
                        progress: _animationController),
                  );
                })
          ],
          bottom: TabBar(
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) =>
                      states.contains(MaterialState.focused)
                          ? null
                          : Colors.transparent),
              indicator: const BoxDecoration(),
              labelPadding: EdgeInsets.zero,
              padding: const EdgeInsets.symmetric(horizontal: 1),
              controller: _tabController,
              onTap: _onTap,
              tabs: _tabsName
                  .asMap()
                  .map<int, Tab>((index, tabName) => MapEntry(
                        index,
                        Tab(
                          child: AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 400),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: _currentIndex == index
                                  ? const Color.fromARGB(220, 220, 220, 220)
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                tabName,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1,
                                        color: _currentIndex == index
                                            ? const Color.fromARGB(
                                                255, 43, 43, 43)
                                            : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .values
                  .toList()),
        ),
        body: TabBarView(
          controller: _tabController,
          children: _tabs,
        ));
  }
}
