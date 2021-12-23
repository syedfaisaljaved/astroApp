import 'package:astro_app/screens/daily_panchang_screen.dart';
import 'package:astro_app/screens/talk_to_astro_screen.dart';
import 'package:astro_app/utils/img_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  List<NavBarItem> bottomNavBarList = [
    NavBarItem(title: "Home", image: home),
    NavBarItem(title: "Talk to Astrologer", image: talk),
    NavBarItem(title: "Ask Question", image: ask),
    NavBarItem(title: "Reports", image: report),
  ];

  List<Widget> _screens = [DailyPanchangScreen(), TalkToAstroScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leadingWidth: 50,
        leading: IconButton(
          splashRadius: 20,
          icon: Image.asset(
            hamburger,
            width: 20,
            height: 20,
          ),
          onPressed: () {},
          padding: EdgeInsets.zero,
        ),
        title: Image.asset(
          logo,
          width: 40,
          height: 40,
        ),
        actions: [
          IconButton(
            iconSize: 24,
            splashRadius: 20,
            icon: Image.asset(
              profile,
              width: 24,
              height: 24,
            ),
            onPressed: () {},
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      body: _screens[_isSelectedItem],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        onTap: (index){
          if(index > 1)
            return Fluttertoast.showToast(msg: "Coming Soon");
          setState(() {
            _isSelectedItem = index;
          });
        },
        currentIndex: _isSelectedItem,
        selectedLabelStyle: TextStyle(
          height: 1.5,
            fontSize: 9, color: Colors.orange),
        unselectedLabelStyle: TextStyle(
          height: 1.5,
            fontSize: 9, color: Colors.grey),
        selectedFontSize: 9,
        unselectedFontSize: 9,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.orange,
        items: List.generate(bottomNavBarList.length,
            (index) => navBarItem(bottomNavBarList[index])),
      ),
    );
  }

  int _isSelectedItem = 0;

  BottomNavigationBarItem navBarItem(NavBarItem navBarItem) =>
      BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Image.asset(
            navBarItem.image,
            color: Colors.grey,
            height: 20,
          ),
          label: navBarItem.title,
          activeIcon: Image.asset(
            navBarItem.image,
            color: Colors.orange,
            height: 20,
          ));
}

class NavBarItem {
  String title;
  String image;

  NavBarItem({this.title, this.image});
}
