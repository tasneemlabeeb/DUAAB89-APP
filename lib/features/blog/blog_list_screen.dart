import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/responsive.dart';
import 'blog_detail_screen.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Blog'),
        backgroundColor: const Color(0xFF2f2c6d),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Photo Banner Section
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Blog banner image
                Image.asset(
                  'assets/images/Blog-banner.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2f2c6d).withOpacity(0.3),
                      child: Icon(
                        Icons.article,
                        size: 80,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    );
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    'Blog',
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 28,
                        tablet: 32,
                        desktop: 30,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Blog Posts List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('blog_posts')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.red.shade300),
                        SizedBox(height: Responsive.hp(context, 2)),
                        Text(
                          'Error loading blog posts',
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 18,
                              tablet: 22,
                              desktop: 20,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Responsive.hp(context, 1)),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 12,
                              tablet: 14,
                              desktop: 13,
                            ),
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: const Color(0xFF2f2c6d),
                        ),
                        SizedBox(height: Responsive.hp(context, 2)),
                        Text(
                          'Loading blog posts...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                // Filter approved and published posts on client side
                final allPosts = snapshot.data!.docs;
                final blogPosts = allPosts.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status = data['status'] ?? '';
                  final published = data['published'] ?? false;
                  return status == 'approved' && published == true;
                }).toList();

                // Show empty state if no approved/published posts
                if (blogPosts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: Responsive.valueWhen(
                            context,
                            mobile: 80,
                            tablet: 100,
                            desktop: 90,
                          ),
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: Responsive.hp(context, 2)),
                        Text(
                          'No blog posts yet',
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 18,
                              tablet: 22,
                              desktop: 20,
                            ),
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: Responsive.hp(context, 1)),
                        Text(
                          'Check back later for new posts',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(Responsive.wp(context, 4)),
                  itemCount: blogPosts.length,
                  itemBuilder: (context, index) {
                    final postDoc = blogPosts[index];
                    final post = postDoc.data() as Map<String, dynamic>;
                    final postId = postDoc.id;

                    return _buildBlogCard(context, post, postId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(
      BuildContext context, Map<String, dynamic> post, String postId) {
    final title = post['title'] ?? 'Untitled';
    final excerpt = post['excerpt'] ?? '';
    final content = post['content'] ?? '';
    final authorName = post['author_name'] ?? 'Anonymous';
    final featuredImage = post['featured_image_url'];

    // Handle both String and Timestamp formats for created_at
    DateTime? createdAtDate;
    final createdAtValue = post['created_at'];
    if (createdAtValue is Timestamp) {
      createdAtDate = createdAtValue.toDate();
    } else if (createdAtValue is String) {
      try {
        createdAtDate = DateTime.parse(createdAtValue);
      } catch (e) {
        createdAtDate = null;
      }
    }

    // Generate excerpt if not provided
    String displayExcerpt = excerpt.isNotEmpty
        ? excerpt
        : (content.length > 150 ? '${content.substring(0, 150)}...' : content);

    return Card(
      margin: EdgeInsets.only(bottom: Responsive.hp(context, 2)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailScreen(
                postId: postId,
                post: post,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image
            if (featuredImage != null && featuredImage.toString().isNotEmpty)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  featuredImage,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),

            // Content
            Padding(
              padding: EdgeInsets.all(Responsive.wp(context, 4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 18,
                        tablet: 22,
                        desktop: 20,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Responsive.hp(context, 1)),

                  // Excerpt
                  if (displayExcerpt.isNotEmpty)
                    Text(
                      displayExcerpt,
                      style: TextStyle(
                        fontSize: Responsive.valueWhen(
                          context,
                          mobile: 14,
                          tablet: 16,
                          desktop: 15,
                        ),
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: Responsive.hp(context, 1.5)),

                  // Author and Date
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        authorName,
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 13,
                          ),
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        createdAtDate != null
                            ? _formatDate(createdAtDate)
                            : 'Unknown date',
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 13,
                          ),
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Responsive.hp(context, 1)),

                  // Read More
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Read More',
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 15,
                          ),
                          color: const Color(0xFF2f2c6d),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: const Color(0xFF2f2c6d),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
