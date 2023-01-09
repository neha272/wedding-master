import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedding/general/color_constants.dart';
import 'package:wedding/providers/wardrobe_provider.dart';
import 'package:wedding/screens/WardrobeScreen/wardrobe_components/wardrobe_component.dart';
import 'package:wedding/widgets/custom_sliverappbar.dart';
import 'package:wedding/widgets/loader.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({Key? key}) : super(key: key);

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0)).then((value) {
      context.read<WardrobeProvider>().getWardrobe();
    });
  }

  @override
  Widget build(BuildContext context) {
    var wardrobe = context.watch<WardrobeProvider>().wardrobes;
    return Container(
      decoration: BoxDecoration(
        gradient: greyToWhite,
      ),
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<WardrobeProvider>().getWardrobe();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CustomSliverAppBar(
                  title: "Wardrobe Planner",
                ),
                !context.watch<WardrobeProvider>().isLoaded
                    ? const SliverFillRemaining(child: Loader())
                    : context.watch<WardrobeProvider>().wardrobes.isNotEmpty?SliverFixedExtentList(
                        itemExtent: 230.0,
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return WardrobeComponent(
                            index: index,
                            wardrobe: wardrobe.elementAt(index),
                          );
                        }, childCount: wardrobe.length),
                      ):const SliverFillRemaining(child: Center(child: Text("No data found..."))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
