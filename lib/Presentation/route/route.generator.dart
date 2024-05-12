import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalDetails.view.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalList.view.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/login.view.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/register.view.dart';
import 'package:online_reservation/Presentation/Modules/Calendar/calendar.view.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.view.dart';
import 'package:online_reservation/Presentation/Modules/Event/eventList.view.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.view.dart';
import 'package:online_reservation/Presentation/Modules/Profile/profile.view.dart';
import 'package:online_reservation/Presentation/Modules/Reservation/reservation.view.dart';
import 'package:online_reservation/main.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static const loginScreen = LoginScreen.screen_id;
  static const registerScreen = RegistrationScreen.screen_id;
  static const homeScreen = MyHomePage.screen_id;
  static const employeeScreen = EmployeesScreen.screen_id;
  static const calendarScreen = CalendarScreen.screen_id;
  static const reservationScreen = ReservationScreen.screen_id;
  static const facilityScreen = FacilitiesScreen.screen_id;
  static const profileScreen = ProfileScreen.screen_id;
  static const eventListScreen = EventListScreen.screen_id;
  static const approvalListScreen = ApprovalScreen.screen_id;
  static const approvalDetailsScreen = ApprovalDetailsScreen.screen_id;

  static Route<dynamic> generateRoute(
      RouteSettings settings, BuildContext context) {
    final authViewModel =
        Provider.of<AuthenticationViewModel>(context, listen: false);
    final args = settings.arguments;

    if (authViewModel.isLoggedIn) {
      switch (settings.name) {
        case approvalDetailsScreen:
        if(args is String?) {
            return MaterialPageRoute(
                builder: (_) => ApprovalDetailsScreen(slip_no: args));
          } return MaterialPageRoute(builder: (_) => const ReservationScreen());

        case eventListScreen:
          return MaterialPageRoute(builder: (_) => const EventListScreen());
        // case '/':
        //   return MaterialPageRoute(
        //       builder: (_) => authViewModel.isLoggedIn
        //           ? const MyHomePage(
        //               title: 'Home',
        //             )
        //           : const LoginScreen());
        case registerScreen:
          return MaterialPageRoute(builder: (_) => const RegistrationScreen());
        case homeScreen:
          return MaterialPageRoute(
              builder: (_) => const MyHomePage(title: "Home"));
        case employeeScreen:
          return MaterialPageRoute(builder: (_) => const EmployeesScreen());
        case calendarScreen:
          return MaterialPageRoute(builder: (_) => const CalendarScreen());
        case reservationScreen:
          if (args is ReservationScreenArguments) {
            return MaterialPageRoute(
                builder: (_) => ReservationScreen(args: args,));
          }
          return MaterialPageRoute(builder: (_) => const ReservationScreen());
        case facilityScreen:
          return MaterialPageRoute(builder: (_) => const FacilitiesScreen());
        case profileScreen:
          return MaterialPageRoute(builder: (_) => ProfileScreen());
        case approvalListScreen:
          return MaterialPageRoute(builder: (_) => const ApprovalScreen());
        case loginScreen:
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        default:
          // Handling undefined route
          return _errorRoute();
      }
    } else {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found!")),
      );
    });
  }
}
