import 'package:flickfinder/core/common/homepagestateprovider.dart';
import 'package:flickfinder/features/explore/presentation/pages/explore_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late HomeState homeState;
  final PageController _pageViewController = PageController();

  @override
  Widget build(BuildContext context) {
    homeState = Provider.of<HomeState>(context);
    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        children: [
          ExplorePage(),
          Container(
            child: Center(child: Text("Account")),
          ),
        ],
        onPageChanged: (index) {
          homeState.pageindex = index;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeState.pageindex,
        onTap: (index) {
          _pageViewController.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.bounceOut);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
