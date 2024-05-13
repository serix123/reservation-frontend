import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:online_reservation/Data/Models/approval.model.dart';
import 'package:online_reservation/Data/Models/employee.model.dart';
import 'package:online_reservation/Data/Models/equipment.model.dart';
import 'package:online_reservation/Data/Models/event.model.dart';
import 'package:online_reservation/Presentation/Modules/Approval/approvalList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Authentication/auth.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Employee/employee.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Event/event.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Reservation/reservation.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/customPurpleContainer.widget.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:screenshot/screenshot.dart';

class ApprovalDetailsScreen extends StatefulWidget {
  static const String screen_id = "/approvalDetails";
  final String? slipNo;
  const ApprovalDetailsScreen({super.key, this.slipNo});

  @override
  State<ApprovalDetailsScreen> createState() => _ApprovalDetailsScreenState();
}

class _ApprovalDetailsScreenState extends State<ApprovalDetailsScreen> {
  late final ScreenshotController screenshotController;
  late WidgetsToImageController controller;
  // late ScrollController scrollController;
  late Receipt receipt = Receipt();
  bool stateLoaded = false;

  Future<void> initData() async {
    var getEventFuture = widget.slipNo != null
        ? Provider.of<EventViewModel>(context, listen: false)
            .fetchEvent(widget.slipNo!)
        : Future.value(null);
    try {
      // Gather all asynchronous operations.
      await Future.wait([
        Provider.of<ApprovalViewModel>(context, listen: false)
            .fetchApprovals(),
        Provider.of<EquipmentViewModel>(context, listen: false)
            .fetchEquipment(),
        Provider.of<FacilityViewModel>(context, listen: false)
            .fetchFacilities(),
        Provider.of<AuthenticationViewModel>(context, listen: false)
            .refreshAccessToken(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchProfile(),
        Provider.of<EmployeeViewModel>(context, listen: false).fetchEmployees(),
        getEventFuture,
      ]);

      // Use a short delay to simulate a network call (if needed).
      await Future.delayed(const Duration(seconds: 1));

      // Check if the widget is still mounted before calling setState.
      if (mounted) {
        var approval = Provider.of<ApprovalViewModel>(context, listen: false)
            .userApproval
            .firstWhere((approval) => approval.slip_number == widget.slipNo);
        Employee immediate_head = Provider.of<EmployeeViewModel>(context,
                listen: false)
            .employees
            .firstWhere(
                (employee) => employee.id == approval.immediate_head_approver);
        Employee person_in_charge =
            Provider.of<EmployeeViewModel>(context, listen: false)
                .employees
                .firstWhere((employee) =>
                    employee.id == approval.person_in_charge_approver);
        // Employee admin = Provider.of<EmployeeViewModel>(context, listen: false)
        //     .employees
        //     .firstWhere((employee) => employee.id == approval.admin_approver);
        var eventEquipments =
            Provider.of<EventViewModel>(context, listen: false)
                .userEvent!
                .equipments!;
        List<Equipment> equipments = [];
        for (var eventEquipment in eventEquipments) {
          var equipment = Provider.of<EquipmentViewModel>(context, listen: false)
              .equipments
              .firstWhere(
                  (equipment) => equipment.id == eventEquipment.equipment);
          equipment.equipment_quantity = eventEquipment.quantity;
          equipments.add(equipment);
        }
        setState(() {
          receipt.event =
              Provider.of<EventViewModel>(context, listen: false).userEvent!;
          receipt.approval = approval;
          receipt.equipments = equipments;
          receipt.immediate_head =
              "${immediate_head.firstName} ${immediate_head.lastName}";
          receipt.person_in_charge =
              "${person_in_charge.firstName} ${person_in_charge.lastName}";
          // receipt.admin = "${admin.firstName} ${admin.lastName}";
        });
        stateLoaded = true;
      }
    } catch (error) {
      // Handle or log errors
      print('Error fetching data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    screenshotController = ScreenshotController();
    controller = WidgetsToImageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
    // scrollController = ScrollController();
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(":", "-");
    final name = "Screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes,
        name: "Approval Details $name");
    return result['filePath'];
  }

  @override
  Widget build(BuildContext context) {
    final logo = const AssetImage('assets/images/SISC_LOGO.png');

      return Scaffold(
        floatingActionButton:
         kIsWeb == false ?
      FloatingActionButton(
        onPressed: () async {
          // Capture a screenshot of the widget
          final image = await screenshotController.capture();
          // final image = await screenshotController.captureFromWidget(
          //   receiptBody(context: context, logo: logo),
          // );
          // final image = await controller.capture();
          if (image == null) return;
          var filepath = await saveImage(image);
          print(filepath);
          // Handle the screenshot image (e.g., save it or share it)
          // Share the captured screenshot
          // Share.shareFiles([image?.path]);
          // You can use the image variable to save or share the screenshot
          final snackBar = SnackBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            dismissDirection: DismissDirection.none,
            padding: EdgeInsets.zero,
            margin: const EdgeInsets.only(bottom: 15),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            content: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xff656565),
                ),
                child: const Text('Screenshot saved in gallery.'),
              ),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        backgroundColor: kPurpleDark,
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 20,
        ),
      ) : null,
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: receiptBody(logo: logo),
      ),
    );
  }

  Widget receiptBody({required AssetImage logo}) {
    return Consumer4<ApprovalViewModel, EmployeeViewModel, EventViewModel,
        FacilityViewModel>(
      builder: (context, approvalViewModel, employeeViewModel, eventViewModel,
          facilityViewModel, child) {
        if (approvalViewModel.isLoading ||
            employeeViewModel.isLoading ||
            eventViewModel.isLoading ||
            !stateLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Text('Reservation Receipt',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(
                            height: 150,
                            child: Image(
                              image: logo,
                            )),
                        Text(
                            receipt.event?.event_name?.toUpperCase() ?? "",
                            style: const TextStyle(fontSize: 24)),
                        Text(
                            receipt.event?.slip_number?.toUpperCase() ?? "",
                            style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Status: ${receipt.event?.status?.toUpperCase() ?? ""}',
                          style: const TextStyle(fontSize: 10)),
                      Text(
                          'Date: ${DateFormat('MMMM d, yyyy').format(receipt.approval?.status_update_date ?? DateTime.now())}',
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Location: ${facilityViewModel.facilities.firstWhere((facility) => receipt.event?.reserved_facility == facility.id).name ?? "Facility Blank"}',
                          style: const TextStyle(fontSize: 10)),
                      Text('Contact No: ${receipt.event?.contact_number ?? ""}',
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomContainer(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Event Personnel',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('${employeeViewModel.profile?.firstName ?? ""} ${employeeViewModel.profile?.lastName ?? ""} ',
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Participants count',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                    '${receipt.event?.participants_quantity ?? 0}',
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  if(receipt.equipments?.length != null && receipt.equipments!.length > 0)
                  CustomContainer(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text('Equipment',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('Quantity',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Column(
                          children: List.generate(
                            receipt.equipments?.length ?? 0,
                            (index) => Row(
                              children: [
                                Expanded(
                                  child: Text('${receipt.equipments?[index].equipment_name}',
                                      style: const TextStyle(fontSize: 12)),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text('${receipt.equipments?[index].equipment_quantity}',
                                        style: const TextStyle(fontSize: 12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                   CustomContainer(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              child: Text('Approver',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('Role',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('Status',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(receipt.immediate_head ?? "unavailable",
                                  style: const TextStyle(fontSize: 12)),
                            ),
                            const Expanded(
                              child: Center(
                                  child: Text('Immediate Head',
                                      style: TextStyle(fontSize: 12))),
                            ),
                            const Expanded(
                              child: Icon(
                                Icons.check_circle,
                                color: success,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:Text(receipt.person_in_charge ?? "unavailable",
                                  style: const TextStyle(fontSize: 12)),
                            ),
                            const Expanded(
                              child: Center(
                                  child: Text('Person-in-Charge',
                                      style: TextStyle(fontSize: 12))),
                            ),
                            const Expanded(
                              child: Icon(
                                Icons.check_circle,
                                color: success,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: SizedBox()
                              // Text(receipt.admin ?? "unavailable",
                              //     style: const TextStyle(fontSize: 12)),
                            ),
                            Expanded(
                              child: Center(
                                  child: Text('Admin',
                                      style: TextStyle(fontSize: 12))),
                            ),
                            Expanded(
                              child: Icon(
                                Icons.check_circle,
                                color: success,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),

                  // Add more event details here
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Receipt {
  Event? event;
  Approval? approval;
  List<Equipment>? equipments;
  String? immediate_head;
  String? person_in_charge;
  // String? admin;

  Receipt({
    this.event,
    this.approval,
    this.immediate_head,
    this.equipments,
    this.person_in_charge,
    // this.admin
  });
}
