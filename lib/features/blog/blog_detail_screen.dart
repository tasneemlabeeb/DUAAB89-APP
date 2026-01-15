import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/responsive.dart';

class BlogDetailScreen extends StatelessWidget {
  final String postId;
  final Map<String, dynamic> post;

  const BlogDetailScreen({
    super.key,
    required this.postId,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final title = post['title'] ?? 'Untitled';
    final content = post['content'] ?? '';
    final authorName = post['author_name'] ?? 'Anonymous';
    final featuredImage = post['featured_image_url'];

    // Handle created_at - can be either Timestamp or String
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

    final tags = post['tags'] as List<dynamic>?;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Blog Post'),
        backgroundColor: const Color(0xFF2f2c6d),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image
            if (featuredImage != null && featuredImage.toString().isNotEmpty)
              Stack(
                children: [
                  Image.network(
                    featuredImage,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                  // Gradient overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // Content Section
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
                        mobile: 24,
                        tablet: 28,
                        desktop: 26,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 2)),

                  // Author and Date
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF2f2c6d),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName,
                              style: TextStyle(
                                fontSize: Responsive.valueWhen(
                                  context,
                                  mobile: 14,
                                  tablet: 16,
                                  desktop: 15,
                                ),
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            const SizedBox(height: 2),
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
                      ),
                    ],
                  ),

                  // Tags
                  if (tags != null && tags.isNotEmpty) ...[
                    SizedBox(height: Responsive.hp(context, 2)),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) {
                        return Chip(
                          label: Text(
                            tag.toString(),
                            style: TextStyle(
                              fontSize: Responsive.valueWhen(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 13,
                              ),
                              color: const Color(0xFF2f2c6d),
                            ),
                          ),
                          backgroundColor:
                              const Color(0xFF2f2c6d).withOpacity(0.1),
                          side: BorderSide(
                            color: const Color(0xFF2f2c6d).withOpacity(0.3),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  SizedBox(height: Responsive.hp(context, 3)),
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: Responsive.hp(context, 3)),

                  // Content
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 16,
                        tablet: 18,
                        desktop: 17,
                      ),
                      color: Colors.grey.shade800,
                      height: 1.8,
                      letterSpacing: 0.2,
                    ),
                  ),

                  SizedBox(height: Responsive.hp(context, 4)),
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
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
