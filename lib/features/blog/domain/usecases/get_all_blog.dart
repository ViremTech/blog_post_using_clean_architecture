import 'package:blog_post_using_clean_architecture/core/error/failure.dart';
import 'package:blog_post_using_clean_architecture/core/usecase/usecase.dart';
import 'package:blog_post_using_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

class GetAllBlog implements Usecase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;

  GetAllBlog({required this.blogRepository});

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
