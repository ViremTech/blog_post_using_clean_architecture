import 'dart:io';

import 'package:blog_post_using_clean_architecture/core/usecase/usecase.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/usecases/get_all_blog.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlog _getAllBlog;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlog getAllBlogs})
      : _getAllBlog = getAllBlogs,
        _uploadBlog = uploadBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpLoad>(_onBlogUpload);
    on<GetAllUserBlogs>(_onGetAllUserBlogs);
  }

  void _onBlogUpload(BlogUpLoad event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));

    res.fold((failure) => emit(BlogFailure(error: failure.message)),
        (success) => emit(BlogSuccess()));
  }

  void _onGetAllUserBlogs(
      GetAllUserBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlog(NoParams());

    res.fold(
      (failure) => emit(BlogFailure(error: failure.message)),
      (userList) => emit(
        BlogFetchSuccess(blog: userList),
      ),
    );
  }
}
