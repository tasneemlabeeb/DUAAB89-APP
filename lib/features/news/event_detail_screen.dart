import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/responsive.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  final Map<String, dynamic> eventData;

  const EventDetailScreen({
    super.key,
    required this.eventId,
    required this.eventData,
  });

  @override
  Widget build(BuildContext context) {
    final title = eventData['title'] ?? 'Untitled Event';
    final description = eventData['description'] ?? '';
    final imageUrl = eventData['featured_image_url'];
    final location = eventData['location'];
    final locationUrl = eventData['location_url'];

    DateTime? eventDate;
    DateTime? eventEndDate;

    try {
      if (eventData['event_date'] is Timestamp) {
        eventDate = (eventData['event_date'] as Timestamp).toDate();
      } else if (eventData['event_date'] is String) {
        eventDate = DateTime.parse(eventData['event_date']);
      }

      if (eventData['event_end_date'] != null) {
        if (eventData['event_end_date'] is Timestamp) {
          eventEndDate = (eventData['event_end_date'] as Timestamp).toDate();
        } else if (eventData['event_end_date'] is String) {
          eventEndDate = DateTime.parse(eventData['event_end_date']);
        }
      }
    } catch (e) {
      // Handle date parsing error
    }

    final registrationForm =
        eventData['registration_form'] as Map<String, dynamic>?;
    final registrationEnabled = registrationForm?['enabled'] ?? false;

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
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                  // Date & Time Card
                  if (eventDate != null)
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Responsive.wp(context, 3)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Responsive.wp(context, 4)),
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.all(Responsive.wp(context, 3)),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2f2c6d).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                    Responsive.wp(context, 2)),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF2f2c6d),
                              ),
                            ),
                            SizedBox(width: Responsive.wp(context, 4)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eventEndDate != null
                                        ? '${DateFormat('MMM dd, yyyy').format(eventDate)} - ${DateFormat('MMM dd, yyyy').format(eventEndDate)}'
                                        : DateFormat('EEEE, MMMM dd, yyyy')
                                            .format(eventDate),
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
                                  if (eventDate.hour != 0 ||
                                      eventDate.minute != 0)
                                    Text(
                                      DateFormat('hh:mm a').format(eventDate),
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
                    ),

                  SizedBox(height: Responsive.hp(context, 2)),

                  // Location Card
                  if (location != null)
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Responsive.wp(context, 3)),
                      ),
                      child: InkWell(
                        onTap: locationUrl != null
                            ? () => _launchUrl(locationUrl)
                            : null,
                        borderRadius:
                            BorderRadius.circular(Responsive.wp(context, 3)),
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.wp(context, 4)),
                          child: Row(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.all(Responsive.wp(context, 3)),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2f2c6d).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                      Responsive.wp(context, 2)),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF2f2c6d),
                                ),
                              ),
                              SizedBox(width: Responsive.wp(context, 4)),
                              Expanded(
                                child: Text(
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
                              ),
                              if (locationUrl != null)
                                const Icon(
                                  Icons.open_in_new,
                                  color: Color(0xFF2f2c6d),
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: Responsive.hp(context, 3)),

                  // Description
                  Text(
                    'About This Event',
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 20,
                        tablet: 24,
                        desktop: 22,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: Responsive.hp(context, 1.5)),
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

                  // Registration Button
                  if (registrationEnabled) ...[
                    SizedBox(height: Responsive.hp(context, 3)),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _launchUrl('https://duaab89.org/events/$eventId');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2f2c6d),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.hp(context, 2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Responsive.wp(context, 2)),
                          ),
                        ),
                        child: Text(
                          'Register for Event',
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
                      ),
                    ),
                  ],

                  SizedBox(height: Responsive.hp(context, 2)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
