import 'dart:io';

import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;

  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {emit(BlogLoading());});
    on<BlogUpload>(_onBlogUpload);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await uploadBlog(
      UploadBlogParams(
        content: event.content,
        title: event.title,
        posterId: event.posterId,
        image: event.image,
        topics: event.topics,
      ));

      res.fold(
        (failure) => emit(BlogFailure(error: failure.message)),
        (blog) => emit(BlogSuccess(blog: blog))
      );
  }
}
