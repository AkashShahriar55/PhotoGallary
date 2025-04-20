
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallary/app/core/widgets/photo_tile.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A photo with an invalid path to force errorBuilder
  final testPhoto = Photo(
    id: '1',
    uri: 'uri',
    name: 'name',
    path: 'invalid_path.jpg',
    size: 100,
    width: 100,
    height: 100,
    orientation: 0,
  );

  group('PhotoTile widget', () {
    testWidgets('shows broken_image icon when image fails to load', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoTile(photo: testPhoto),
          ),
        ),
      );
      // Allow image errorBuilder to fire
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });

    testWidgets('shows check_circle icon and overlay when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoTile(photo: testPhoto, selected: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check for check_circle icon
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      // Check for semi-transparent overlay container
      final overlayFinder = find.byWidgetPredicate(
            (widget) =>
        widget is Container &&
            widget.color == Colors.black.withOpacity(0.2),
      );
      expect(overlayFinder, findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoTile(
              photo: testPhoto,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(PhotoTile));
      expect(tapped, isTrue);
    });
  });
}
