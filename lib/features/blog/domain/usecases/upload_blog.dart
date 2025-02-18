import 'dart:io';

import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:blog_post_using_clean_architecture/core/usecase/usecase.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog({required this.blogRepository});

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.upLoadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams(
      {required this.posterId,
      required this.title,
      required this.content,
      required this.image,
      required this.topics});
}
