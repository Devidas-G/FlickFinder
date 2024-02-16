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
  final Function(GetFilteredMediaParams) onApply;
  final Function() onClear;
  final Function(MediaType?) onMediaTypeChange;
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
  MediaType selectedDropOption = MediaType.values.first;
  late FilterBloc filterBloc;
  GetFilteredMediaParams getFilteredMediaParams = GetFilteredMediaParams();
  @override
  void initState() {
    super.initState();
    filterBloc = sl<FilterBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<MediaType>(
            value: selectedDropOption,
            onChanged: (MediaType? newValue) {
              setState(() {
                selectedDropOption = newValue!;
              });
              filterBloc.add(UpdateMediaType(mediaType: newValue!));
              filterBloc
                  .add(GetFilterOption(getFilteredMediaParams, filterBloc));
              widget.onMediaTypeChange(newValue);
            },
            items: MediaType.values.map((MediaType item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item.name),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
              BlocProvider(
                create: (_) => filterBloc
                  ..add(GetFilterOption(getFilteredMediaParams, filterBloc)),
                child: FilterList(
                  onApply: () =>
                      widget.onApply(filterBloc.state.newFilterParams),
                  onClear: () {
                    widget.onClear();
                    filterBloc.add(
                        GetFilterOption(getFilteredMediaParams, filterBloc));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
