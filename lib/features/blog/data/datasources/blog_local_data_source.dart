import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

// concrete implementation
class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl(this.box);

  // upload blogs to local storage
  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box.clear();
    
      final blogsChunk = blogs.take(40).toList();
      for (int i = 0; i < blogsChunk.length; i++) {
        box.put(i.toString(), blogsChunk[i].toJson());
      }
    
  }

  // load blogs from local storage
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    
      for (int i = 0; i < box.length; i++) {
        final blog = box.get(i.toString());
        if (blog != null) {
          blogs.add(BlogModel.fromJson(Map<String, dynamic>.from(blog)));
        }
      }
    
    return blogs;
  }
}
