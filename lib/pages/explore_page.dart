import 'package:flickfinder/features/media/presentation/pages/media_builder.dart';
import 'package:flickfinder/features/filter/presentation/pages/filter_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/utils/enum.dart';
import '../injection_container.dart';
import '../features/media/presentation/bloc/media_bloc.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  late MediaBloc mediaBloc;
  @override
  void initState() {
    super.initState();
    mediaBloc = sl<MediaBloc>();
  }

  _triggerEvent(MediaType mediaType) {
    mediaBloc.add(GetMediaEvent(mediaType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlickFinder"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: FilterOptions(
            onApply: (url) {
              print(url);
            },
            onMediaTypeChange: (MediaType? newMediaType) {
              _triggerEvent(newMediaType!);
            },
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            mediaBloc..add(GetMediaEvent(mediaBloc.state.mediaType)),
        child: MediaBuilder(),
      ),
    );
  }
}
