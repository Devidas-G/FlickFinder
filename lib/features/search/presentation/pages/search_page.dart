import 'package:flickfinder/features/search/presentation/widgets/advance_search.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 36,
            child: TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  contentPadding: EdgeInsets.zero,
                  hintText: "Search",
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15)),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: TextButton(
                      style: TextButton.styleFrom(side: BorderSide.none),
                      onPressed: () {
                        print("object");
                      },
                      child: Text("Clear"))),
            ),
          ),
        ),
        body: Column(
          children: [
            AdvanceSearch(
              onClear: () {},
              onApply: () {},
            )
          ],
        ),
      ),
    );
  }
}
