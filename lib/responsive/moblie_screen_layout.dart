import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:instagram/utils/colors.dart";
import "package:instagram/utils/global_variables.dart";

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
  void onPageChanged (int page){
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
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: homeScreenItems,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color: _page == 0 ? primaryColor : secondaryColor),
                label: "Home",
                
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor,
                ),
                label: "Search",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle,
                    color: _page == 2 ? primaryColor : secondaryColor),
                label: "Add Post",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite,
                    color: _page == 3 ? primaryColor : secondaryColor),
                label: "Favourites",
                backgroundColor: primaryColor),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color: _page == 4 ? primaryColor : secondaryColor),
                label: "Profile",
                backgroundColor: primaryColor),
          ],
          onTap: navigationTapped,
        ));
  }
}
