import 'package:flickfinder/core/utils/enum.dart';
import 'package:flickfinder/features/media/domain/usecases/getmedia.dart';
import 'package:flickfinder/features/media/presentation/bloc/states/main_media.dart';
import 'package:flickfinder/features/media/presentation/views/media_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../../../../providers/homepagestateprovider.dart';
import '../../domain/entities/media_entity.dart';
import '../bloc/media_bloc.dart';
import '../widgets/widgets.dart';

class MediaPage extends StatefulWidget {
  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final ScrollController _scrollController = ScrollController();
  final MediaBloc mediaBloc = sl<MediaBloc>();
  late HomeState homeState;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      final GetMediaParams getMediaParams = mediaBloc.state.getMediaParams;
      mediaBloc.add(GetMoreMediaEvent());
    }
  }

  void _loadMore() {
    final GetMediaParams getMediaParams = mediaBloc.state.getMediaParams;
    mediaBloc.add(GetMoreMediaEvent());
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

  List<String> _getSortTypes(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.Movies:
        return MoviesSortTypes.values.map((cat) => cat.name).toList();
      case MediaType.TvShows:
        return TvSortTypes.values.map((cat) => cat.name).toList();
      default:
        return [];
    }
  }

  final List<String> dropDownItems = ['Movies', 'TvShows'];
  @override
  Widget build(BuildContext context) {
    homeState = Provider.of<HomeState>(context);
    return Scaffold(
      appBar: AppBar(
        title: DropdownMenu<MediaType>(
          label: Text("FlickFinder"),
          initialSelection: MediaType.values.first,
          inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
          dropdownMenuEntries: MediaType.values
              .map((MediaType media) =>
                  DropdownMenuEntry<MediaType>(value: media, label: media.name))
              .toList(),
          onSelected: (value) {
            List<String> _selectedSortTypes = _getSortTypes(value!);
            homeState.currentMediaType = value;
            homeState.currentSortType = _selectedSortTypes.first;
            mediaBloc.add(GetInitialMediaEvent(GetMediaParams(
                mediaType: value, sortType: _selectedSortTypes.first)));
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border_sharp))
        ],
        bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 25),
            child: SortTypeList(
              sortTypes: _getSortTypes(homeState.currentMediaType),
              onChanged: (String value) {
                homeState.currentSortType = value;
                mediaBloc.add(GetInitialMediaEvent(GetMediaParams(
                    mediaType: homeState.currentMediaType, sortType: value)));
              },
              selectedMediaType: homeState.currentSortType,
            )),
      ),
      body: BlocProvider(
        create: (context) => mediaBloc
          ..add(GetInitialMediaEvent(GetMediaParams(
              mediaType: homeState.currentMediaType,
              sortType: homeState.currentSortType)))
          ..add(GetTrendingMediaEvent()),
        child: BlocBuilder<MediaBloc, MediaState>(
          builder: (BuildContext context, MediaState state) {
            return Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (state.mainMedia.isNotEmpty)
                      MediaGrid(
                        media: state.mainMedia,
                        onTap: (MediaEntity media) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MediaViewPage(
                                    media: media,
                                  )));
                        },
                      ),
                    if (state.mainMediaState.runtimeType != MediaLoaded)
                      (() {
                        switch (state.mainMediaState.runtimeType) {
                          case MediaInitial:
                            return const LoadingWidget(
                                message: "initializing...");
                          case MediaError:
                            return MessageDisplay(
                              message:
                                  (state.mainMediaState as MediaError).error,
                              code: (state.mainMediaState as MediaError).code,
                              onRetry: () {
                                mediaBloc.add(GetInitialMediaEvent(
                                    state.getMediaParams.copyWith(
                                        mediaType: homeState.currentMediaType,
                                        sortType: homeState.currentSortType)));
                              },
                            );
                          case MediaLoading:
                            return const LoadingWidget(message: "Loading...");
                          default:
                            return MessageDisplay(
                              message: 'Something went wrong',
                              code: 0,
                              onRetry: () {
                                mediaBloc.add(GetInitialMediaEvent(
                                    state.getMediaParams.copyWith(
                                        mediaType: homeState.currentMediaType,
                                        sortType: homeState.currentSortType)));
                              },
                            );
                        }
                      }()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
