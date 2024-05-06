import 'package:flutter/material.dart';
import 'package:online_reservation/Data/Models/facility.model.dart';

import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:provider/provider.dart';

class FacilitiesScreen extends StatefulWidget {
  static const screen_id = "/facility";

  const FacilitiesScreen({super.key});

  @override
  _FacilitiesScreenState createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {

  late FacilityViewModel viewmodel;

  @override
  void initState() {
    super.initState();

    // Future.microtask(() =>
    //     Provider.of<FacilityViewModel>(context, listen: false).fetchFacilities()
    // );
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel =
    //     Provider.of<FacilityViewModel>(context, listen: false);
    // final List<Facility> facilities = viewModel.facilities;
    return Scaffold(
      appBar: AppBar(
        title: Text("Facilities"),
      ),
      body: Consumer<FacilityViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if(viewModel.errorMessage.isNotEmpty){
            return Center(child: Text(viewModel.errorMessage));
          }
          return ListView.builder(
            itemCount: viewModel.facilities.length,
            itemBuilder: (context, index) {
              Facility facility = viewModel.facilities[index];
              return ListTile(
                title: Text(facility.name),
                subtitle: Text("Some description..."),
                onTap: () {
                  // Placeholder for navigation or further interaction
                  print("Tapped on ${facility.name}");
                },
              );
            },
          );
        },
      ),
    );
  }
}
