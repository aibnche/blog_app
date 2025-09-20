import 'package:blog/core/common/widgets/loader.dart';
import 'package:blog/core/theme/app_pallete.dart';
import 'package:blog/core/utils/show_snackbar.dart';
import 'package:blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  /*
   * @ initState is called once when the stateful widget is inserted in the widget tree
   * @ Purpose: Initialize state for the BlogPage widget
   * @ Call super.initState() to ensure the parent class's initialization
       logic is also executed
  */
  @override
  void initState() {
    super.initState();

    context.read<BlogBloc>().add(GetAllBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add_circled),
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error, isError: true);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading){
            return const Loader();
          }
          if (state is BlogsSuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, BlogViewPage.route(state.blogs[index]));
                  },
                  child: BlogCard(
                      key: ValueKey(state.blogs[index].id),
                      blog: state.blogs[index],
                      color: const Color.fromARGB(255, 93, 138, 245)
                      ),
                );
            });
          }
          return const SizedBox();
        },
      ),
    );
  }
}
