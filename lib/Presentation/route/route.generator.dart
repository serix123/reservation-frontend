import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/department.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalDetails.view.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalList.view.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/login.view.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/register.view.dart';
import 'package:online_reservation/Presentation/Modules/Calendar/calendar.view.dart';
import 'package:online_reservation/Presentation/Modules/Department/department.view.dart';
import 'package:online_reservation/Presentation/Modules/Department/departmentUpdate.view.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.view.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employeeCSV.view.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employeeRegister.view.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employeeUpdate.view.dart';
import 'package:online_reservation/Presentation/Modules/Event/eventList.view.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facility.view.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.view.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityUpdate.view.dart';
import 'package:online_reservation/Presentation/Modules/Profile/changePassword.view.dart';
import 'package:online_reservation/Presentation/Modules/Profile/profile.view.dart';
import 'package:online_reservation/Presentation/Modules/Reservation/reservation.view.dart';
import 'package:online_reservation/main.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static const approvalDetailsScreen = ApprovalDetailsScreen.screen_id;
  static const approvalListScreen = ApprovalScreen.screen_id;
  static const calendarScreen = CalendarScreen.screen_id;
  static const departmentScreen = DepartmentScreen.screen_id;
  static const departmentUpdateScreen = DepartmentEditScreen.screen_id;
  static const employeeScreen = EmployeesScreen.screen_id;
  static const employeeUpdateScreen = EmployeeEditScreen.screen_id;
  static const employeeRegisterScreen = EmployeeRegisterScreen.screen_id;
  static const employeeRegisterCSVScreen = EmployeeCSVImportScreen.screen_id;
  static const eventListScreen = EventListScreen.screen_id;
  static const facilityScreen = FacilityScreen.screen_id;
  static const facilityListScreen = FacilitiesListScreen.screen_id;
  static const facilityUpdateScreen = FacilityEditScreen.screen_id;
  static const homeScreen = MyHomePage.screen_id;
  static const loginScreen = LoginScreen.screen_id;
  static const profileScreen = ProfileScreen.screen_id;
  static const changePassword = ChangePasswordScreen.screen_id;
  static const registerScreen = RegistrationScreen.screen_id;
  static const reservationScreen = ReservationScreen.screen_id;

  static Route<dynamic> generateRoute(RouteSettings settings, BuildContext context) {
    final authViewModel = Provider.of<AuthenticationViewModel>(context, listen: false);
    final args = settings.arguments;

    if (authViewModel.isLoggedIn) {
      switch (settings.name) {
        case approvalDetailsScreen:
          if (args is String?) {
            return MaterialPageRoute(builder: (_) => ApprovalDetailsScreen(slipNo: args));
          }
          return MaterialPageRoute(builder: (_) => const ReservationScreen());

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
          return MaterialPageRoute(builder: (_) => const MyHomePage(title: "Home"));
        case departmentScreen:
          return MaterialPageRoute(builder: (_) => const DepartmentScreen());
        case departmentUpdateScreen:
          if (args is Department?) {
            return MaterialPageRoute(
                builder: (_) => DepartmentEditScreen(
                      department: args,
                    ));
          } else {
            return _errorRoute();
          }
        case employeeScreen:
          return MaterialPageRoute(builder: (_) => const EmployeesScreen());
        case employeeRegisterScreen:
          return MaterialPageRoute(builder: (_) => const EmployeeRegisterScreen());
        case employeeRegisterCSVScreen:
          return MaterialPageRoute(builder: (_) => const EmployeeCSVImportScreen());
        case employeeUpdateScreen:
          if (args is Employee) {
            return MaterialPageRoute(
                builder: (_) => EmployeeEditScreen(
                      employee: args,
                    ));
          } else {
            return _errorRoute();
          }
        case calendarScreen:
          return MaterialPageRoute(builder: (_) => const CalendarScreen());
        case reservationScreen:
          if (args is ReservationScreenArguments?) {
            return MaterialPageRoute(
            builder: (_) => ReservationScreen(args: args,));
          }
          return MaterialPageRoute(builder: (_) => const ReservationScreen());
        case facilityScreen:
          return MaterialPageRoute(builder: (_) => const FacilityScreen());
        case facilityListScreen:
          return MaterialPageRoute(builder: (_) => const FacilitiesListScreen());
        case facilityUpdateScreen:
          if (args is Facility?) {
            return MaterialPageRoute(
                builder: (_) => FacilityEditScreen(
                      facility: args,
                    ));
          } else {
            return _errorRoute();
          }
        case profileScreen:
          return MaterialPageRoute(builder: (_) => ProfileScreen());
        case changePassword:
          return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
        case approvalListScreen:
          return MaterialPageRoute(builder: (_) => const ApprovalScreen());
        case loginScreen:
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        default:
          // Handling undefined route
          return _errorRoute();
      }
    } else {
      switch (settings.name) {
        case registerScreen:
          return MaterialPageRoute(builder: (_) => const RegistrationScreen());
        case loginScreen:
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        default:
          return MaterialPageRoute(builder: (_) => const LoginScreen());
      }
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
