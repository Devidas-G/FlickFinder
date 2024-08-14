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
  MediaType selectedMediaType = MediaType.values.first;
  late String initialCategory;
  @override
  void initState() {
    super.initState();
    List<String> _initCats = _getCategories(selectedMediaType);
    initialCategory = _initCats.first;
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

  List<String> _getCategories(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.Movies:
        return MoviesList.values.map((cat) => cat.name).toList();
      case MediaType.TvShows:
        return TvList.values.map((cat) => cat.name).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CategoryDropdown(
          categories: _getCategories(selectedMediaType),
          onChanged: (String? value) {
            setState(() {
              initialCategory = value!;
            });
            mediaBloc.add(GetMediaWithParamsEvent(
                GetMediaParams(mediaType: selectedMediaType, category: value)));
          },
          selectedCategory: initialCategory,
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: MediaTypeList(
              mediaType: MediaType.values,
              onChanged: (MediaType value) {
                List<String> _initCats = _getCategories(value);
                setState(() {
                  selectedMediaType = value;
                  initialCategory = _initCats.first;
                });
                mediaBloc.add(GetMediaWithParamsEvent(GetMediaParams(
                    mediaType: selectedMediaType, category: _initCats.first)));
              },
              selectedMediaType: selectedMediaType,
            )),
      ),
      body: BlocProvider(
        create: (context) => mediaBloc
          ..add(GetMediaWithParamsEvent(GetMediaParams(
              mediaType: selectedMediaType, category: initialCategory))),
        child: BlocBuilder<MediaBloc, MediaState>(
          builder: (BuildContext context, MediaState state) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              children: [
                if (state.media.isNotEmpty)
                  MediaGrid(
                    media: state.media,
                    onTap: (MediaEntity value) {},
                  ),
                if (state.status != BS.loaded)
                  (() {
                    switch (state.status) {
                      case BS.initial:
                        return const LoadingWidget(message: "initializing...");
                      case BS.error:
                        return MessageDisplay(
                          message: state.message,
                          code: state.statusCode,
                          onRetry: () {
                            mediaBloc.add(GetMediaWithParamsEvent(
                                state.getFilteredMediaParams.copyWith(
                                    mediaType: selectedMediaType,
                                    category: initialCategory)));
                          },
                        );
                      case BS.loadingMore:
                        return const LoadingWidget(message: "Loading...");
                      default:
                        return MessageDisplay(
                          message: 'Something went wrong',
                          code: 0,
                          onRetry: () {
                            mediaBloc.add(GetMediaWithParamsEvent(
                                state.getFilteredMediaParams.copyWith(
                                    mediaType: selectedMediaType,
                                    category: initialCategory)));
                          },
                        );
                    }
                  }()),
              ],
            );
          },
        ),
      ),
    );
  }
}
