import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FilterEntity extends Equatable {
  final String title;
  final Widget widget;

  const FilterEntity({
    required this.title,
    required this.widget,
  });
  @override
  List<Object?> get props => [title, widget];
}
