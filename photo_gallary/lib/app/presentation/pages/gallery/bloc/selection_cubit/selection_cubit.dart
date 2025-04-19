
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

class SelectionCubit extends Cubit<List<Photo>> {
  SelectionCubit() : super([]);

  void selectDeselect(Photo photo) {
    if (state.contains(photo)) {
      emit(state.where((element) => element != photo).toList());
    } else {
      emit([...state, photo]);
    }
  }

}