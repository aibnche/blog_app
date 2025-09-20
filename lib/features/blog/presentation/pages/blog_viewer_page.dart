import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewPage extends StatelessWidget {
  final Blog blog;
  const BlogViewPage({super.key, required this.blog});
  
  static route(Blog blog) => MaterialPageRoute(builder: (context) => BlogViewPage(blog: blog));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${blog.title} --"),
      ),
      body: Center(
        child: Text("${blog.content}"),
      ),
    );
  }
}
