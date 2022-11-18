import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointTracker extends ChangeNotifier {
  int _pointCount = 0;

  int get points => _pointCount;

  void updatePoints(int newPoints) {
    _pointCount = newPoints;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PointTracker(),
      child: const MaterialApp(
        title: "Provider Example",
        home: HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Our Homescreen")),
        body: Center(
            child: Column(
          children: [
            const Text(
              "Current Points",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Consumer<PointTracker>(
              builder: (context, pointTracker, child) =>
                  Text("${pointTracker.points}"),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const EarnPointsScreen())),
                  child: const Text("Earn Points"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SpendPointsScreen())),
                  child: const Text("Spend Points"),
                )
              ],
            )
          ],
        )));
  }
}

class EarnPointsScreen extends StatelessWidget {
  const EarnPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Earning Points")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<PointTracker>(
              builder: (context, pointTracker, child) =>
                  Text("${pointTracker.points}"),
            ),
            IconButton(
                onPressed: () {
                  PointTracker p =
                      Provider.of<PointTracker>(context, listen: false);
                  p.updatePoints(p.points + 1);
                },
                icon: const Icon(Icons.add_circle_outline))
          ],
        ),
      ),
    );
  }
}

class SpendPointsScreen extends StatelessWidget {
  const SpendPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spending Points")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<PointTracker>(
              builder: (context, pointTracker, child) =>
                  Text("${pointTracker.points}"),
            ),
            IconButton(
                onPressed: () {
                  PointTracker p =
                      Provider.of<PointTracker>(context, listen: false);
                  p.updatePoints(p.points - 1);
                },
                icon: const Icon(Icons.remove_circle_outline)),
          ],
        ),
      ),
    );
  }
}
