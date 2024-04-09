import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '게시판',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoticeboardPage(),
    );
  }
}

class NoticeboardPage extends StatefulWidget {
  @override
  _NoticeboardPageState createState() => _NoticeboardPageState();
}

class _NoticeboardPageState extends State<NoticeboardPage> {
  List<Post> posts =[];

  void _deletePost(Post post) {
    setState(() {
      posts.remove(post);
    });
    _showSnackBar(context, '게시글이 삭제되었습니다.');
  }

  void _toggleLike(Post post) {
    setState(() {
      post.toggleLike();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자유게시판'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _navigateToPostDetail(context, posts[index]),
            child: PostCard(
              post: posts[index],
              onLikePressed: () => _toggleLike(posts[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPostDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showPostDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('새 게시글 작성'),
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: '게시글 제목'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: contentController,
                    decoration:
                    InputDecoration(hintText: '게시글 내용을 입력하세요'),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  setState(() {
                    posts.add(Post(titleController.text, contentController.text, "사용자"));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('등록'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPostDetail(BuildContext context, Post post) async {
    final updatedPost = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          post,
          onDeletePressed: () => _deletePost(post),
          onLikePressed: () => _toggleLike(post),
          onPostUpdated: (updatedPost) {
            setState(() {
              final index = posts.indexWhere((element) => element.title == updatedPost.title);
              if (index != -1) {
                posts[index] = updatedPost;
              }
            });
          },
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}

class Post {
  String title;
  String content;
  final String user;
  int likes;
  bool liked;

  Post(this.title, this.content, this.user, {this.likes = 0, this.liked = false});

  void toggleLike() {
    liked = !liked;
    if (liked) {
      likes++;
    } else {
      likes--;
    }
  }
}

class PostDetailPage extends StatefulWidget {
  final Post post;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onLikePressed;
  final Function(Post)? onPostUpdated;

  PostDetailPage(this.post, {this.onDeletePressed, this.onLikePressed, this.onPostUpdated});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        widget.post.liked ? Icons.favorite : Icons.favorite_border,
                        color: widget.post.liked ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.onLikePressed?.call();
                        });
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.post.likes.toString(),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, widget.post);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '작성자: ${widget.post.user}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('게시글 삭제'),
          content: Text('게시글을 삭제하시겠습니까?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeletePressed?.call();
                _showSnackBar(context, '게시글이 삭제되었습니다.');
              },
              child: Text('확인'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, Post post) async {
    TextEditingController titleController =
    TextEditingController(text: post.title);
    TextEditingController contentController =
    TextEditingController(text: post.content);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('게시글 수정'),
          content: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: '게시글 제목'),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: contentController,
                    decoration:
                    InputDecoration(hintText: '게시글 내용을 입력하세요'),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    contentController.text.isNotEmpty) {
                  setState(() {
                    widget.post.title = titleController.text;
                    widget.post.content = contentController.text;
                    widget.onPostUpdated?.call(widget.post);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('저장'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLikePressed;

  const PostCard({
    Key? key,
    required this.post,
    this.onLikePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        post.liked ? Icons.favorite : Icons.favorite_border,
                        color: post.liked ? Colors.red : null,
                      ),
                      onPressed: onLikePressed,
                    ),
                    SizedBox(width: 8),
                    Text(
                      post.likes.toString(), // 좋아요 숫자 표시
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '작성자: ${post.user}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}