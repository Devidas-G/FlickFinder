import 'package:flutter/material.dart';

import '../features/movie/presentation/pages/movie_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("FlickFinder"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          bottom: TabBar(tabs: [
            Tab(
              text: "Movies",
            ),
            Tab(
              text: "Tv Shows",
            ),
          ]),
        ),
        body: TabBarView(children: [
          MoviePage(),
          Container(),
        ]),
      ),
    );
  }
}
