import 'package:blog/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

// concrete implementation
class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final List<BlogModel> _localBlogs = [];
  final Box box;

  BlogLocalDataSourceImpl(this.box);
  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i]);
      }
    });
  }

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    box.read(() {
      for (int i = 0; i < box.length; i++) {
        final blog = box.get(i.toString());
        if (blog != null) {
          blogs.add(BlogModel.fromJson(blog));
        }
      }
    });
    return blogs;
  }
}
