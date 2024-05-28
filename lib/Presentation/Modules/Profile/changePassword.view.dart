import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/auth.model.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/message.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/route/route.generator.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const screen_id = "/changePassword";
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform the password change operation
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      // You can add the logic to change the password here
      print('Current Password: $currentPassword');
      print('New Password: $newPassword');

      final profile = Provider.of<EmployeeViewModel>(context, listen: false).profile;
      final updateDetails = UserUpdateDetails(id: profile?.user!, password: newPassword);
      await Provider.of<AuthenticationViewModel>(context, listen: false).updateByAdmin(updateDetails);

      // Clear the fields after submission
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully, you will be logged out.')),
      );
    }

    await Future.delayed(const Duration(seconds: 2));
    await Provider.of<AuthenticationViewModel>(context, listen: false)
        .logout()
        .then((_) => Navigator.of(context).pushNamed(RouteGenerator.loginScreen));
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: ChangePasswordScreen.screen_id,
      title: 'Change Password',
    );
  }

  Widget body() {
    return Consumer<AuthenticationViewModel>(
      builder: (context, authenticationViewModel, child) {
        if (authenticationViewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (authenticationViewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(authenticationViewModel.errorMessage));
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (authenticationViewModel.successMessage.isNotEmpty)
                  SuccessMessage(
                    message: authenticationViewModel.successMessage,
                  ),
                if (authenticationViewModel.errorMessage.isNotEmpty)
                  ErrorMessage(
                    message: authenticationViewModel.errorMessage,
                  ),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    } else if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Change Password'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
