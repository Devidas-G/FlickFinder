import 'package:auto_size_text/auto_size_text.dart';
import 'package:flickfinder/features/filter/presentation/bloc/filter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enum.dart';
import '../../../../injection_container.dart';
import '../widgets/loading_widget.dart';

class FilterOptions extends StatefulWidget {
  final Function(String) onApply;
  final Function(MediaType?) onMediaTypeChange;

  const FilterOptions(
      {super.key, required this.onApply, required this.onMediaTypeChange});
  @override
  createState() => _FilterOptions();
}

class _FilterOptions extends State<FilterOptions> {
  MediaType selectedDropOption = MediaType.values.first;
  FilterParameters _selectedParameters = FilterParameters.values.first;
  late FilterBloc filterBloc;
  @override
  void initState() {
    super.initState();
    filterBloc = sl<FilterBloc>();
  }

  void _triggerEvent(FilterParameters filterParameters) {
    filterBloc.add(GetFilterOptions(filterParameters));
  }

  void showFilterBottomSheet(
      BuildContext builderContext, Function(String) onApply) {
    showDialog<void>(
      context: builderContext,
      // isScrollControlled: true,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     topRight: Radius.circular(20),
      //     topLeft: Radius.circular(20),
      //   ),
      // ),
      builder: (_) {
        return Dialog(child: _buildFilterBottomSheet(builderContext, onApply));
      },
    );
  }

  Widget _buildFilterBottomSheet(
      BuildContext builderContext, Function(String) onApply) {
    return StatefulBuilder(
      builder: (_, void Function(void Function()) setState) {
        return SizedBox(
          height: MediaQuery.of(builderContext).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _filterHeader(builderContext, setState),
              Expanded(
                child: _filterSides(builderContext, setState),
              ),
              _buildFilterActions(builderContext, onApply),
            ],
          ),
        );
      },
    );
  }

  Widget _filterHeader(
      BuildContext context, void Function(void Function()) setState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _filterSides(
      BuildContext builderContext, void Function(void Function()) setState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: _buildFilterParametersList(builderContext, setState),
        ),
        Expanded(
          flex: 7,
          child: buildBody(builderContext, filterBloc),
        ),
      ],
    );
  }

  Widget _buildFilterParametersList(
      BuildContext context, void Function(void Function()) setState) {
    return ListView(
      children: FilterParameters.values.map((parameter) {
        return ListTile(
          selected: _selectedParameters == parameter,
          selectedTileColor: Colors.grey,
          onTap: () {
            setState(() {
              _selectedParameters = parameter;
            });
            _triggerEvent(parameter);
          },
          title: AutoSizeText(
            parameter.name,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterActions(BuildContext context, Function(String) onApply) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text("Clear All"),
          ),
          ElevatedButton(
            onPressed: () {
              onApply("with_genres=28");
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text("Apply"),
          ),
        ],
      ),
    );
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
              widget.onMediaTypeChange(
                  newValue); // Assuming .value gives you the corresponding string
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
                  ..add(GetFilterOptions(filterBloc.state.filterParameters)),
                child: Builder(builder: (context) {
                  return IconButton(
                      onPressed: () {
                        showFilterBottomSheet(context, widget.onApply);
                      },
                      icon: Icon(Icons.filter_alt));
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

BlocProvider<FilterBloc> buildBody(
    BuildContext builderContext, FilterBloc filterBloc) {
  return BlocProvider.value(
    value: builderContext.watch<FilterBloc>(),
    child: BlocBuilder<FilterBloc, FilterState>(
      builder: (BuildContext context, FilterState state) {
        if (state.status == FilterStatus.initial) {
          return const LoadingWidget(
            message: "Initializing",
          );
        } else {
          return Center(
            child: Text(state.message),
          );
        }
      },
    ),
  );
}
