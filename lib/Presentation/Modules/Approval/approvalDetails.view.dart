import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/customPurpleContainer.widget.dart';
import 'package:online_reservation/config/app.color.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ApprovalDetailsScreen extends StatefulWidget {
  static const String screen_id = "/approvalDetails";
  final String? slip_no;
  const ApprovalDetailsScreen({super.key, this.slip_no});

  @override
  State<ApprovalDetailsScreen> createState() => _ApprovalDetailsScreenState();
}

class _ApprovalDetailsScreenState extends State<ApprovalDetailsScreen> {
  late final ScreenshotController screenshotController;
  late WidgetsToImageController controller;
  // late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    screenshotController = ScreenshotController();
    controller = WidgetsToImageController();
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
    final logo = AssetImage('assets/images/SISC_LOGO.png');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
                  color: Color(0xff656565),
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
      ),
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: receiptBody(logo: logo),
      ),
    );
  }

  Widget receiptBody({required AssetImage logo}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text('Reservation Receipt', style: TextStyle(fontSize: 18)),
                    SizedBox(
                        height: 150,
                        child: Image(
                          image: logo,
                        )),
                    Text('Event Name', style: TextStyle(fontSize: 24)),
                    Text('Slip Number', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status: Status', style: TextStyle(fontSize: 10)),
                  Text('Date: April 12, 2022', style: TextStyle(fontSize: 10)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Location: Some Location',
                      style: TextStyle(fontSize: 10)),
                  Text('Contact No: 09294517191',
                      style: TextStyle(fontSize: 10)),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Event Title',
                              style: TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: Text('Event Title',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Participants count',
                              style: TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: Text('Event Title',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              SizedBox(
                height: 10,
              ),
              CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                              Text('Equipment', style: TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Quantity',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Column(
                      children: List.generate(
                        16,
                        (index) => Row(
                          children: [
                            Expanded(
                              child: Text('Participants count',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Expanded(
                              child: Center(
                                child: Text('Event Title',
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              SizedBox(
                height: 10,
              ),
              CustomContainer(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                              Text('Approver', style: TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Role', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child:
                                Text('Status', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Participants count',
                              style: TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: Center(
                              child:
                                  Text('role', style: TextStyle(fontSize: 12))),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text('Participants count',
                              style: TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: Center(
                              child:
                                  Text('role', style: TextStyle(fontSize: 12))),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text('Participants count',
                              style: TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: Center(
                              child:
                                  Text('role', style: TextStyle(fontSize: 12))),
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
  }
}


