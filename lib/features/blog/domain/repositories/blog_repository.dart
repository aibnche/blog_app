import 'dart:io';

import 'package:blog/core/error/failure.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required String content,
    required String title,
    required String posterId,
    required File image,
    required List<String> topics
  });
}