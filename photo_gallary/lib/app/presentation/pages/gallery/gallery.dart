import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';
import 'package:photo_gallary/app/core/widgets/gallery_app_bar.dart';
import 'package:photo_gallary/app/core/widgets/photo_tile.dart';
import 'package:photo_gallary/app/core/widgets/secondary_button.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/di/injection.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/download_cubit/download_cubit.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/selection_cubit/selection_cubit.dart';
import 'bloc/download_cubit/download_state.dart';
import 'bloc/gallary_event.dart';
import 'bloc/gallary_state.dart';

class GalleryScreen extends StatelessWidget{
  const GalleryScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SelectionCubit()),
          BlocProvider(create: (ctx) => DownloadCubit(ctx.read<SelectionCubit>())),
          BlocProvider(create: (_) => getIt<GalleryBloc>()..add(FetchPhotos())),
        ],
        child: const _GalleryView()
    );
  }
}

class _GalleryView extends StatelessWidget {

  const _GalleryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: galleryAppBar(context: context, title: 'Photos'),
      body: BlocListener<DownloadCubit, DownloadState>(
        listener: (ctx, state) {
          if(state.status == DownloadStatus.downloading) {
            ctx.read<GalleryBloc>().add(FetchPhotos());
          } else if (!(state.status == DownloadStatus.downloading) && (state.status == DownloadStatus.success)) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text('Images saved!')),
            );
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (ctx, state) {
            if (state is GalleryLoading || state is GalleryInitial) return const Center(child: CircularProgressIndicator());
            if (state is GalleryError)   return Center(child: Text(state.error));
            return _buildGrid(ctx, (state as GalleryLoaded).photos);
          },
        ),
      ),
      floatingActionButton: _buildDownloadFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  Widget _buildGrid(BuildContext ctx, List<Photo> photos) {
    return GridView.builder(
      padding: const EdgeInsets.all(Dimens.dimen_4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: Dimens.dimen_4, mainAxisSpacing: Dimens.dimen_4,
      ),
      itemCount: photos.length,
      itemBuilder: (ctx, i) {
        final photo = photos[i];
        return BlocBuilder<SelectionCubit, List<Photo>>(
          buildWhen: (prev, next) => prev.contains(photo) != next.contains(photo),
          builder: (ctx, selected) {
            return PhotoTile(
              key: ValueKey(photo.id),
              path: photo.path,
              selected: selected.contains(photo),
              onTap: () => ctx.read<SelectionCubit>().selectDeselect(photo),
            );
          },
        );
      },
    );
  }

  Widget _buildDownloadFab(BuildContext context) {
    return BlocBuilder<DownloadCubit, DownloadState>(
      builder: (ctx, download) {
        if (!download.isPhotoSelected) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: Dimens.dimen_33),
          width: 310,
          height: 50,
          child: SecondaryButton(
            onTap: download.status == DownloadStatus.downloading
                ? null
                : () => ctx.read<DownloadCubit>().downloadPhotos(),
            child: download.status == DownloadStatus.downloading
                ? const SizedBox(
              width: Dimens.dimen_24, height: Dimens.dimen_24, child: CircularProgressIndicator(strokeWidth: Dimens.dimen_2),
            )
                : const Text('DOWNLOAD'),
          ),
        );
      },
    );
  }

}