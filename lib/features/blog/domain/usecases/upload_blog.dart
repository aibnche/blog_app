import 'dart:io';

import 'package:blog/core/error/failure.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';



class UploadBlog implements UseCase<Blog, UploadBlogParams>{
  final BlogRepository blogRepository;
  UploadBlog({required this.blogRepository});
  
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {

    throw UnimplementedError();
  }

}

class UploadBlogParams {
  final String content;
  final String title;
  final String posterId;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.content,
    required this.title,
    required this.posterId,
    required this.image,
    required this.topics,
  });
}