import 'package:blog_post_using_clean_architecture/core/common/widget/loader.dart';
import 'package:blog_post_using_clean_architecture/core/theme/app_palette.dart';
import 'package:blog_post_using_clean_architecture/core/utils/show_snackbar.dart';
import 'package:blog_post_using_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_post_using_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_post_using_clean_architecture/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(GetAllUserBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Blog App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                AddNewBlogPage().route,
              );
            },
            icon: Icon(
              CupertinoIcons.add_circled,
            ),
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(
              context,
              state.error,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }
          if (state is BlogFetchSuccess) {
            return ListView.builder(
                itemCount: state.blog.length,
                itemBuilder: (context, index) {
                  final blog = state.blog[index];
                  return BlogCard(
                    blog: blog,
                    color: index % 3 == 0
                        ? AppPallete.gradient1
                        : index % 3 == 1
                            ? AppPallete.gradient2
                            : AppPallete.gradient3,
                  );
                });
          }
          return SizedBox();
        },
      ),
    );
  }
}
