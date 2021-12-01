import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place/models/place.dart';
import 'package:place/repository/place_repository.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<UtilitiesEvent, UtilitiesState> {
  final PlaceRepository _utilitiesRepository;
  final String accessToken;

  PlaceBloc({
    required PlaceRepository utilitiesRepository,
    required this.accessToken,
  })  : _utilitiesRepository = utilitiesRepository,
        super(const UtilitiesState()) {
    on<GetListUtilitiesRequested>(_onGetListUtilitiesRequested);
  }

  void _onGetListUtilitiesRequested(
    GetListUtilitiesRequested event,
    Emitter<UtilitiesState> emit,
  ) async {
    if (state.hasReachedMax) return emit(state);
    try {
      final listUtilities = await _utilitiesRepository.getListUtilities(
          state.nextPage, accessToken);
      if (state.status == PlaceStatus.initial) {
        return emit(state.copyWith(
          status: PlaceStatus.success,
          listUtilities: listUtilities,
          hasReachedMax: false,
          nextPage: state.nextPage + 1,
        ));
      }
      return emit(listUtilities.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: PlaceStatus.success,
              listUtilities: List.of(state.listUtilities)
                ..addAll(listUtilities),
              hasReachedMax: false,
              nextPage: state.nextPage + 1,
            ));
    } catch (e) {
      return emit(state.copyWith(status: PlaceStatus.failure));
    }
  }
}
