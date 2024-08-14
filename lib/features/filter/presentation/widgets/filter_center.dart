import 'package:flickfinder/features/filter/domain/entities/filterentity.dart';
import 'package:flickfinder/features/filter/presentation/widgets/filter_tile.dart';
import 'package:flutter/material.dart';

Widget mappedFilterList(BuildContext context, List<FilterEntity> filterEntity) {
  return Expanded(
    child: filterEntity.isEmpty
        ? const Center(
            child: Text("Filter unavailable"),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filterEntity.length,
            itemBuilder: (context, index) {
              final entry = filterEntity.elementAt(index);
              return FilterTile(
                title: entry.title,
                child: entry.widget,
              );
            },
          ),
  );
}
