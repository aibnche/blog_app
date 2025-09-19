import 'dart:io';

import 'package:blog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog/core/theme/app_pallete.dart' show AppPallete;
import 'package:blog/core/utils/pick_image.dart';
import 'package:blog/core/utils/show_snackbar.dart';
import 'package:blog/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        // the build function will be rebuild only if image is changed
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Add New Blog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: () {
              uploadBlogFn(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogSuccess) {
            showSnackBar(context, 'Blog uploaded successfully!');
            Navigator.pushAndRemoveUntil(context, newRoute, predicate)
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(image!, fit: BoxFit.cover),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                color: AppPallete.borderColor,
                                radius: Radius.circular(10),
                                dashPattern: const [10, 5],
                                strokeWidth: 2,
                                strokeCap: StrokeCap.round,
                              ),

                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select Your Image',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                    SizedBox(height: 40),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                                  'Technology',
                                  'Science',
                                  'Art',
                                  'Education',
                                  'Health',
                                  'Travel',
                                ]
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedTopics.contains(e)) {
                                          selectedTopics.remove(e);
                                        } else {
                                          selectedTopics.add(e);
                                        }
                                        setState(() {}); // Refresh UI
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        color: selectedTopics.contains(e)
                                            ? const WidgetStatePropertyAll(
                                                AppPallete.gradient2,
                                              )
                                            : null,
                                        side: selectedTopics.contains(e)
                                            ? null
                                            : const BorderSide(
                                                color: AppPallete.borderColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog title',
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void uploadBlogFn(BuildContext context) {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      // get the posterId from AppUserCubit
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
        BlogUpload(
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          topics: selectedTopics,
          image: image!,
          posterId: posterId,
        ),
      );
    }
  }
}
