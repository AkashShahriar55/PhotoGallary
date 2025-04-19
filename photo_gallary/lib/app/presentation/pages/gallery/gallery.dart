import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/core/widgets/gallery_app_bar.dart';
import 'package:photo_gallary/app/core/widgets/photo_tile.dart';
import 'package:photo_gallary/app/di/injection.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_bloc.dart';
import 'bloc/gallary_event.dart';
import 'bloc/gallary_state.dart';

class GalleryScreen extends StatefulWidget{
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  final GalleryBloc _galleryBloc = getIt<GalleryBloc>();


  @override
  void initState() {
    super.initState();
    _galleryBloc.add(FetchPhotos(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: galleryAppBar(context: context,title: "Photos"),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        bloc: _galleryBloc,
        builder: (context, state) {
          if (state is GalleryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GalleryLoaded) {
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                return PhotoTile(path: state.photos[index].path);
              },
            );
          } else if (state is GalleryError) {
            return Center(child: Text(state.error));
          }
          return const SizedBox();
        },
      ),
    );
  }
}