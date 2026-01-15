import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/responsive.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsId;
  final Map<String, dynamic> newsData;

  const NewsDetailScreen({
    super.key,
    required this.newsId,
    required this.newsData,
  });

  @override
  Widget build(BuildContext context) {
    final title = newsData['title'] ?? 'Untitled News';
    final content = newsData['content'] ?? '';
    final imageUrl = newsData['featured_image_url'];
    final category = newsData['category'];

    DateTime? createdAt;
    try {
      if (newsData['created_at'] is Timestamp) {
        createdAt = (newsData['created_at'] as Timestamp).toDate();
      } else if (newsData['created_at'] is String) {
        createdAt = DateTime.parse(newsData['created_at']);
      }
    } catch (e) {
      // Handle date parsing error
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: const Color(0xFF2f2c6d),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/latest-news.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/latest-news.jpg',
                          fit: BoxFit.cover,
                        ),
                  Container(
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
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(Responsive.wp(context, 4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Date
                  Row(
                    children: [
                      if (category != null) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.wp(context, 3),
                            vertical: Responsive.hp(context, 1),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2f2c6d).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                Responsive.wp(context, 2)),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: Responsive.valueWhen(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 13,
                              ),
                              color: const Color(0xFF2f2c6d),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.wp(context, 3)),
                      ],
                      if (createdAt != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            SizedBox(width: Responsive.wp(context, 1)),
                            Text(
                              DateFormat('MMM dd, yyyy').format(createdAt),
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
                    ],
                  ),

                  SizedBox(height: Responsive.hp(context, 3)),

                  // Title (repeated for emphasis)
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
                    ),
                  ),

                  SizedBox(height: Responsive.hp(context, 3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
