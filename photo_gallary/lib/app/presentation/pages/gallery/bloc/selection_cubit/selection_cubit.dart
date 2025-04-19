
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionCubit extends Cubit<List<int>> {
  SelectionCubit() : super([]);

  void selectDeselect(int id) {
    if (state.contains(id)) {
      emit(state.where((element) => element != id).toList());
    } else {
      emit([...state, id]);
    }
  }

}