import 'dart:io';

import 'package:blog/core/error/exceptions.dart';
import 'package:blog/core/error/failure.dart';
import 'package:blog/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:blog/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
	final BlogRemoteDataSource blogRemoteDataSource;
	BlogRepositoryImpl({required this.blogRemoteDataSource});

	@override
	Future<Either<Failure, Blog>> uploadBlog({
		required String content,
		required String title,
		required String posterId,
		required File image,
		required List<String> topics,
	}) async {
		try {
				BlogModel blogModel = BlogModel(
					id: Uuid().v1(),
					content: content,
					title: title,
					posterId: posterId,
					imageUrl: '',
					topics: topics,
					updatedAt: DateTime.now()
				);

				final imageUrl = await blogRemoteDataSource.uploadBlogImage(image: image, blog: blogModel);
				blogModel = blogModel.copyWith(imageUrl: imageUrl);
				
				return Right(await blogRemoteDataSource.uploadBlog(blogModel));

		} on ServerException catch (e) {
			
			return Left(Failure(e.message));
		}
	}
  
   @override
   Future<Either<Failure, List<Blog>>> getAllBlogs() async {
      try {
        return Right(await blogRemoteDataSource.getAllBlogs());
      } on ServerException catch (e) {
        return Left(Failure(e.message));
      }
   }
}
