import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/approval.model.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/customPurpleContainer.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Utils/utils.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:provider/provider.dart';

class ApprovalScreen extends StatefulWidget {
  static const String screen_id = "/approvalList";
  const ApprovalScreen({super.key});

  @override
  _ApprovalScreenState createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  ListType? _listValue;
  List<Approval>? lists;
  int? itemCount;

  Future<void> fetchDataFromAPI() async {
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile(),
        Provider.of<ApprovalViewModel>(context, listen: false).fetchApprovals(),
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(Duration(seconds: 1));

      // Check if the widget is still mounted before calling setState.
      if (mounted) {
        setState(() {
          lists =
              Provider.of<EmployeeViewModel>(context, listen: false).approvals;
          _listValue = ListType.Self;
        });
      }
    } catch (error) {
      // Handle or log errors
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataFromAPI();
    });
  }

  Widget body() {
    return Consumer2<ApprovalViewModel, EmployeeViewModel>(
      builder: (context, approvalViewModel, employeeViewModel, child) {
        if ((approvalViewModel.isLoading || employeeViewModel.isLoading) &&
            lists == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Approval for:",
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(
                      width: 20,
                    ),
                    CustomContainer(
                        child: DropdownButton<ListType>(
                      value: _listValue,
                      onChanged: (ListType? newValue) {
                        setState(() {
                          _listValue = newValue;
                          switch (_listValue) {
                            case ListType.Self:
                              setState(() {
                                lists = employeeViewModel.approvals;
                                itemCount = employeeViewModel.approvals.length;
                              });
                              break;
                            case ListType.Admin:
                              setState(() {
                                lists = approvalViewModel.userApproval
                                    .where(
                                        (element) => element.admin_status == 0)
                                    .toList();
                                ;
                                itemCount =
                                    approvalViewModel.userApproval.length;
                              });
                              break;
                            case ListType.ImmediateHead:
                              setState(() {
                                lists = employeeViewModel
                                    .immediate_head_approvals
                                    .where((element) =>
                                        element.immediate_head_status == 0)
                                    .toList();
                                itemCount = employeeViewModel
                                    .immediate_head_approvals.length;
                              });
                              break;
                            case ListType.PersonInCharge:
                              setState(() {
                                lists = employeeViewModel
                                    .person_in_charge_approvals
                                    .where((element) =>
                                        element.person_in_charge_status == 0)
                                    .toList();
                                itemCount = employeeViewModel
                                    .person_in_charge_approvals.length;
                              });
                              break;
                            case null:
                            // TODO: Handle this case.
                          }
                        });
                      },
                      items: ListType.values.map((ListType type) {
                        return DropdownMenuItem<ListType>(
                          enabled: (type != ListType.Admin ||
                                  employeeViewModel.profile.isAdmin!) &&
                              (type != ListType.PersonInCharge ||
                                  employeeViewModel.profile.managed_facilities!
                                      .isNotEmpty) &&
                              (type != ListType.ImmediateHead ||
                                  employeeViewModel
                                      .immediate_head_approvals!.isNotEmpty),
                          value: type,
                          child: Text(
                            Utils.formatEnumString(
                                type.toString().split('.').last),
                            style: TextStyle(
                              color: Colors.deepPurple[400],
                            ),
                          ),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      underline: const SizedBox(),
                    )),
                  ],
                ),
              ),
              lists == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      shrinkWrap: true,
                      children: lists!.map((item) {
                        if (approvalViewModel.isLoading ||
                            employeeViewModel.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 12),
                          child: CustomContainer(
                            child: ListTile(
                              title: Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Slip No. - ${item.slip_number}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 11,
                                        color: Colors.deepPurple[400]),
                                  ),
                                  Text(
                                    item.event_details?.event_name ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Colors.deepPurple[400]),
                                  ),
                                  Text(
                                    item.event_details?.event_description ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              trailing: _listValue != ListType.Self
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        // Approve button
                                        TextButton(
                                          onPressed: () {
                                            _showConfirmationDialog(
                                                item.slip_number!, true);
                                          },
                                          child: Text('Approve'),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.green),
                                        ),
                                        // Reject button
                                        TextButton(
                                          onPressed: () {
                                            _showConfirmationDialog(
                                                item.slip_number!, false);
                                          },
                                          child: Text('Reject'),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Colors.red),
                                        ),
                                      ],
                                    )
                                  : const Icon(Icons.remove_red_eye,
                                      color: kPurpleDark),
                            ),
                          ),
                        );
                      }).toList(),
                    )
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: itemCount,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 32.0, vertical: 12),
              //       child: CustomContainer(
              //         child: ListTile(
              //           title: Column(
              //             // mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 "Slip No. - ${lists[index].slip_number}",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.w200,
              //                     fontSize: 11,
              //                     color: Colors.deepPurple[400]),
              //               ),
              //               Text(
              //                 lists[index].event_details?.event_name ??
              //                     "",
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.w700,
              //                     fontSize: 18,
              //                     color: Colors.deepPurple[400]),
              //               ),
              //               Text(
              //                 lists[index].event_details?.event_description ??
              //                     "",
              //                 style: const TextStyle(
              //                   fontWeight: FontWeight.normal,
              //                   fontSize: 12,
              //                 ),
              //               )
              //             ],
              //           ),
              //           trailing: Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: <Widget>[
              //               // Approve button
              //               TextButton(
              //                 onPressed: () =>
              //                     _showConfirmationDialog(index, true),
              //                 child: Text('Approve'),
              //                 style: TextButton.styleFrom(
              //                     foregroundColor: Colors.green),
              //               ),
              //               // Reject button
              //               TextButton(
              //                 onPressed: () =>
              //                     _showConfirmationDialog(index, false),
              //                 child: Text('Reject'),
              //                 style: TextButton.styleFrom(
              //                     foregroundColor: Colors.red),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: body(),
        desktopBody: body(),
        currentRoute: ApprovalScreen.screen_id,
        title: "Event List");
  }

  void _showConfirmationDialog(String slipNo, bool approved) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ApprovalViewModel>(
            builder: (context, approvalViewModel, child) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Text(
                'Are you sure you want to ${approved ? "approve" : "reject"} this item?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  switch (_listValue) {
                    case null:
                      // TODO: Handle this case.
                      break;
                    case ListType.Self:
                      // TODO: Handle this case.
                      break;
                    case ListType.ImmediateHead:
                      // TODO: Handle this case.
                      if (await approvalViewModel.approveByHead(slipNo)) {
                        await Provider.of<EmployeeViewModel>(context,
                                listen: false)
                            .fetchProfile();
                        setState(() {
                          _listValue = ListType.Self;
                          lists = Provider.of<EmployeeViewModel>(context,
                                  listen: false)
                              .approvals;
                        });
                      }
                      break;
                    case ListType.PersonInCharge:
                      // TODO: Handle this case.
                      if (await approvalViewModel.approveByPIC(slipNo)) {
                        await Provider.of<EmployeeViewModel>(context,
                                listen: false)
                            .fetchProfile();
                        setState(() {
                          _listValue = ListType.Self;
                          lists = Provider.of<EmployeeViewModel>(context,
                                  listen: false)
                              .approvals;
                        });
                      }
                      break;
                    case ListType.Admin:
                      // TODO: Handle this case.
                      if (await approvalViewModel.approveAdmin(slipNo)) {
                        await Provider.of<EmployeeViewModel>(context,
                                listen: false)
                            .fetchProfile();
                        setState(() {
                          _listValue = ListType.Self;
                          lists = Provider.of<EmployeeViewModel>(context,
                                  listen: false)
                              .approvals;
                        });
                      }
                      break;
                  }
                  // _approveItem(index, approved);
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  switch (_listValue) {
                    case null:
                      // TODO: Handle this case.
                      break;
                    case ListType.Self:
                      // TODO: Handle this case.
                      break;
                    case ListType.ImmediateHead:
                      // TODO: Handle this case.
                      if (await approvalViewModel.rejectByHead(slipNo)) {
                        await Provider.of<EmployeeViewModel>(context,
                                listen: false)
                            .fetchProfile();
                        setState(() {
                          _listValue = ListType.Self;
                          lists = Provider.of<EmployeeViewModel>(context,
                                  listen: false)
                              .approvals;
                        });
                      }
                      break;
                    case ListType.PersonInCharge:
                      // TODO: Handle this case.
                      if (await approvalViewModel.rejectByPIC(slipNo)) {
                        await Provider.of<EmployeeViewModel>(context,
                                listen: false)
                            .fetchProfile();
                        setState(() {
                          _listValue = ListType.Self;
                          lists = Provider.of<EmployeeViewModel>(context,
                                  listen: false)
                              .approvals;
                        });
                      }
                      break;
                    case ListType.Admin:
                      // TODO: Handle this case.
                      if (await approvalViewModel.rejectAdmin(slipNo)) {
                        await Provider.of<EmployeeViewModel>(context,
                                listen: false)
                            .fetchProfile();
                        setState(() {
                          _listValue = ListType.Self;
                          lists = Provider.of<EmployeeViewModel>(context,
                                  listen: false)
                              .approvals;
                        });
                      }
                      break;
                  }
                },
                child: Text('No'),
              ),
            ],
          );
        });
      },
    );
  }
}
