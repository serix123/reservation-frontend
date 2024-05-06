import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/login.view.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/register.view.dart';
import 'package:online_reservation/Presentation/Modules/Calendar/calendar.view.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.view.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.view.dart';
import 'package:online_reservation/Presentation/Modules/Reservation/reservation.view.dart';
import 'package:online_reservation/Presentation/Modules/Screens/first.screen.dart';
import 'package:online_reservation/Presentation/Modules/Screens/request.detail.dart';
import 'package:online_reservation/Presentation/Modules/Screens/request.list.dart';
import 'package:online_reservation/Presentation/Modules/Screens/second.screen.dart';
import 'package:online_reservation/Presentation/Modules/Screens/third.screen.dart';
import 'package:online_reservation/Presentation/Modules/Screens/timetable.screen.dart';
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



  static Route<dynamic> generateRoute(RouteSettings settings,  BuildContext context) {
    final authViewModel = Provider.of<AuthenticationViewModel>(context, listen: false);
    final args = settings.arguments;

    if (settings.name == homeScreen) {
      if (true) {
      // if (authViewModel.isLoggedIn) {
        return MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Home',));
      } else {
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      }
    }

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => authViewModel.isLoggedIn ? const MyHomePage(title: 'Home',) : const LoginScreen());
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case homeScreen:
          return MaterialPageRoute(builder: (_) => const MyHomePage(title: "Home"));
      case employeeScreen:
        return MaterialPageRoute(builder: (_) => const EmployeesScreen());
      case calendarScreen:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case reservationScreen:
        return MaterialPageRoute(builder: (_) => const ReservationScreen());
      case facilityScreen:
        return MaterialPageRoute(builder: (_) => const FacilitiesScreen());
      // case RequestListScreen.screen_id:
      //   return MaterialPageRoute(builder: (_) => const RequestListScreen());
      // case RequestDetailScreen.screen_id:
      //   if(args is String){
      //     return MaterialPageRoute(builder: (_) => RequestDetailScreen(request:args,));
      //   } else{
      //     return MaterialPageRoute(builder: (_) => const MyHomePage(title: "Home"));
      //   }
      // case FirstScreen.screen_id:
      //   return MaterialPageRoute(builder: (_) => const FirstScreen());
      // case SecondScreen.screen_id:
      //   return MaterialPageRoute(builder: (_) => const SecondScreen());
      // case ThirdScreen.screen_id:
      //   return MaterialPageRoute(builder: (_) => const ThirdScreen());
      //   case TimetableScreen.screen_id:
      //   return MaterialPageRoute(builder: (_) => const TimetableScreen());
      default:
      // Handling undefined route
        return _errorRoute();
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
