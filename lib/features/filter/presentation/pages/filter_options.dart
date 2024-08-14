import 'package:auto_size_text/auto_size_text.dart';
import 'package:flickfinder/features/filter/presentation/bloc/filter_bloc.dart';
import 'package:flickfinder/features/filter/presentation/widgets/filter_list.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enum.dart';
import '../../../../injection_container.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class FilterOptions extends StatefulWidget {
  final Function(GetMediaParams) onApply;
  final Function() onClear;
  final Function(GetMediaParams) onMediaTypeChange;
  const FilterOptions({
    super.key,
    required this.onApply,
    required this.onMediaTypeChange,
    required this.onClear,
  });
  @override
  createState() => _FilterOptions();
}

class _FilterOptions extends State<FilterOptions> {
  MediaType selectedOption = MediaType.values.first;
  Enum selectedDropOption = MoviesList.values.first;
  List<Enum> dropdownValues = MoviesList.values;
  late FilterBloc filterBloc;
  GetMediaParams getFilteredMediaParams =
      GetMediaParams(mediaType: MediaType.Movies, category: '');
  @override
  void initState() {
    super.initState();
    filterBloc = sl<FilterBloc>();
  }

  void setDropdownValues(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.Movies:
        setState(() {
          dropdownValues = MoviesList.values;
          selectedDropOption = MoviesList.values.first;
        });
      case MediaType.TvShows:
        setState(() {
          dropdownValues = TvList.values;
          selectedDropOption = TvList.values.first;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<Enum>(
                value: selectedDropOption,
                onChanged: (newValue) {
                  setState(() {
                    selectedDropOption = newValue!;
                  });
                  widget.onApply(filterBloc.state.tempFilterParams
                      .copyWith(category: newValue.toString()));
                },
                items: dropdownValues.map((Enum? item) {
                  return DropdownMenuItem<Enum>(
                    value: item,
                    child: Text(item.toString().split('.').last),
                  );
                }).toList(),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
              //     BlocProvider(
              //       create: (_) => filterBloc..add(GetFilterOption(filterBloc)),
              //       child: FilterList(
              //         onApply: () {
              //           filterBloc.add(GetFilterOption(filterBloc));
              //           widget.onApply(filterBloc.state.tempFilterParams);
              //         },
              //         onClear: () {
              //           widget.onClear();
              //           filterBloc.add(UpdateFilterparmas(
              //               newFilterParams: getFilteredMediaParams));
              //           filterBloc.add(GetFilterOption(filterBloc));
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: MediaType.values.length,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                MediaType mediaType = MediaType.values[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        selectedOption = mediaType;
                      });
                      setDropdownValues(mediaType);
                      widget.onMediaTypeChange(GetMediaParams(
                          mediaType: mediaType,
                          category: selectedDropOption.toString()));
                      filterBloc.add(UpdateMediaType(mediaType: mediaType));
                      filterBloc.add(UpdateFilterparmas(
                          newFilterParams: getFilteredMediaParams));
                      filterBloc.add(GetFilterOption(filterBloc));
                    },
                    child: Text(mediaType.name),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(5),
                      backgroundColor: selectedOption == mediaType
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.grey.shade800)),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
