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
    print(_tabController.indexIsChanging);
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex &&
          !_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      _tabController.animateTo(index, curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings, size: 30, color: Colors.black),
              ),
            )
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
              padding: const EdgeInsets.symmetric(horizontal: 2),
              controller: _tabController,
              onTap: _onTap,
              tabs: _tabsName
                  .asMap()
                  .map<int, Tab>((index, value) => MapEntry(
                        index,
                        Tab(
                          child: AnimatedContainer(
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _currentIndex == index
                                  ? const Color.fromARGB(255, 173, 173, 173)
                                  : null,
                              boxShadow: _currentIndex == index
                                  ? const [
                                      BoxShadow(
                                          color: Color.fromARGB(
                                              255, 210, 210, 210),
                                          offset: Offset(1, 1),
                                          blurRadius: 2.0,
                                          spreadRadius: 1),
                                    ]
                                  : [],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Text(
                                value,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
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
