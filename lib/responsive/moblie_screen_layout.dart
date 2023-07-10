import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:instagram/screens/test_screen.dart";
import "package:instagram/utils/colors.dart";
import "package:instagram/utils/global_variables.dart";
import "package:provider/provider.dart";

import "../providers/user_provider.dart";
import "../screens/add_post_screen.dart";
import "../screens/feed_screen.dart";
import "../screens/guest_profile.dart";
import "../screens/profile_screen.dart";

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigationTapped(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(user!.userName);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        body: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              FeedScreen(),
              AddPostScreen(),
              userProvider.getUser != null
                  ? 
                  ProfileScreen(uid: userProvider.getUser!.uid)
                  // testScreen()
                  : guestProfile(),
            ]),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: _page == 0 ? primaryColor : secondaryColor),
                label: "Home",
                backgroundColor: primaryColor),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.search,
            //       color: _page == 1 ? primaryColor : secondaryColor,
            //     ),
            //     label: "Search",
            //     backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    color: _page == 1 ? primaryColor : secondaryColor),
                label: "Add Post",
                backgroundColor: primaryColor),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.favorite,
            //         color: _page == 3 ? primaryColor : secondaryColor),
            //     label: "Favourites",
            //     backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: _page == 2 ? primaryColor : secondaryColor),
                label: "Profile",
                backgroundColor: primaryColor),
          ],
          onTap: navigationTapped,
        ));
  }
}
