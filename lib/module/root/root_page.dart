// ignore_for_file: use_build_context_synchronously, always_specify_types

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:lacak_by_sasat/module/root/root_bloc.dart";
import "package:lacak_by_sasat/module/root/root_state.dart";
import "package:smooth_corner/smooth_corner.dart";

class RootPage extends StatefulWidget {
  final StatefulNavigationShell statefulNavigationShell;

  const RootPage({
    required this.statefulNavigationShell,
    super.key,
  });

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RootBloc, RootState>(
      listener: (context, state) async {},
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.surfaceContainerLowest(),
          systemNavigationBarIconBrightness: AppColors.brightnessInverse(),
        ),
        child: Scaffold(
          body: widget.statefulNavigationShell,
          bottomNavigationBar: bottomNavigationBar(),
        ),
      ),
    );
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  Widget bottomNavigationBar() {
    return Container(
      height: Dimensions.size60,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.outline(),
          ),
        ),
        color: AppColors.surfaceContainerLowest(),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: AppColors.surfaceContainerLowest(),
              child: Opacity(
                opacity:
                    widget.statefulNavigationShell.currentIndex == 0 ? 1 : 0.7,
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.size10,
                    horizontal: Dimensions.size10,
                  ),
                  child: InkWell(
                    onTap: () {
                      widget.statefulNavigationShell.goBranch(0);
                    },
                    customBorder: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.size10),
                      smoothness: 1,
                    ),
                    child: Ink(
                      height: double.infinity,
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.statefulNavigationShell.currentIndex == 0
                                ? Icons.home
                                : Icons.home_outlined,
                            size: Dimensions.size25,
                          ),
                          SizedBox(width: Dimensions.size5),
                          Text(
                            "home".tr(),
                            style: TextStyle(
                              fontSize: Dimensions.text14,
                              fontWeight:
                                  widget.statefulNavigationShell.currentIndex ==
                                          0
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Material(
            child: InkWell(
              onTap: () async {
                await showMenu();
              },
              customBorder: SmoothRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.size15),
                smoothness: 1,
              ),
              child: Ink(
                width: Dimensions.size60,
                height: Dimensions.size60,
                decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.size15),
                    smoothness: 1,
                  ),
                  color: AppColors.onSurface(),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.apps,
                    color: AppColors.surfaceContainerLowest(),
                    size: Dimensions.size35,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: AppColors.surfaceContainerLowest(),
              child: Opacity(
                opacity:
                    widget.statefulNavigationShell.currentIndex == 1 ? 1 : 0.7,
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.size10,
                    horizontal: Dimensions.size10,
                  ),
                  child: InkWell(
                    onTap: () {
                      widget.statefulNavigationShell.goBranch(1);
                    },
                    customBorder: SmoothRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.size10),
                      smoothness: 1,
                    ),
                    child: Ink(
                      height: double.infinity,
                      decoration: ShapeDecoration(
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.statefulNavigationShell.currentIndex == 1
                                ? Icons.message
                                : Icons.message_outlined,
                            size: Dimensions.size25,
                          ),
                          SizedBox(width: Dimensions.size5),
                          Text(
                            "social".tr(),
                            style: TextStyle(
                              fontSize: Dimensions.text14,
                              fontWeight:
                                  widget.statefulNavigationShell.currentIndex ==
                                          1
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showMenu() async {
    Widget item({
      required String label,
      required IconData icon,
      required GestureTapCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        customBorder: SmoothRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.size15),
          smoothness: 1,
        ),
        child: Ink(
          width: (Dimensions.screenWidth - 70) / 4,
          height: Dimensions.size100,
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.size15),
              smoothness: 1,
              side: BorderSide(
                color: AppColors.outline(),
              ),
            ),
            color: AppColors.surfaceBright(),
          ),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.size10,
            horizontal: Dimensions.size5,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: Dimensions.size35,
                ),
                SizedBox(height: Dimensions.size5),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.onSurface(),
                    fontSize: Dimensions.text11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return await showModalBottomSheet(
      context: context,
      shape: SmoothRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.size20),
          topRight: Radius.circular(Dimensions.size20),
        ),
        smoothness: 1,
        side: BorderSide(color: AppColors.outline()),
      ),
      barrierColor: Colors.black12,
      backgroundColor: AppColors.surfaceContainerLowest(),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.drag_handle,
                color: AppColors.outlineVariant(),
                size: Dimensions.size30,
              ),
              Container(
                padding: EdgeInsets.all(Dimensions.size20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "menu".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.onSurface(),
                        fontSize: Dimensions.text20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimensions.size10),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: Dimensions.size10,
                      runSpacing: Dimensions.size10,
                      children: [
                        item(
                          label: "facility".tr(),
                          icon: Icons.sports_tennis_outlined,
                          onTap: () {},
                        ),
                        item(
                          label: "form".tr(),
                          icon: Icons.assignment_outlined,
                          onTap: () {},
                        ),
                        item(
                          label: "ticket".tr(),
                          icon: Icons.feedback_outlined,
                          onTap: () async {
                            await context.push("/tickets");
                          },
                        ),
                        item(
                          label: "parcel".tr(),
                          icon: Icons.shopping_bag_outlined,
                          onTap: () async {
                            await context.push("/parcel");
                          },
                        ),
                        item(
                          label: "announcement".tr(),
                          icon: Icons.notification_important_outlined,
                          onTap: () async {
                            await context.push("/announcement");
                          },
                        ),
                        item(
                          label: "event".tr(),
                          icon: Icons.event_outlined,
                          onTap: () async {
                            await context.push("/events");
                          },
                        ),
                        item(
                          label: "document".tr(),
                          icon: Icons.file_copy_outlined,
                          onTap: () async {
                            await context.push("/documents");
                          },
                        ),
                        item(
                          label: "billing".tr(),
                          icon: Icons.receipt_long_outlined,
                          onTap: () async {
                            await context.push("/billing");
                          },
                        ),
                        item(
                          label: "contact".tr(),
                          icon: Icons.contacts_outlined,
                          onTap: () async {
                            await context.push("/emergency");
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
