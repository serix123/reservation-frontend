
import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'package:provider/provider.dart';

import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';

class ProfileScreen extends StatefulWidget {
  static const screen_id = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState(){
    super.initState();
    Future.microtask(() => Provider.of<EmployeeViewModel>(context, listen: false)
        .fetchProfile());

  }

  void _changePassword() {
    Navigator.of(context).pushNamed(RouteGenerator.changePassword).then((_) {
      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.microtask(() => Provider.of<EmployeeViewModel>(context, listen: false)
              .fetchProfile());
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: ProfileScreen.screen_id,
      title: 'My Profile',
    );
  }

  Widget body(){
    return Consumer<EmployeeViewModel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Profile Details",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _profileDetailField("First Name", viewModel.profile?.firstName ?? ""),
            _profileDetailField("Last Name", viewModel.profile?.lastName ?? ""),
            _profileDetailField("Email Address", viewModel.profile?.email ?? ""),
            _profileDetailField("Department", viewModel.profile?.departmentDetails?.name ?? ""),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Update'),
            ),
          ],
        ),
      );
    },
    );
  }

  Widget _profileDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
