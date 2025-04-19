
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionCubit extends Cubit<List<String>> {
  SelectionCubit() : super([]);

  void selectDeselect(String id) {
    if (state.contains(id)) {
      emit(state.where((element) => element != id).toList());
    } else {
      emit([...state, id]);
    }
  }

}