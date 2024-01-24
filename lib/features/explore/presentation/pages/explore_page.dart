import 'package:flickfinder/features/filter/presentation/pages/filter_options.dart';
import 'package:flickfinder/features/explore/domain/entities/media_entity.dart';
import 'package:flickfinder/features/explore/presentation/widgets/movie_card.dart';
import 'package:flickfinder/features/explore/providers/mediaprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enum.dart';
import '../../../../injection_container.dart';
import '../bloc/movie_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  final ScrollController _scrollController = ScrollController();
  final PagingController<int, MediaEntity> _pagingController =
      PagingController(firstPageKey: 0);
  late MovieBloc movieBloc;
  late MoviesProvider moviesProvider;
  @override
  void initState() {
    super.initState();
    movieBloc = sl<MovieBloc>();
    _scrollController.addListener(() {
      // Check if the user has scrolled to the end of the list
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Trigger your function when reaching the end
        movieBloc.add(GetMediaEvent(
            movieBloc.state.currentPage, movieBloc.state.mediaType));
      }
    });
  }

  _triggerEvent(MediaType mediaType, int page) {
    movieBloc.add(GetMediaEvent(page, mediaType));
  }

  @override
  Widget build(BuildContext context) {
    moviesProvider = Provider.of<MoviesProvider>(context);
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
              print(newMediaType);
              _triggerEvent(newMediaType!, 0);
              _pagingController.refresh();
            },
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => movieBloc
          ..add(GetMediaEvent(
              movieBloc.state.currentPage, movieBloc.state.mediaType)),
        child: Center(
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (BuildContext context, MovieState state) {
              if (state.status == MovieStatus.initial) {
                return const LoadingWidget(
                  message: "Initializing",
                );
              } else {
                _pagingController.appendPage(state.movies, state.currentPage);
                return PagedGridView<int, MediaEntity>(
                  showNewPageProgressIndicatorAsGridChild: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing:
                          1, // Adjust spacing between grid items horizontally
                      mainAxisSpacing: 1,
                      childAspectRatio: 0.6),
                  builderDelegate: PagedChildBuilderDelegate<MediaEntity>(
                    itemBuilder: (context, movie, index) {
                      return MediaCard(movie: movie);
                    },
                    noItemsFoundIndicatorBuilder: (context) {
                      return const LoadingWidget(
                        message: "Loading",
                      );
                    },
                    newPageProgressIndicatorBuilder: (context) {
                      switch (state.status) {
                        case MovieStatus.loading:
                          return const LoadingWidget(
                            message: "Loading",
                          );
                        case MovieStatus.error:
                          return MessageDisplay(
                            message: state.message,
                            code: state.statusCode,
                          );
                        case MovieStatus.loaded:
                          if (state.movies.isEmpty) {
                            return const Center(child: Text('no more Movies'));
                          } else {
                            return Icon(Icons.tv);
                          }
                        default:
                          return const MessageDisplay(
                            message: "something went wrong",
                            code: 0,
                          );
                      }
                    },
                  ),
                  pagingController: _pagingController,
                  scrollController: _scrollController,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
