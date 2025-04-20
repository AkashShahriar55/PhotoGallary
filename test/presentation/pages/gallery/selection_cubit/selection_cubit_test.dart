import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:photo_gallary/app/presentation/pages/gallery/bloc/selection_cubit/selection_cubit.dart';

void main() {
  group('SelectionCubit', () {
    late SelectionCubit cubit;

    setUp(() {
      cubit = SelectionCubit();
    });

    test('initial state is empty list', () {
      expect(cubit.state, isEmpty);
    });

    blocTest<SelectionCubit, List<String>>(
      'emits [\'1\'] when selecting an unselected id',
      build: () => SelectionCubit(),
      act: (c) => c.selectDeselect('1'),
      expect: () => [
        ['1'],
      ],
    );

    blocTest<SelectionCubit, List<String>>(
      'emits [] when deselecting a selected id',
      build: () => SelectionCubit(),
      seed: () => ['1'],
      act: (c) => c.selectDeselect('1'),
      expect: () => [
        <String>[], // deselected back to empty
      ],
    );

    blocTest<SelectionCubit, List<String>>(
      'emits accumulating selections when selecting multiple ids',
      build: () => SelectionCubit(),
      act: (c) {
        c.selectDeselect('1');
        c.selectDeselect('2');
      },
      expect: () => [
        ['1'],
        ['1', '2'],
      ],
    );

    blocTest<SelectionCubit, List<String>>(
      'toggles correctly: select then deselect then select again',
      build: () => SelectionCubit(),
      act: (c) {
        c.selectDeselect('a'); // ['a']
        c.selectDeselect('a'); // []
        c.selectDeselect('a'); // ['a']
      },
      expect: () => [
        ['a'],
        <String>[],
        ['a'],
      ],
    );
  });
}
