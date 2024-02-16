import 'package:flickfinder/features/filter/presentation/widgets/filter_center.dart';
import 'package:flickfinder/features/filter/presentation/widgets/filter_footer.dart';
import 'package:flickfinder/features/filter/presentation/widgets/filter_header.dart';
import 'package:flickfinder/features/filter/presentation/widgets/filter_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../media/domain/usecases/getfilteredmedia.dart';
import '../bloc/filter_bloc.dart';
import 'loading_widget.dart';
import 'message_display.dart';

class FilterList extends StatefulWidget {
  final Function() onApply;
  final Function() onClear;
  const FilterList({super.key, required this.onApply, required this.onClear});

  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
  void showFilterBottomSheet(
      BuildContext builderContext, Function() onClear, Function() onApply) {
    showModalBottomSheet<void>(
      context: builderContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
            builder: (_, void Function(void Function()) setState) {
          return SizedBox(
            height: MediaQuery.of(builderContext).size.height * 0.7,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  filterHeader(context),
                  buildBody(builderContext),
                  filterFooter(context, onApply, onClear),
                ]),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return IconButton(
          onPressed: () {
            showFilterBottomSheet(context, widget.onClear, widget.onApply);
          },
          icon: Icon(Icons.filter_alt));
    });
  }
}

BlocProvider<FilterBloc> buildBody(BuildContext builderContext) {
  return BlocProvider.value(
    value: builderContext.read<FilterBloc>(),
    child: BlocBuilder<FilterBloc, FilterState>(
      builder: (BuildContext context, FilterState state) {
        switch (state.status) {
          case FilterStatus.initial:
            return const LoadingWidget(
              message: "Initializing",
            );
          case FilterStatus.loading:
            return const LoadingWidget(
              message: "Loading",
            );
          case FilterStatus.loaded:
            return mappedFilterList(builderContext, state.filterList);
          case FilterStatus.error:
            return MessageDisplay(
              message: state.message,
              code: state.statusCode,
            );
          default:
            return const MessageDisplay(
              message: "something went wrong",
              code: 0,
            );
        }
      },
    ),
  );
}
