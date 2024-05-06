import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.view.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Screens/first.screen.dart';
import 'package:online_reservation/Presentation/Modules/Screens/second.screen.dart';
import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'package:online_reservation/config/scrollbar.behavior.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EmployeeViewModel()),
        ChangeNotifierProvider(create: (context) => AuthenticationViewModel()),
        ChangeNotifierProvider(create: (context) => FacilityViewModel()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Online Reservation App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: RouteGenerator.homeScreen,
          onGenerateRoute: (settings) =>
              RouteGenerator.generateRoute(settings, context),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  static const String screen_id = "/";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void stateHandler() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
              print("Notifications pressed");
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          cardTile(
            context,
            title: "Online Reservation",
            icon: Icons.book_online,
            routeName: RouteGenerator.reservationScreen,
          ),
          cardTile(
            context,
            title: "Request Approval",
            icon: Icons.approval,
            routeName: '/requestApproval',
          ),
          cardTile(
            context,
            title: "Scheduled Reservations",
            icon: Icons.schedule,
            routeName: RouteGenerator.calendarScreen,
          ),
          cardTile(
            context,
            title: "My Reservations",
            icon: Icons.list,
            routeName: '/myReservations',
          ),
          cardTile(
            context,
            title: "Facilities",
            icon: Icons.business,
            routeName: RouteGenerator.facilityScreen,
          ),
        ],
      ),
    );
  }

  Widget cardTile(BuildContext context, {required String title, required IconData icon, required String routeName}) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 2, // Adjust shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        onTap: () => Navigator.of(context).pushNamed(routeName),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
