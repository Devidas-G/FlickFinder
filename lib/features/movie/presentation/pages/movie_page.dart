import 'package:cached_network_image/cached_network_image.dart';
import 'package:flickfinder/core/common/api_config.dart';
import 'package:flickfinder/features/movie/providers/moviesprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../bloc/movie_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class MoviePage extends StatefulWidget {
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
    // Add a listener to the scroll controller
    _scrollController.addListener(() {
      // Check if the user has scrolled to the end of the list
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Trigger your function when reaching the end
        _loadMovies(moviesProvider.moviesPage);
      }
    });
  }

  void _loadMovies(int page) {
    if (movieBloc.isClosed) return;
    movieBloc.add(GetMoviesEvent(28, page));
  }

  @override
  Widget build(BuildContext context) {
    moviesProvider = Provider.of<MoviesProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (() {
          if (moviesProvider.moviesList.isEmpty) {
            return buildBody(context, moviesProvider);
          } else {
            return Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                controller: _scrollController,
                child: ListView(controller: _scrollController, children: [
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                      return Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                // Replace 'imagePath' with the actual property name for the image URL
                                imageUrl: ApiConfig.imgHost + movie.posterPath,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                movie.title,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildBody(context, moviesProvider)
                ]),
              ),
            );
          }
        }()),
      ],
    );
  }
}

BlocProvider<MovieBloc> buildBody(
    BuildContext context, MoviesProvider moviesProvider) {
  MovieBloc movieBloc = sl<MovieBloc>();
  return BlocProvider(
    create: (context) => movieBloc,
    child: Center(
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (BuildContext context, MovieState state) {
          if (state is MovieInitial) {
            movieBloc.add(GetMoviesEvent(28, moviesProvider.moviesPage));
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
            return Icon(Icons.tv);
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
