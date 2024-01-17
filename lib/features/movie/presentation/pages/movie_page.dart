import 'package:cached_network_image/cached_network_image.dart';
import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/features/filter/presentation/pages/filter_options.dart';
import 'package:flickfinder/features/movie/presentation/widgets/movie_card.dart';
import 'package:flickfinder/features/movie/providers/moviesprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../bloc/movie_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  createState() => _MoviePage();
}

class _MoviePage extends State<MoviePage> {
  final ScrollController _scrollController = ScrollController();
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
        _triggerMoviesEvents();
      }
    });
  }

  void _triggerMoviesEvents() {
    if (moviesProvider.isFiltered) {
      _loadFilteredMovies(moviesProvider.moviesPage, moviesProvider.filterUrl);
    } else {
      _loadMovies(moviesProvider.moviesPage);
    }
  }

  void _loadMovies(int page) {
    if (movieBloc.isClosed) return;
    moviesProvider.isFiltered = false;
    movieBloc.add(GetMoviesEvent(page));
  }

  void _loadFilteredMovies(int page, String url) {
    if (movieBloc.isClosed) return;
    moviesProvider.filterUrl = url;
    moviesProvider.isFiltered = true;
    movieBloc.add(GetFilteredMoviesEvent(page, url));
  }

  void _resetMoviesData() {
    moviesProvider.moviesPage = 1;
    moviesProvider.moviesList = [];
  }

  @override
  Widget build(BuildContext context) {
    moviesProvider = Provider.of<MoviesProvider>(context);
    return (() {
      if (moviesProvider.moviesList.isEmpty) {
        return stateBloc(context, moviesProvider);
      } else {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: FilterOptions(
                onPressed: (url) {
                  _resetMoviesData();
                  _loadFilteredMovies(moviesProvider.moviesPage, url);
                },
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                controller: _scrollController,
                child: ListView(controller: _scrollController, children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          3, // Adjust the number of columns as needed
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: moviesProvider.moviesList.length,
                    itemBuilder: (context, index) {
                      final movie = moviesProvider.moviesList[index];
                      return MovieCard(movie: movie);
                    },
                  ),
                  stateBloc(context, moviesProvider)
                ]),
              ),
            ),
          ],
        );
      }
    }());
  }
}

BlocProvider<MovieBloc> stateBloc(
    BuildContext context, MoviesProvider moviesProvider) {
  MovieBloc movieBloc = sl<MovieBloc>();
  return BlocProvider(
    create: (context) => movieBloc,
    child: Center(
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (BuildContext context, MovieState state) {
          if (state is MovieInitial) {
            print("initial");
            movieBloc.add(GetMoviesEvent(moviesProvider.moviesPage));
            return const LoadingWidget(
              message: "Initializing",
            );
          } else if (state is MovieLoading) {
            return const LoadingWidget(
              message: "Loading",
            );
          } else if (state is MovieLoaded) {
            Future.delayed(Duration.zero, () {
              moviesProvider.addAllMovies(state.movies);
            });
            return const Icon(Icons.tv);
          } else if (state is MovieError) {
            return MessageDisplay(
              message: state.message,
              code: state.code,
            );
          } else {
            return const MessageDisplay(
              message: "something went wrong",
              code: 0,
            );
          }
        },
      ),
    ),
  );
}
