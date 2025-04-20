import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photo_gallary/app/data/datasources/local/local_storage/local_photo_datasource.dart';
import 'package:photo_gallary/app/data/datasources/local/local_storage/model/photo.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelName = 'com.photogallary.cheq/gallery';
  const fetchMethod = 'getImages';
  const saveMethod = 'saveAndFetchPhoto';

  late LocalPhotoDatasource datasource;
  late MethodChannel channel;

  setUp(() {
    datasource = LocalPhotoDatasource();
    channel = const MethodChannel(channelName);
    channel.setMockMethodCallHandler(null);
  });

  group('fetchPhotos', () {
    final jsonList = [
      {
        'id': '1',
        'uri': 'u1',
        'name': 'n1',
        'path': '/p1',
        'size': 100,
        'width': 50,
        'height': 50,
        'orientation': 0,
      },
      {
        'id': '2',
        'uri': 'u2',
        'name': 'n2',
        'path': '/p2',
        'size': 200,
        'width': 60,
        'height': 80,
        'orientation': 1,
      },
    ];

    test('returns list of Photo on success', () async {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        expect(methodCall.method, fetchMethod);
        return jsonList;
      });

      final photos = await datasource.fetchPhotos();
      expect(photos, isNotNull);
      expect(photos!.length, jsonList.length);
      for (var i = 0; i < jsonList.length; i++) {
        expect(photos[i], isA<Photo>());
        expect(photos[i].id, jsonList[i]['id']);
        expect(photos[i].uri, jsonList[i]['uri']);
        expect(photos[i].name, jsonList[i]['name']);
      }
    });

    test('returns null when channel returns null', () async {
      channel.setMockMethodCallHandler((_) async => null);

      final photos = await datasource.fetchPhotos();
      expect(photos, isNull);
    });

    test('returns null on PlatformException', () async {
      channel.setMockMethodCallHandler((_) async => throw PlatformException(code: 'ERROR', message: 'fail'));

      final photos = await datasource.fetchPhotos();
      expect(photos, isNull);
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
    });
  });

  group('savePhoto', () {
    final photo = Photo(
      id: '10',
      uri: 'u10',
      name: 'n10',
      path: '/tmp/test.jpg',
      size: 500,
      width: 100,
      height: 100,
      orientation: 0,
    );
    final jsonResult = {
      'id': '10',
      'uri': 'u10',
      'name': 'n10_saved',
      'path': '/tmp/test.jpg',
      'size': 500,
      'width': 100,
      'height': 100,
      'orientation': 0,
    };

    test('returns Photo on success', () async {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        expect(methodCall.method, saveMethod);
        final args = methodCall.arguments as Map;
        expect(args['path'], photo.path);
        return jsonResult;
      });

      final result = await datasource.savePhoto(photo);
      expect(result, isNotNull);
      expect(result!.name, jsonResult['name']);
    });

    test('returns null when channel returns null', () async {
      channel.setMockMethodCallHandler((_) async => null);

      final result = await datasource.savePhoto(photo);
      expect(result, isNull);
    });

    test('throws when non-PlatformException is thrown', () async {
      channel.setMockMethodCallHandler((_) async => throw Exception('unexpected'));

      expect(() => datasource.savePhoto(photo), throwsA(isA<Exception>()));
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
    });
  });
}