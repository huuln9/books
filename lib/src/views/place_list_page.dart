import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:place/src/repository/place_repository.dart';
import 'package:place/src/blocs/place_bloc.dart';
import 'package:place/src/models/place.dart';
import 'package:place/src/views/place_detail_page.dart';

class PlaceListPage extends StatefulWidget {
  final String placeName;

  const PlaceListPage({Key? key, required this.placeName}) : super(key: key);

  @override
  _PlaceListPageState createState() => _PlaceListPageState();
}

class _PlaceListPageState extends State<PlaceListPage> {
  final _scrollController = ScrollController();
  late PlaceBloc _utilitiesBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _utilitiesBloc = context.read<PlaceBloc>();
  }

  void _onScroll() {
    if (_onReachedMax) _utilitiesBloc.add(GetListUtilitiesRequested());
  }

  bool get _onReachedMax {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceBloc, UtilitiesState>(
      builder: (context, state) {
        switch (state.status) {
          case PlaceStatus.failure:
            return const Center(child: Text('Failed to get list utilities!'));
          case PlaceStatus.success:
            if (state.listUtilities.isEmpty) {
              return const Center(child: Text('No utilities!'));
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  widget.placeName,
                  style: const TextStyle(color: Colors.black),
                ),
                centerTitle: true,
              ),
              body: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.listUtilities.length
                        ? const BottomLoader()
                        : ListUtilitiesItem(
                            utilities: state.listUtilities[index]);
                  },
                  itemCount: state.hasReachedMax
                      ? state.listUtilities.length
                      : state.listUtilities.length + 1,
                  controller: _scrollController,
                ),
              ),
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ListUtilitiesItem extends StatelessWidget {
  final Place utilities;

  const ListUtilitiesItem({Key? key, required this.utilities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: TextButton(
        onPressed: () =>
            Navigator.of(context).push(PlaceDetailPage.route(utilities.id)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset("assets/images/img.jpg"),
          ),
          title: Text(
            utilities.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            utilities.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        // borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
