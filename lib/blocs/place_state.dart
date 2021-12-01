part of 'place_bloc.dart';

class UtilitiesState extends Equatable {
  final PlaceStatus status;
  final List<Place> listUtilities;
  final bool hasReachedMax;
  final int nextPage;

  const UtilitiesState({
    this.status = PlaceStatus.initial,
    this.listUtilities = const [],
    this.hasReachedMax = false,
    this.nextPage = 0,
  });

  UtilitiesState copyWith({
    PlaceStatus? status,
    List<Place>? listUtilities,
    bool? hasReachedMax,
    int? nextPage,
  }) {
    return UtilitiesState(
      status: status ?? this.status,
      listUtilities: listUtilities ?? this.listUtilities,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  @override
  List<Object?> get props => [status, listUtilities, hasReachedMax, nextPage];
}
