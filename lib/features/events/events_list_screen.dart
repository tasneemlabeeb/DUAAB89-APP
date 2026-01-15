import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/responsive.dart';

class EventsListScreen extends ConsumerStatefulWidget {
  const EventsListScreen({super.key});

  @override
  ConsumerState<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends ConsumerState<EventsListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _launchWebsite(String? eventId) async {
    final url = eventId != null
        ? 'https://duaab89.com/events/$eventId'
        : 'https://duaab89.com/events';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open website')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: const Color(0xFF2f2c6d),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Photo Banner Section - Placeholder for future image
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
                // Banner image
                Image.asset(
                  'assets/images/Events-Banner.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.event,
                        size: 64,
                        color: Colors.grey.shade400,
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
                    'Events',
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
          // Events List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('events').snapshots(),
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
                          'Error loading events',
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
                            color: Colors.grey.shade600,
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 15,
                            ),
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
                          'Loading events...',
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

                // Filter published events and sort by date (newest first) on client side
                final allEvents = snapshot.data!.docs.toList();
                final events = allEvents.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['published'] == true;
                }).toList();

                events.sort((a, b) {
                  final aDate = (a.data() as Map<String, dynamic>)['event_date']
                          as String? ??
                      '';
                  final bDate = (b.data() as Map<String, dynamic>)['event_date']
                          as String? ??
                      '';
                  try {
                    return DateTime.parse(bDate)
                        .compareTo(DateTime.parse(aDate));
                  } catch (e) {
                    return 0;
                  }
                });

                // Show empty state if no published events
                if (events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy,
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
                          'No upcoming events',
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
                          'Check back later for new events',
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
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final eventDoc = events[index];
                    final event = eventDoc.data() as Map<String, dynamic>;
                    final eventId = eventDoc.id;

                    return _buildEventCard(context, event, eventId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
      BuildContext context, Map<String, dynamic> event, String eventId) {
    final title = event['title'] as String? ?? 'Untitled Event';
    final description = event['description'] as String? ?? '';
    final eventDate = event['event_date'] as String? ?? '';
    final location = event['location'] as String? ?? '';
    final featuredImageUrl = event['featured_image_url'] as String?;

    return Card(
      margin: EdgeInsets.only(bottom: Responsive.hp(context, 2)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Responsive.wp(context, 4)),
      ),
      child: InkWell(
        onTap: () => _showEventDetails(context, event, eventId),
        borderRadius: BorderRadius.circular(Responsive.wp(context, 4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            if (featuredImageUrl != null && featuredImageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Responsive.wp(context, 4)),
                  topRight: Radius.circular(Responsive.wp(context, 4)),
                ),
                child: Image.network(
                  featuredImageUrl,
                  height: Responsive.valueWhen(
                    context,
                    mobile: 200,
                    tablet: 250,
                    desktop: 220,
                  ),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: Responsive.valueWhen(
                        context,
                        mobile: 200,
                        tablet: 250,
                        desktop: 220,
                      ),
                      color: Colors.teal.shade100,
                      child: Icon(
                        Icons.event,
                        size: Responsive.valueWhen(
                          context,
                          mobile: 60,
                          tablet: 80,
                          desktop: 70,
                        ),
                        color: Colors.teal.shade300,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: Responsive.valueWhen(
                        context,
                        mobile: 200,
                        tablet: 250,
                        desktop: 220,
                      ),
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Event Details
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
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 1)),

                  // Date
                  if (eventDate.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: Responsive.valueWhen(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 17,
                          ),
                          color: Colors.teal.shade700,
                        ),
                        SizedBox(width: Responsive.wp(context, 2)),
                        Text(
                          _formatDate(eventDate),
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 15,
                            ),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                  // Location
                  if (location.isNotEmpty) ...[
                    SizedBox(height: Responsive.hp(context, 0.5)),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: Responsive.valueWhen(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 17,
                          ),
                          color: Colors.teal.shade700,
                        ),
                        SizedBox(width: Responsive.wp(context, 2)),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              fontSize: Responsive.valueWhen(
                                context,
                                mobile: 14,
                                tablet: 16,
                                desktop: 15,
                              ),
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Description Preview
                  if (description.isNotEmpty) ...[
                    SizedBox(height: Responsive.hp(context, 1.5)),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
                    ),
                  ],

                  SizedBox(height: Responsive.hp(context, 2)),

                  // View Details Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _showEventDetails(context, event, eventId),
                      icon: const Icon(Icons.info_outline),
                      label: Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 14,
                            tablet: 16,
                            desktop: 15,
                          ),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: Responsive.hp(context, 1.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Responsive.wp(context, 2)),
                        ),
                      ),
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

  void _showEventDetails(
      BuildContext context, Map<String, dynamic> event, String eventId) {
    final title = event['title'] as String? ?? 'Untitled Event';
    final description = event['description'] as String? ?? '';
    final eventDate = event['event_date'] as String? ?? '';
    final eventEndDate = event['event_end_date'] as String?;
    final location = event['location'] as String? ?? '';
    final featuredImageUrl = event['featured_image_url'] as String?;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(Responsive.wp(context, 6)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      if (featuredImageUrl != null &&
                          featuredImageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Responsive.wp(context, 3)),
                          child: Image.network(
                            featuredImageUrl,
                            height: Responsive.valueWhen(
                              context,
                              mobile: 200,
                              tablet: 300,
                              desktop: 250,
                            ),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.teal.shade100,
                                child: Icon(
                                  Icons.event,
                                  size: 80,
                                  color: Colors.teal.shade300,
                                ),
                              );
                            },
                          ),
                        ),

                      SizedBox(height: Responsive.hp(context, 2)),

                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 24,
                            tablet: 30,
                            desktop: 26,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 2)),

                      // Date
                      if (eventDate.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(Responsive.wp(context, 3)),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(
                                Responsive.wp(context, 2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Colors.teal.shade700),
                              SizedBox(width: Responsive.wp(context, 3)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Event Date',
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
                                    Text(
                                      _formatDate(eventDate),
                                      style: TextStyle(
                                        fontSize: Responsive.valueWhen(
                                          context,
                                          mobile: 16,
                                          tablet: 18,
                                          desktop: 17,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    if (eventEndDate != null &&
                                        eventEndDate.isNotEmpty)
                                      Text(
                                        'to ${_formatDate(eventEndDate)}',
                                        style: TextStyle(
                                          fontSize: Responsive.valueWhen(
                                            context,
                                            mobile: 14,
                                            tablet: 16,
                                            desktop: 15,
                                          ),
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Location
                      if (location.isNotEmpty) ...[
                        SizedBox(height: Responsive.hp(context, 2)),
                        Container(
                          padding: EdgeInsets.all(Responsive.wp(context, 3)),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(
                                Responsive.wp(context, 2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.teal.shade700),
                              SizedBox(width: Responsive.wp(context, 3)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
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
                                    Text(
                                      location,
                                      style: TextStyle(
                                        fontSize: Responsive.valueWhen(
                                          context,
                                          mobile: 16,
                                          tablet: 18,
                                          desktop: 17,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: Responsive.hp(context, 2)),

                      // Description
                      if (description.isNotEmpty) ...[
                        Text(
                          'About this event',
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 18,
                              tablet: 22,
                              desktop: 20,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: Responsive.hp(context, 1)),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: Responsive.valueWhen(
                              context,
                              mobile: 15,
                              tablet: 17,
                              desktop: 16,
                            ),
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                        ),
                      ],

                      SizedBox(height: Responsive.hp(context, 3)),

                      // Register on Website Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _launchWebsite(eventId);
                          },
                          icon: const Icon(Icons.open_in_new),
                          label: Text(
                            'Register on Website',
                            style: TextStyle(
                              fontSize: Responsive.valueWhen(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 17,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: Responsive.hp(context, 2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Responsive.wp(context, 3)),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 1)),

                      // Info text
                      Text(
                        'You will be redirected to the website to complete your registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 13,
                          ),
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
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
    } catch (e) {
      return dateString;
    }
  }
}
