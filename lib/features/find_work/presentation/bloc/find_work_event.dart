import 'package:equatable/equatable.dart';

abstract class FindWorkEvent extends Equatable {
  const FindWorkEvent();

  @override
  List<Object> get props => [];
}

class LoadProjectsEvent extends FindWorkEvent {}

class LoadMoreProjectsEvent extends FindWorkEvent {}
