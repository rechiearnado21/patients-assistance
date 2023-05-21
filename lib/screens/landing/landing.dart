import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

import '../dashboard_nurse/nurse_dashboard.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int pageIndex = 0;

  /// widget list
  final List<Widget> bottomBarPages = [
    const NurseDashboard(),
    const Page2(),
    const Page1(),
  ];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomBarPages[pageIndex],
      extendBody: true,
      bottomNavigationBar: MoltenBottomNavigationBar(
        selectedIndex: pageIndex,
        domeHeight: 25,
        barColor: Colors.grey.shade100,
        // specify what will happen when a tab is clicked
        onTabChange: (clickedIndex) {
          setState(() {
            pageIndex = clickedIndex;
          });
        },
        // ansert as many tabs as you like
        tabs: [
          MoltenTab(
            icon: Icon(Icons.task_outlined),
            title: Text('Chart'),
            // selectedColor: Colors.yellow,
          ),
          MoltenTab(
            icon: Icon(Icons.home),
            title: Text('History'),
            // selectedColor: Colors.yellow,
          ),
          MoltenTab(
            icon: Icon(Icons.person),
            title: Text('Account'),
            // selectedColor: Colors.yellow,
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.yellow, child: const Center(child: Text('Page 1')));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Center(child: Text('Page 2')));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red, child: const Center(child: Text('Page 3')));
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue, child: const Center(child: Text('Page 4')));
  }
}

class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreenAccent,
        child: const Center(child: Text('Page 4')));
  }
}
