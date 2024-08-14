import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/media_entity.dart';
import '../bloc/media_bloc.dart';
import '../widgets/widgets.dart';

typedef BS = MediaStatus;

class MediaPage extends StatefulWidget {
  MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final ScrollController _scrollController = ScrollController();

  final MediaBloc mediaBloc = sl<MediaBloc>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      final GetMediaParams getFilteredMediaParams =
          mediaBloc.state.getFilteredMediaParams;
      mediaBloc.add(GetMoreMediaEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CategoryDropdown(categories: [], onChanged: (String? value) {}),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: MediaTypeList(
                mediaType: MediaType.values
                    .map((type) => type.toString().split('.').last)
                    .toList(),
                onChanged: (String? value) {})),
      ),
      body: BlocProvider(
        create: (context) => mediaBloc
          ..add(const GetMediaWithParamsEvent(GetMediaParams(
              mediaType: MediaType.Movies, category: 'now_playing'))),
        child: BlocBuilder<MediaBloc, MediaState>(
          builder: (BuildContext context, MediaState state) {
            switch (state.status) {
              case BS.initial:
                return const LoadingWidget(message: "initializing...");
              case BS.error:
                return MessageDisplay(
                    message: state.message, code: state.statusCode);
              case BS.loaded || BS.loadingMore:
                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    MediaGrid(
                      media: state.media,
                      onTap: (MediaEntity value) {},
                      scrollController: _scrollController,
                    ),
                    if (state.status == BS.loadingMore)
                      const LoadingWidget(message: "Loading...")
                  ],
                );
              default:
                return const MessageDisplay(
                  message: 'Something went wrong',
                  code: 0,
                );
            }
          },
        ),
      ),
    );
  }
}
