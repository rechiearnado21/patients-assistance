import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../dialogs.dart';
import '../dashboard_nurse/nurse_dashboard.dart';
import 'controller.dart';

class LandingScreen extends GetView<LandingController> {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LandingBodyScreen();
  }
}

class LandingBodyScreen extends StatefulWidget {
  const LandingBodyScreen({super.key});

  @override
  State<LandingBodyScreen> createState() => _LandingBodyScreenState();
}

class _LandingBodyScreenState extends State<LandingBodyScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        CustomDialog(
            title: 'Hang on',
            message: 'Are you sure you want to close the app?',
            onTap: () {
              SystemNavigator.pop();
            }).defaultDialog();
        return false;
      },
      child: Scaffold(
        body: bottomBarPages[pageIndex],
        extendBody: true,
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
