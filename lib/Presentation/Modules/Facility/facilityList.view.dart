import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:online_reservation/Presentation/Modules/Facility/facilityList.viewmodel.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/responsiveLayout.widget.dart';
import 'package:online_reservation/Presentation/Modules/Widgets/facilityCard.widget.dart';


class FacilitiesScreen extends StatefulWidget {
  static const screen_id = "/facility";

  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {

  late FacilityViewModel viewmodel;

  @override
  void initState() {
    super.initState();

    Future.microtask(() =>
        Provider.of<FacilityViewModel>(context, listen: false).fetchFacilities()
    );
  }

  @override
  Widget build(BuildContext context) {
    // final viewModel =
    //     Provider.of<FacilityViewModel>(context, listen: false);
    // final List<Facility> facilities = viewModel.facilities;
    return ResponsiveLayout(
      mobileBody: body(),
      desktopBody: body(),
      currentRoute: FacilitiesScreen.screen_id,
      title: 'Facilities',
    );
  }

  Widget body() {
    return Consumer<FacilityViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if(viewModel.errorMessage.isNotEmpty){
          return Center(child: Text(viewModel.errorMessage));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            itemCount: viewModel.facilities.length,
            itemBuilder: (context, index) {
              return FacilityCard(facility: viewModel.facilities[index]);
            },
          ),
        );
      },
    );
  }
}
