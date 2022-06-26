import 'package:flutter/material.dart';
import 'package:stopwatch/app/tabs/tabs.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 10.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: TabBar(
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
