import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Event/event.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Notifications/notification.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Reservation/reservation.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await initPathProvider();
  }
  runApp(const MyApp());
}

Future<void> initPathProvider() async {
  // Get the application documents directory
  await getApplicationDocumentsDirectory();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApprovalViewModel()),
        ChangeNotifierProvider(create: (context) => AuthenticationViewModel()),
        ChangeNotifierProvider(create: (context) => DepartmentViewModel()),
        ChangeNotifierProvider(create: (context) => EmployeeViewModel()),
        ChangeNotifierProvider(create: (context) => EquipmentViewModel()),
        ChangeNotifierProvider(create: (context) => EventViewModel()),
        ChangeNotifierProvider(create: (context) => FacilityViewModel()),
        ChangeNotifierProvider(create: (context) => NotificationViewModel()),
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
          initialRoute: RouteGenerator.calendarScreen,
          // initialRoute: RouteGenerator.approvalListScreen,
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
    Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile();
    return ResponsiveLayout(
      mobileBody: ListView(
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
            routeName: RouteGenerator.facilityListScreen,
          ),
        ],
      ),
      desktopBody: ListView(
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
            routeName: RouteGenerator.facilityListScreen,
          ),
        ],
      ),
      currentRoute: MyHomePage.screen_id,
      title: 'Home',
    );
  }

  Widget cardTile(BuildContext context,
      {required String title,
      required IconData icon,
      required String routeName}) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2, // Adjust shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        onTap: () => Navigator.of(context).pushNamed(routeName),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
