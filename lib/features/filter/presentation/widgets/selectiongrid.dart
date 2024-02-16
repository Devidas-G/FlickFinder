import 'package:flickfinder/features/filter/domain/entities/genreentity.dart';
import 'package:flickfinder/features/filter/presentation/bloc/filter_bloc.dart';
import 'package:flickfinder/features/filter/presentation/widgets/checkitem.dart';
import 'package:flickfinder/features/media/domain/usecases/getfilteredmedia.dart';
import 'package:flutter/material.dart';

class SelectionGrid extends StatefulWidget {
  final List<GenreEntity> items;
  final List<GenreEntity>? selectedItems;
  final FilterBloc filterBloc;

  const SelectionGrid(
      {super.key,
      required this.items,
      required this.filterBloc,
      required this.selectedItems});
  @override
  _SelectionGridState createState() => _SelectionGridState();
}

class _SelectionGridState extends State<SelectionGrid> {
  List<GenreEntity> _selectedItems = [];

  @override
  void initState() {
    super.initState();

    if (widget.selectedItems != null) {
      _selectedItems.addAll(widget.selectedItems!);
    }
  }

  void toggleSelection(GenreEntity item) {
    final GetFilteredMediaParams newFilteredMediaParams =
        widget.filterBloc.state.newFilterParams;
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      if (newFilteredMediaParams.genre != null) {
        widget.filterBloc.add(UpdateFilterparmas(
            newFilterParams:
                newFilteredMediaParams.copyWith(genre: _selectedItems)));
      }
    } else {
      _selectedItems.add(item);
      widget.filterBloc.add(UpdateFilterparmas(
          newFilterParams:
              newFilteredMediaParams.copyWith(genre: _selectedItems)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: GridView.builder(
        itemCount: widget.items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 3,
        ),
        itemBuilder: (context, index) {
          GenreEntity item = widget.items[index];
          return CheckItem(
            text: item.name,
            isSelected: _selectedItems.contains(item),
            onPressed: () {
              toggleSelection(item);
            },
          );
        },
      ),
    );
  }
}
