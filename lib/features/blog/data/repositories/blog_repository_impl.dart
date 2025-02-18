import 'dart:io';

import 'package:blog_post_using_clean_architecture/core/error/exception.dart';
import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:blog_post_using_clean_architecture/core/network/connection_checker.dart';
import 'package:blog_post_using_clean_architecture/features/blog/data/data_souce/blog_remote_data_source.dart';
import 'package:blog_post_using_clean_architecture/features/blog/data/model/blog_model.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../data_souce/local_data_source.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;
  final BlogLocalDataSource blogLocalDataSource;

  BlogRepositoryImpl(
      {required this.connectionChecker,
      required this.blogLocalDataSource,
      required this.blogRemoteDataSource});

  @override
  Future<Either<Failure, Blog>> upLoadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(
          Failure(
            'No internet connection',
          ),
        );
      }
      BlogModel blogModel = BlogModel(
        id: Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.upLoadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final upLoadedBlog = await blogRemoteDataSource.upLoadBlog(blogModel);
      return right(upLoadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);

      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
