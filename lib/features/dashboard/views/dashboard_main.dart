import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unidwell_finder/features/dashboard/provider/main_provider.dart';
import 'package:unidwell_finder/features/dashboard/views/components/side_bar.dart';
import 'package:unidwell_finder/generated/assets.dart';
import 'package:unidwell_finder/utils/colors.dart';
import 'package:unidwell_finder/utils/styles.dart';
import '../../../config/routes/router.dart';
import '../../../config/routes/router_item.dart';
import '../../../core/views/custom_dialog.dart';
import '../../auth/providers/user_provider.dart';
import '../../main/components/app_bar_item.dart';

class DashBoardMainPage extends ConsumerWidget {
  const DashBoardMainPage(this.child, {super.key});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    var user = ref.watch(userProvider);
    var studentsStream = ref.watch(adminStudentsStreamProvider);
    var managersStream = ref.watch(adminManagersStream);
    var roomsStream = ref.watch(adminRoomsStreamProvider);
    var hostelsStream = ref.watch(adminHostelsStreamProvider);
    var bookingsStream = ref.watch(adminBookingsStreamProvider);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications, color: Colors.white),
              ),
              const SizedBox(width: 10),
              PopupMenuButton(
                  color: primaryColor,
                  offset: const Offset(0, 70),
                  child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    backgroundImage: () {
                      var user = ref.watch(userProvider);
                      if (user.image == null) {
                        return AssetImage(
                          user.gender == 'Male'
                              ? Assets.imagesMale
                              : user.role == 'Admin'
                                  ? Assets.imagesAdmin
                                  : Assets.imagesFemale,
                        );
                      } else {
                        NetworkImage(user.image!);
                      }
                    }(),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: BarItem(
                            padding: const EdgeInsets.only(
                                right: 40, top: 10, bottom: 10, left: 10),
                            icon: Icons.home,
                            title: 'Home Page',
                            onTap: () {
                              MyRouter(context: context, ref: ref)
                                  .navigateToRoute(RouterItem.homeRoute);
                              Navigator.of(context).pop();
                            }),
                      ),
                      PopupMenuItem(
                        child: BarItem(
                            padding: const EdgeInsets.only(
                                right: 40, top: 10, bottom: 10, left: 10),
                            icon: Icons.logout,
                            title: 'Logout',
                            onTap: () {
                              CustomDialogs.showDialog(
                                message: 'Are you sure you want to logout?',
                                type: DialogType.info,
                                secondBtnText: 'Logout',
                                onConfirm: () {
                                  ref
                                      .read(userProvider.notifier)
                                      .logout(context: context);
                                  Navigator.of(context).pop();
                                },
                              );
                            }),
                      ),
                    ];
                  }),
              const SizedBox(width: 10),
            ],
            title: Row(
              children: [
                Image.asset(
                  Assets.imagesHostelLogoT,
                  height: 40,
                ),
                const SizedBox(width: 10),
                if (styles.smallerThanTablet)
                  //manu button
                  if (user.role.toLowerCase() == 'admin')
                    buildAdminManu(ref, context)
                  else if (user.role.toLowerCase() == 'manager')
                    buildManagerManu(ref, context)
                  else if (user.role.toLowerCase() == 'student')
                    buildStudentManu(ref, context)
              ],
            ),
          ),
          body: Container(
            color: Colors.white60,
            padding: const EdgeInsets.all(4),
            child: styles.smallerThanTablet
                ? child
                : Row(
                    children: [
                      const SideBar(),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Container(
                              color: Colors.grey[100],
                              padding: const EdgeInsets.all(10),
                              child: hostelsStream.when(
                                  data: (hostels) {
                                    return bookingsStream.when(
                                        data: (bookings) {
                                          return roomsStream.when(
                                              data: (rooms) {
                                                return studentsStream.when(
                                                    data: (students) {
                                                      return managersStream.when(
                                                          data: (managers) {
                                                            return child;
                                                          },
                                                          error: (error, stack) {
                                                            return Center(
                                                                child: Text(error
                                                                    .toString()));
                                                          },
                                                          loading: () => const Center(
                                                              child:
                                                                  CircularProgressIndicator()));
                                                    },
                                                    error: (error, stack) {
                                                      return Center(
                                                          child: Text(
                                                              error.toString()));
                                                    },
                                                    loading: () => const Center(
                                                        child:
                                                            CircularProgressIndicator()));
                                              },
                                              error: (error, stack) {
                                                return Center(
                                                    child:
                                                        Text(error.toString()));
                                              },
                                              loading: () => const Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                        },
                                        error: (error, stack) {
                                          return Center(
                                              child: Text(error.toString()));
                                        },
                                        loading: () => const Center(
                                            child: CircularProgressIndicator()));
                                  },
                                  error: (error, stack) {
                                    return Center(child: Text(error.toString()));
                                  },
                                  loading: () => const Center(
                                      child: CircularProgressIndicator())))),
                    ],
                  ),
          )),
    );
  }

  Widget buildAdminManu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
      color: primaryColor,
      offset: const Offset(0, 70),
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.dashboard,
                title: 'Dashboard',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.dashboardRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.admin_panel_settings,
                title: 'Managers',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.landloardsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.home,
                title: 'Hostels',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.hostelsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.people,
                title: 'Students',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.studentsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.room,
                title: 'Rooms',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.roomsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.calendar_today,
                title: 'Bookings',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.bookingsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          //institutions
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.school,
                title: 'Institutions',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.institutionsRoute);
                  Navigator.of(context).pop();
                }),
          ),
          // complainst
          PopupMenuItem(
            child: BarItem(
                padding: const EdgeInsets.only(
                    right: 40, top: 10, bottom: 10, left: 10),
                icon: Icons.report,
                title: 'Complaints',
                onTap: () {
                  MyRouter(context: context, ref: ref)
                      .navigateToRoute(RouterItem.complaintsRoute);
                  Navigator.of(context).pop();
                }),
          ),
        ];
      },
    );
  }

  Widget buildManagerManu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
        color: primaryColor,
        offset: const Offset(0, 70),
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.home,
                  title: 'Hostels',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.hostelsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.room,
                  title: 'Rooms',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.roomsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.calendar_today,
                  title: 'Bookings',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.bookingsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            // complainst
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.report,
                  title: 'Complaints',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.complaintsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.profileRoute);
                    Navigator.of(context).pop();
                  }),
            ),
          ];
        });
  }

  Widget buildStudentManu(WidgetRef ref, BuildContext context) {
    return PopupMenuButton(
        color: primaryColor,
        offset: const Offset(0, 70),
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.home,
                  title: 'My Hostel',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.hostelsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.room,
                  title: 'My Rooms',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.roomsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.calendar_today,
                  title: 'My Bookings',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.bookingsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            // complainst
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.report,
                  title: 'Complaints',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.complaintsRoute);
                    Navigator.of(context).pop();
                  }),
            ),
            PopupMenuItem(
              child: BarItem(
                  padding: const EdgeInsets.only(
                      right: 40, top: 10, bottom: 10, left: 10),
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.profileRoute);
                    Navigator.of(context).pop();
                  }),
            ),
          ];
        });
  }
}
