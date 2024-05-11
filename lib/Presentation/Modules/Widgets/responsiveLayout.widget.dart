import 'package:flutter/material.dart';

import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'navigationDrawer.widget.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;
  final String currentRoute;
  final String title;

  const ResponsiveLayout(
      {super.key,
      required this.mobileBody,
      required this.desktopBody,
      required this.currentRoute,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile view with drawer
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              // leading: Builder(
              //   builder: (BuildContext context) {
              //     return IconButton(
              //       icon: const Icon(Icons.menu),
              //       onPressed: () => Scaffold.of(context).openDrawer(),
              //     );
              //   },
              // ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(RouteGenerator.profileScreen),
                  isSelected: currentRoute == RouteGenerator.profileScreen,
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // Handle notification icon press
                    print("Notifications pressed");
                  },
                ),
              ],
            ),
            drawer: CustomNavigationDrawer(
              currentRoute: currentRoute,
            ),
            body: mobileBody,
          );
        } else {
          // Desktop view with permanent navigation on the left
          return Row(
            children: <Widget>[
              CustomNavigationDrawer(
                currentRoute: currentRoute,
              ), // Permanent navigation drawer
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text("Home"),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(RouteGenerator.profileScreen),
                        isSelected:
                            currentRoute == RouteGenerator.profileScreen,
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          // Handle notification icon press
                          print("Notifications pressed");
                        },
                      ),
                    ],
                  ),
                  body: desktopBody,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
