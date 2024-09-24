import 'package:flickfinder/features/media/media.dart';
import 'package:flickfinder/features/search/presentation/pages/search_page.dart';
import 'package:flickfinder/providers/homepagestateprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/enum.dart';
import '../injection_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late HomeState homeState;
  final PageController _pageViewController = PageController();
  final List<Widget> pageViewChilderns = [];
  final List<Map<String, dynamic>> bottomAppBarItems = [
    {"icon": Icons.home, "label": "Home"},
    {"icon": Icons.search, "label": "Search"},
    {"icon": Icons.trending_up_sharp, "label": "Trending"},
    {"icon": Icons.account_circle_sharp, "label": "Account"},
  ];

  @override
  Widget build(BuildContext context) {
    homeState = Provider.of<HomeState>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageViewController,
        children: [
          MediaPage(),
          SearchPage(),
          Container(
            child: Center(child: Text("Trending")),
          ),
          Container(
            child: Center(child: Text("Account")),
          )
        ],
        onPageChanged: (index) {
          homeState.currentindex = index;
        },
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: bottomAppBarItems.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> item = entry.value;
            return IconButton(
              onPressed: () {
                _pageViewController.animateToPage(index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceOut);
              },
              color: homeState.currentindex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              icon: Icon(item["icon"]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
