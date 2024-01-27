import 'package:flickfinder/features/explore/presentation/pages/media_builder.dart';
import 'package:flickfinder/features/filter/presentation/pages/filter_options.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';
import 'package:flickfinder/features/explore/presentation/widgets/media_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../core/utils/enum.dart';
import '../injection_container.dart';
import '../features/explore/presentation/bloc/media_bloc.dart';
import '../features/explore/presentation/widgets/loading_widget.dart';
import '../features/explore/presentation/widgets/message_display.dart';

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
