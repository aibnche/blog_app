import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/calculate_reading_time.dart';
import 'package:blog/core/utils/format_date.dart';
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
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // cross axis, horizontal
              children: [
                Text(blog.title,
                style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 20,),
                Text("by ${blog.posterName}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),),
                SizedBox(height: 5,),
                Text("${formatDateBydMMMYYYY(blog.updatedAt)} ${calculateReadingTime(blog.content)} min",
                style: const TextStyle(
                  color: AppPallete.greyColor,
                  fontSize: 14
                ),),
                SizedBox(height: 20,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(blog.imageUrl)
                ),
                SizedBox(height: 20,),
                Text(blog.content,
                style: const TextStyle(
                  fontSize: 16,
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
