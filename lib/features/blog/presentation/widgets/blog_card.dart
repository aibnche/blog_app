import 'package:blog/core/utils/calculate_reading_time.dart';
import 'package:blog/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;

  const BlogCard({
      super.key,
      required this.blog,
      required this.color
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        
        color: color,
        // border: Border.all(), // 
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                  blog.topics.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: Chip(
                        label: Text(e),
                      ),
                    ),
                  )
                  .toList(),
              ),
          ),

          Expanded(child: Text(blog.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
          )),),

          Text("${calculateReadingTime(blog.content) } min read"),
        ],
      ),
    );
  }
}
