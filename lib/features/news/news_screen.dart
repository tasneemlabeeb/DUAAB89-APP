import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'event_detail_screen.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('News & Events'),
        backgroundColor: const Color(0xFF2f2c6d),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Events', icon: Icon(Icons.event)),
            Tab(text: 'News', icon: Icon(Icons.newspaper)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEventsTab(),
          _buildNewsTab(),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('events')
          .orderBy('event_date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState('Error loading events');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        // Filter published events in the app
        final events = snapshot.data?.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['published'] == true;
            }).toList() ??
            [];

        if (events.isEmpty) {
          return _buildEmptyState('No events available', Icons.event_busy);
        }

        return ListView.builder(
          padding: EdgeInsets.all(Responsive.wp(context, 4)),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index].data() as Map<String, dynamic>;
            final eventId = events[index].id;
            return _buildEventCard(context, event, eventId);
          },
        );
      },
    );
  }

  Widget _buildNewsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('news')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState('Error loading news');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        // Filter published news in the app
        final newsItems = snapshot.data?.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['published'] == true;
            }).toList() ??
            [];

        if (newsItems.isEmpty) {
          return _buildEmptyState('No news available', Icons.article);
        }

        return ListView.builder(
          padding: EdgeInsets.all(Responsive.wp(context, 4)),
          itemCount: newsItems.length,
          itemBuilder: (context, index) {
            final news = newsItems[index].data() as Map<String, dynamic>;
            final newsId = newsItems[index].id;
            return _buildNewsCard(context, news, newsId);
          },
        );
      },
    );
  }

  Widget _buildEventCard(
      BuildContext context, Map<String, dynamic> event, String eventId) {
    final title = event['title'] ?? 'Untitled Event';
    final description = event['description'] ?? '';
    final imageUrl = event['featured_image_url'];
    final location = event['location'];

    DateTime? eventDate;
    try {
      if (event['event_date'] is Timestamp) {
        eventDate = (event['event_date'] as Timestamp).toDate();
      } else if (event['event_date'] is String) {
        eventDate = DateTime.parse(event['event_date']);
      }
    } catch (e) {
      // Handle date parsing error
    }

    return Card(
      margin: EdgeInsets.only(bottom: Responsive.hp(context, 2)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                eventId: eventId,
                eventData: event,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Responsive.wp(context, 3)),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: Responsive.hp(context, 20),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: Responsive.hp(context, 20),
                      color: const Color(0xFF2f2c6d).withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 48, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: EdgeInsets.all(Responsive.wp(context, 4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(context,
                          mobile: 18, tablet: 20, desktop: 19),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 1)),

                  // Date
                  if (eventDate != null)
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: const Color(0xFF2f2c6d)),
                        SizedBox(width: Responsive.wp(context, 2)),
                        Text(
                          DateFormat('MMM dd, yyyy').format(eventDate),
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(context,
                                mobile: 14, tablet: 16, desktop: 15),
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),

                  // Location
                  if (location != null) ...[
                    SizedBox(height: Responsive.hp(context, 0.5)),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: const Color(0xFF2f2c6d)),
                        SizedBox(width: Responsive.wp(context, 2)),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: Responsive.valueWhen(context,
                                  mobile: 14, tablet: 16, desktop: 15),
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  SizedBox(height: Responsive.hp(context, 1)),

                  // Description
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(context,
                          mobile: 14, tablet: 16, desktop: 15),
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(
      BuildContext context, Map<String, dynamic> news, String newsId) {
    final title = news['title'] ?? 'Untitled News';
    final summary = news['summary'] ?? news['content'] ?? '';
    final imageUrl = news['featured_image_url'];
    final category = news['category'];

    DateTime? createdAt;
    try {
      if (news['created_at'] is Timestamp) {
        createdAt = (news['created_at'] as Timestamp).toDate();
      } else if (news['created_at'] is String) {
        createdAt = DateTime.parse(news['created_at']);
      }
    } catch (e) {
      // Handle date parsing error
    }

    return Card(
      margin: EdgeInsets.only(bottom: Responsive.hp(context, 2)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(
                newsId: newsId,
                newsData: news,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Responsive.wp(context, 3)),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: Responsive.hp(context, 20),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: Responsive.hp(context, 20),
                      color: const Color(0xFF2f2c6d).withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.image_not_supported,
                            size: 48, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),

            Padding(
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
                            horizontal: Responsive.wp(context, 2),
                            vertical: Responsive.hp(context, 0.5),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2f2c6d).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                                Responsive.wp(context, 1)),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: Responsive.valueWhen(context,
                                  mobile: 12, tablet: 14, desktop: 13),
                              color: const Color(0xFF2f2c6d),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: Responsive.wp(context, 2)),
                      ],
                      if (createdAt != null)
                        Text(
                          DateFormat('MMM dd, yyyy').format(createdAt),
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(context,
                                mobile: 12, tablet: 14, desktop: 13),
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: Responsive.hp(context, 1)),

                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(context,
                          mobile: 18, tablet: 20, desktop: 19),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 1)),

                  // Summary
                  Text(
                    summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(context,
                          mobile: 14, tablet: 16, desktop: 15),
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF2f2c6d),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            message,
            style: TextStyle(
              fontSize: Responsive.valueWhen(context,
                  mobile: 16, tablet: 18, desktop: 17),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            message,
            style: TextStyle(
              fontSize: Responsive.valueWhen(context,
                  mobile: 16, tablet: 18, desktop: 17),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
