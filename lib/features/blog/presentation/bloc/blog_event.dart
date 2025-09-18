part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final String content;
  final String title;
  final String posterId;
  final File image;
  final List<String> topics;

  BlogUpload({
    required this.content,
    required this.title,
    required this.posterId,
    required this.image,
    required this.topics,
  });
}