import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/constants/strings.dart';
import 'package:photo_gallary/app/core/theme/sizes.dart';
import 'package:photo_gallary/app/core/utils/logger.dart';
import 'package:photo_gallary/app/core/widgets/gallery_app_bar.dart';
import 'package:photo_gallary/app/core/widgets/photo_tile.dart';
import 'package:photo_gallary/app/core/widgets/secondary_button.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';
import 'package:photo_gallary/app/di/injection.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/gallary_bloc.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/selection_cubit/selection_cubit.dart';
import 'bloc/gallary_event.dart';
import 'bloc/gallary_state.dart';

class GalleryScreen extends StatelessWidget{
  const GalleryScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<SelectionCubit>()),
          BlocProvider(create: (_) => getIt<GalleryBloc>()),
        ],
        child: const _GalleryView()
    );
  }
}

class _GalleryView extends StatelessWidget {

  const _GalleryView();

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.exitAppTitle),
        content: const Text(AppStrings.exitAppMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.yes),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        // If the route already popped, do nothing
        if (didPop) return;

        // Otherwise, show confirmation dialog
        final shouldExit = await _showExitDialog(context);
        if (shouldExit == true) {
          // Exit the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: galleryAppBar(context: context, title: AppStrings.photos,onPressed: () async {
          await _showExitDialog(context);
        }),
        body: BlocConsumer<GalleryBloc, GalleryState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              Log.e(state.errorMessage.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? "")),
              );
            }
          },
          builder: (ctx, state) {
            if (state.isPhotoLoading) return const Center(child: CircularProgressIndicator());
            Log.d("${state.photos.length}");
            return _buildGrid(ctx, state.photos);
          },
        ),
        floatingActionButton: _buildDownloadFab(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }


  Widget _buildGrid(BuildContext ctx, List<Photo> photos) {
    return GridView.builder(
      key: ValueKey(photos.length),
      padding: const EdgeInsets.all(Dimens.dimen_4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, crossAxisSpacing: Dimens.dimen_4, mainAxisSpacing: Dimens.dimen_4,
      ),
      itemCount: photos.length,
      itemBuilder: (ctx, i) {
        final photo = photos[i];
        return BlocBuilder<SelectionCubit, List<String>>(
          builder: (ctx, selected) {
            return PhotoTile(
              key: ValueKey(photo.id),
              photo: photo,
              selected: selected.contains(photo.id),
              onTap: () => ctx.read<SelectionCubit>().selectDeselect(photo.id),
            );
          },
        );
      },
    );
  }

  Widget _buildDownloadFab(BuildContext context) {
    return BlocBuilder<SelectionCubit, List<String>>(
      builder: (ctx, selectedList) {
        if (selectedList.isEmpty) return const SizedBox.shrink();
        return Container(
          margin: const EdgeInsets.only(bottom: Dimens.dimen_33),
          width: Dimens.dimen_310,
          height: Dimens.dimen_50,
          child: _buildDownloadFabContent(context),
        );
      },
    );
  }


  Widget _buildDownloadFabContent(BuildContext context){
    final galleryBloc = context.read<GalleryBloc>();
    final selectionCubit = context.read<SelectionCubit>();
    return BlocBuilder<GalleryBloc,GalleryState>(
        builder: (ctx, state) {
          return SecondaryButton(
            onTap: state.status == DownloadStatus.downloading
                ? null
                : () => galleryBloc.add(DownloadPhotos(selectionCubit.state)),
            child: state.status == DownloadStatus.downloading
                ? const SizedBox(
              width: Dimens.dimen_24, height: Dimens.dimen_24, child: CircularProgressIndicator(strokeWidth: Dimens.dimen_2),
            )
                : const Text(AppStrings.download),
          );
        }
    );
  }

}