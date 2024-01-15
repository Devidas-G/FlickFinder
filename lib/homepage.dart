import 'package:flickfinder/core/common/homepagestateprovider.dart';
import 'package:flickfinder/features/movie/presentation/pages/movie_page.dart';
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
      appBar: AppBar(),
      drawer: Drawer(),
      body: PageView(
        controller: _pageViewController,
        children: [
          Container(
            child: Center(child: Text("TV Shows")),
          ),
          MoviePage(),
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
            label: 'TV Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_sharp),
            label: 'Movies',
          ),
        ],
      ),
    );
  }
}
