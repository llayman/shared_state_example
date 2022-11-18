import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is example is derived from https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple#providerof

// This example depends on the provider library ^6.0.4
// https://pub.dev/packages/provider

// This is a data model that we want to share among many screens
// and other widgets. In this case, it is tracking and sharing the number of
// points the user has accumulated.
// ChangeNotifier is a Flutter class that implements the Observable pattern
class PointTracker extends ChangeNotifier {
  int _pointCount = 0;

  int get points => _pointCount;

  // We call this method whenever we need to change the number of points
  // The notifyListeners() call tells all subscribers/listeners to our PointTracker
  // that there is new data and they need to redraw themselves.
  void updatePoints(int newPoints) {
    _pointCount = newPoints;
    notifyListeners();
  }
}

void main() {
  runApp(
    // This ChangeNotifierProvider comes from the provider library.
    // It is a special widget that enables other widgets (like Screens, Lists, Texts)
    // to "listen" to the PointTracker for changes.
    //
    // Putting the ChangeNotifierProvider here ensures that ALL widgets throughout
    // our app can access the PointTracker.
    ChangeNotifierProvider(
      create: (_) => PointTracker(),
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
            // The Consumer is a special widget that "listens" to the PointTracker in this case.
            // Whenever the PointTracker notifies listeners the data has changed,
            // the Consumer<PointTracker> throughout the app ALL rebuild.
            //
            // In this case, the Consumer<PointTracker> simply returns a Text widget
            // that displays the current point value. We could have it return any kind of widget
            // we want.
            //
            // You can also have multiple Consumer<PointTracker> widgets that return
            // different things in different places.
            //
            // You will see that we have three Consumer widgets on three different screens.
            // Any time the data changes in the PointTracker, all of the consumer widgets
            // will be updated instantly.
            Consumer<PointTracker>(
              builder: (_, pointTracker, child) =>
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
            // Here is a another consumer widget. This one also returns a Text widget
            // but with a different style that on the HomeScreen.
            Consumer<PointTracker>(
              builder: (_, pointTracker, child) => Text(
                "${pointTracker.points}",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            IconButton(
                onPressed: () {
                  // Consumer widgets consume the state of the data object they are listening
                  // to and redraw when it changes.
                  //
                  // Here is how we update that data object. This does not involve working with
                  // a drawn widget directly. We obtain the PointTracker, and call the
                  // updatePoints() method on it that changes the state.
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
              builder: (_, pointTracker, child) =>
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
