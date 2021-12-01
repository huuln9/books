// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place/repository/place_repository.dart';
import 'package:place/blocs/place_bloc.dart';
import 'package:place/views/place_list_page.dart';
import 'package:utils/src/blocs/authentication/authentication_bloc.dart';
import 'package:utils/src/blocs/configuration/configuration_bloc.dart';

class PlacePage extends StatelessWidget {
  final String placeName;
  final String placeTagId;

  const PlacePage({
    Key? key,
    required this.placeName,
    required this.placeTagId,
  }) : super(key: key);

  // static Route route(String utilitiesName, String utilitiesTagId) {
  //   return MaterialPageRoute(
  //     builder: (_) => PlacePage(
  //       utilitiesName: utilitiesName,
  //       utilitiesTagId: utilitiesTagId,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => PlaceBloc(
          utilitiesRepository: PlaceRepository(
            apiGatewayURL:
                context.read<ConfigurationBloc>().state.config['apiGatewayURL'],
            placeTagId: placeTagId,
          ),
          accessToken: context.read<AuthenticationBloc>().state.accessToken,
        )..add(GetListUtilitiesRequested()),
        child: PlaceListPage(placeName: placeName),
      ),
    );
  }
}
