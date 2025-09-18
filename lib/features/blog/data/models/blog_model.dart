import 'package:blog/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.content,
    required super.title,
    required super.posterId,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
  });


    /* Serialization
      
      @ Converts your BlogModel object into a format suitable for storage
        or sending to a backend (e.g., Supabase). 
      @ this is typically used when you want to save or update a blog post
        in a database.
      @ All fields are mapped to keys that match your database column names
        (snake_case).
    */
    Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'title': title,
      'poster_id': posterId,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }


  /*  Deserialization
  
      @ Creates a BlogModel instance from a JSON-like map.
      @ This is typically used when you retrieve blog post data from a backend
        (e.g., Supabase) and want to convert it into a BlogModel object for use
        in your application.
      @ It expects the map to have keys that match your database column names
        (snake_case).
    */
  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      content: map['content'] as String,
      title: map['title'] as String,
      posterId: map['poster_id'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(map['topics'] as List<String>),
      updatedAt: map['updated_at'] != null
                      ? DateTime.parse(map['updated_at']) 
                      : DateTime.now(),
    );
  }

  BlogModel copyWith({
    String? id, // ? means optional
    String? content,
    String? title,
    String? posterId,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
  }) {
    return BlogModel(
      id: id ?? this.id,
      content: content ?? this.content,
      title: title ?? this.title,
      posterId: posterId ?? this.posterId,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
