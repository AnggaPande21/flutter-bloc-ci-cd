import 'package:flutter_test/flutter_test.dart';
import 'package:bloccicd/data/models/post_model.dart';
import 'package:bloccicd/domain/entities/post.dart';

void main() {
  const tPostModel = PostModel(
    id: 1,
    userId: 1,
    title: 'Test Title',
    body: 'Test Body',
  );

  group('PostModel', () {
    test('should be a subclass of Post entity', () {
      expect(tPostModel, isA<Post>());
    });

    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'userId': 1,
        'title': 'Test Title',
        'body': 'Test Body',
      };

      final result = PostModel.fromJson(jsonMap);

      expect(result, equals(tPostModel));
    });

    test('should return a JSON map containing proper data', () {
      final result = tPostModel.toJson();

      final expectedMap = {
        'id': 1,
        'userId': 1,
        'title': 'Test Title',
        'body': 'Test Body',
      };

      expect(result, equals(expectedMap));
    });

    test('should create PostModel from Post entity', () {
      const tPost = Post(
        id: 1,
        userId: 1,
        title: 'Test Title',
        body: 'Test Body',
      );

      final result = PostModel.fromEntity(tPost);

      expect(result, equals(tPostModel));
    });
  });
}
