import 'package:flutter/material.dart';

class PlaceDetailPage extends StatelessWidget {
  final String id;

  const PlaceDetailPage({Key? key, required this.id}) : super(key: key);

  static Route route(String id) {
    return MaterialPageRoute(builder: (_) => PlaceDetailPage(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return Text(id);
  }
}
