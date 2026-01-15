import 'package:flutter/material.dart';
import '../../core/utils/responsive.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: const Color(0xFF2f2c6d),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'About Us',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                color: const Color(0xFF2f2c6d),
                child: Center(
                  child: Icon(
                    Icons.info_outline,
                    size: 60,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
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
                  // Hero Card
                  _buildHeroCard(context),

                  SizedBox(height: Responsive.hp(context, 3)),

                  // About Content
                  _buildAboutContent(context),

                  SizedBox(height: Responsive.hp(context, 3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.teal.shade700,
            Colors.teal.shade500,
            Colors.cyan.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(Responsive.wp(context, 6)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo or Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 48,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: Responsive.hp(context, 2)),

                // Title
                Text(
                  'DUAAB\'89',
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 32,
                      tablet: 40,
                      desktop: 48,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                SizedBox(height: Responsive.hp(context, 1)),

                // Subtitle
                Text(
                  'Dhaka University Alumni Association',
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: Responsive.hp(context, 0.5)),

                Text(
                  'Batch 1989',
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 18,
                    ),
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                SizedBox(height: Responsive.hp(context, 2)),

                // Year badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Founded 2013',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(Responsive.wp(context, 5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Our Story',
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 22,
                      tablet: 26,
                      desktop: 28,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),

            SizedBox(height: Responsive.hp(context, 2.5)),

            // First Paragraph
            _buildParagraph(
              context,
              'Dhaka University Alumni Association, Batch 1989 (DUAAB\'89) was founded in 2013, rooted in a shared sense of belonging that took shape within the historic walls of Curzon Hall. What started as a conversation among a few committed alumni soon became a collective effort to reconnect classmates, preserve shared memories, and uphold the values instilled by the University of Dhaka.',
            ),

            SizedBox(height: Responsive.hp(context, 2)),

            // Second Paragraph
            _buildParagraph(
              context,
              'The association\'s early momentum was marked by the first Family Day in 2013, a gathering that brought alumni and their families together and set the tone for a community built on warmth, trust, and continuity. With the formation of its first Executive Committee, DUAAB\'89 began operating as a structured and forward-looking platform.',
            ),

            SizedBox(height: Responsive.hp(context, 2)),

            // Third Paragraph
            _buildParagraph(
              context,
              'A defining moment came in 2014, when the association broadened its scope to include alumni from the Arts and Commerce faculties. This decision reflected a deeper vision of inclusivity and unity across disciplines, transforming DUAAB\'89 into more than a batch-based group. Today, it stands as a living network that celebrates the legacy of Dhaka University, strengthens lifelong connections, and remains committed to contributing meaningfully to society through collective action and shared purpose.',
            ),

            SizedBox(height: Responsive.hp(context, 3)),

            // Key Milestones Section
            _buildMilestonesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(BuildContext context, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Responsive.valueWhen(
          context,
          mobile: 15,
          tablet: 16,
          desktop: 17,
        ),
        height: 1.6,
        color: Colors.grey.shade700,
        letterSpacing: 0.2,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildMilestonesSection(BuildContext context) {
    final milestones = [
      {
        'year': '2013',
        'title': 'Foundation',
        'description': 'DUAAB\'89 was established',
      },
      {
        'year': '2013',
        'title': 'First Family Day',
        'description': 'Inaugural gathering of alumni and families',
      },
      {
        'year': '2014',
        'title': 'Expansion',
        'description': 'Included Arts and Commerce faculties',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Key Milestones',
              style: TextStyle(
                fontSize: Responsive.valueWhen(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 26,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        SizedBox(height: Responsive.hp(context, 2)),
        ...milestones.map((milestone) => _buildMilestoneItem(
              context,
              year: milestone['year']!,
              title: milestone['title']!,
              description: milestone['description']!,
            )),
      ],
    );
  }

  Widget _buildMilestoneItem(
    BuildContext context, {
    required String year,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Year badge
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.teal.shade600,
                  Colors.teal.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                year,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
