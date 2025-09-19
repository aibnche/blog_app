import 'dart:io';

import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:blog/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required  UploadBlog uploadBlog,
    required  GetAllBlogs getAllBlogs,
  })
  : _uploadBlog = uploadBlog,
    _getAllBlogs = getAllBlogs, 
    super(BlogInitial())
    {
    on<BlogEvent>((event, emit) {emit(BlogLoading());});
    on<BlogUpload>(_onBlogUpload);
    on<GetAllBlogsEvent>(_onGetAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
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

  void _onGetAllBlogs(GetAllBlogsEvent event,Emitter<BlogState> emit) async {
    final blogs = await _getAllBlogs(NoParams());

    blogs.fold(
      (failure) => emit(BlogFailure(error: failure.message)),
      (blogs) => emit(BlogsSuccess(blogs))
    );
  }
}
