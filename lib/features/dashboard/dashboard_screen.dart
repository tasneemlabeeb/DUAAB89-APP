import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import '../alumni/alumni_list_screen.dart';
import '../events/events_list_screen.dart';
import '../about/about_screen.dart';
import '../fund/fund_screen.dart';
import '../news/news_screen.dart';
import '../gallery/gallery_screen.dart';
import '../blog/blog_list_screen.dart';
import '../auth/providers.dart';
import '../../core/utils/responsive.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % 4; // 4 images
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: _getSelectedPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2f2c6d),
        unselectedItemColor: Colors.grey.shade600,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            activeIcon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const AlumniListScreen();
      case 2:
        return const EventsListScreen();
      case 3:
        return const GalleryScreen();
      case 4:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Responsive.valueWhen(
              context,
              mobile: double.infinity,
              tablet: 700,
              desktop: 900,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Introduction
              Center(
                child: Text(
                  'Welcome to DUAAB\'89',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 24,
                      tablet: 28,
                      desktop: 26,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              SizedBox(height: Responsive.hp(context, 1)),
              Center(
                child: Text(
                  'Connecting our alumni community, sharing memories, and building a stronger future together.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 14,
                      tablet: 16,
                      desktop: 15,
                    ),
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: Responsive.hp(context, 3)),

              // Carousel Banner (replacing home card)
              _buildCarouselBanner(context),
              SizedBox(height: Responsive.hp(context, 3)),

              // Explore Everything Section Title
              Text(
                'Explore Everything',
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
              SizedBox(height: Responsive.hp(context, 2)),

              // Members & News Row
              Row(
                children: [
                  Expanded(
                    child: _buildIconCard(
                      context,
                      title: 'Members',
                      icon: Icons.people,
                      gradientColors: [
                        Colors.blue.shade400,
                        Colors.blue.shade700
                      ],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const AlumniListScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: Responsive.wp(context, 4)),
                  Expanded(
                    child: _buildIconCard(
                      context,
                      title: 'News',
                      icon: Icons.article,
                      gradientColors: [
                        Colors.green.shade400,
                        Colors.green.shade700
                      ],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NewsScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.hp(context, 2)),

              // Events & Gallery Row
              Row(
                children: [
                  Expanded(
                    child: _buildIconCard(
                      context,
                      title: 'Events',
                      icon: Icons.event,
                      gradientColors: [
                        Colors.orange.shade400,
                        Colors.orange.shade700
                      ],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const EventsListScreen()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: Responsive.wp(context, 4)),
                  Expanded(
                    child: _buildIconCard(
                      context,
                      title: 'Gallery',
                      icon: Icons.photo_library,
                      gradientColors: [
                        Colors.purple.shade400,
                        Colors.purple.shade700
                      ],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const GalleryScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.hp(context, 2)),

              // About & Fund Row
              Row(
                children: [
                  Expanded(
                    child: _buildIconCard(
                      context,
                      title: 'About',
                      icon: Icons.info,
                      gradientColors: [
                        Colors.red.shade400,
                        Colors.red.shade700
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: Responsive.wp(context, 4)),
                  Expanded(
                    child: _buildIconCard(
                      context,
                      title: 'Fund',
                      icon: Icons.volunteer_activism,
                      gradientColors: [
                        Colors.amber.shade600,
                        Colors.amber.shade800
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FundScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: Responsive.hp(context, 2)),

              // Blog Card (full width)
              _buildIconCard(
                context,
                title: 'Blog',
                icon: Icons.article,
                gradientColors: [Colors.teal.shade400, Colors.teal.shade700],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlogListScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: Responsive.hp(context, 4)),

              // Few facts about our Alumni Section
              _buildAlumniFacts(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlumniFacts(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.wp(context, 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Few facts about our Alumni',
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
          SizedBox(height: Responsive.hp(context, 2)),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  number: '1150',
                  label: 'Active Members',
                ),
              ),
              SizedBox(width: Responsive.wp(context, 4)),
              Expanded(
                child: _buildStatCard(
                  context,
                  number: '35+',
                  label: 'Years of Excellence',
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.hp(context, 2)),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  number: '50+',
                  label: 'Countries',
                ),
              ),
              SizedBox(width: Responsive.wp(context, 4)),
              Expanded(
                child: _buildStatCard(
                  context,
                  number: '112',
                  label: 'Alumni Industry',
                ),
              ),
            ],
          ),
          SizedBox(height: Responsive.hp(context, 3)),

          // Alumni Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/Few-Facts.webp',
              width: double.infinity,
              height: Responsive.valueWhen(
                context,
                mobile: 200,
                tablet: 300,
                desktop: 250,
              ),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: Responsive.valueWhen(
                    context,
                    mobile: 200,
                    tablet: 300,
                    desktop: 250,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String number,
    required String label,
  }) {
    return Container(
      height: Responsive.valueWhen(
        context,
        mobile: 110,
        tablet: 130,
        desktop: 120,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.wp(context, 3),
        vertical: Responsive.hp(context, 1.5),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 30,
                tablet: 38,
                desktop: 34,
              ),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2f2c6d),
              height: 1.1,
            ),
          ),
          SizedBox(height: Responsive.hp(context, 0.5)),
          Text(
            label,
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 13,
                tablet: 16,
                desktop: 15,
              ),
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselBanner(BuildContext context) {
    final List<String> carouselImages = [
      'assets/images/Carousel 01.jpg',
      'assets/images/Carousel 02.jpg',
      'assets/images/Carousel 03.jpg',
      'assets/images/Carousel 04.jpg',
    ];

    return Column(
      children: [
        SizedBox(
          height: Responsive.valueWhen(
            context,
            mobile: 200,
            tablet: 250,
            desktop: 220,
          ),
          child: PageView.builder(
            controller: _pageController,
            itemCount: carouselImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin:
                    EdgeInsets.symmetric(horizontal: Responsive.wp(context, 2)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image
                      Image.asset(
                        carouselImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        },
                      ),
                      // Overlay gradient for text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                      // Overlay Text
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.wp(context, 4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Where Memories Meet Tomorrow',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Responsive.valueWhen(
                                    context,
                                    mobile: 18,
                                    tablet: 22,
                                    desktop: 20,
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
                              SizedBox(height: Responsive.hp(context, 0.5)),
                              Text(
                                'Connection. Contribution. Collaboration.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Responsive.valueWhen(
                                    context,
                                    mobile: 13,
                                    tablet: 16,
                                    desktop: 14,
                                  ),
                                  color: Colors.white.withOpacity(0.95),
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: Responsive.hp(context, 2)),
        SmoothPageIndicator(
          controller: _pageController,
          count: carouselImages.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: const Color(0xFF2f2c6d),
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildLargeCard(
    BuildContext context, {
    required String title,
    required String imageAsset,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Responsive.valueWhen(
          context,
          mobile: 180,
          tablet: 220,
          desktop: 200,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 5)),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Title
              Positioned(
                left: Responsive.wp(context, 6),
                bottom: Responsive.hp(context, 2),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 28,
                      tablet: 36,
                      desktop: 36,
                    ),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        offset: Offset(2, 2),
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

  Widget _buildIconCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Responsive.valueWhen(
          context,
          mobile: 140,
          tablet: 180,
          desktop: 160,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 4)),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Responsive.valueWhen(
                context,
                mobile: 48,
                tablet: 60,
                desktop: 54,
              ),
              color: const Color(0xFF2f2c6d),
            ),
            SizedBox(height: Responsive.hp(context, 1.5)),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: Responsive.valueWhen(
                  context,
                  mobile: 16,
                  tablet: 20,
                  desktop: 18,
                ),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(
    BuildContext context, {
    required String title,
    required String imageAsset,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Responsive.valueWhen(
          context,
          mobile: 160,
          tablet: 200,
          desktop: 180,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 4)),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // Title
              Positioned(
                left: Responsive.wp(context, 4),
                bottom: Responsive.hp(context, 2),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 22,
                    ),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 8,
                        offset: Offset(1, 1),
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

  Widget _buildMediumCard(
    BuildContext context, {
    required String title,
    required String imageAsset,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Responsive.valueWhen(
          context,
          mobile: 110,
          tablet: 140,
          desktop: 120,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 4)),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // Title
              Positioned(
                left: Responsive.wp(context, 5),
                bottom: Responsive.hp(context, 2),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.valueWhen(
                      context,
                      mobile: 20,
                      tablet: 26,
                      desktop: 24,
                    ),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 8,
                        offset: Offset(1, 1),
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

  // Placeholder for Profile page
  Widget _buildProfilePage() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text('Please log in to view your profile'),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get user data or create fallback from auth
        Map<String, dynamic> userData = {};
        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          userData = userSnapshot.data!.data() as Map<String, dynamic>;
        } else {
          // Fallback: Create basic user data from auth and member data
          userData = {
            'email': user.email ?? '',
            'full_name': user.displayName ?? 'User',
            'role': 'member',
            'approval_status':
                'approved', // Will be overridden by member status
          };
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('members')
              .doc(user.uid)
              .snapshots(),
          builder: (context, memberSnapshot) {
            Map<String, dynamic>? memberData;
            if (memberSnapshot.hasData && memberSnapshot.data!.exists) {
              memberData = memberSnapshot.data!.data() as Map<String, dynamic>;
              // Debug: Print member data to see what's available
              print('📋 Member Data: $memberData');

              // Override userData with member data if users collection doesn't exist
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                userData['full_name'] =
                    memberData['full_name'] ?? userData['full_name'];
                userData['email'] = memberData['email'] ?? userData['email'];
                userData['approval_status'] = memberData['status'] ?? 'pending';
              }
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(Responsive.wp(context, 6)),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.valueWhen(
                      context,
                      mobile: double.infinity,
                      tablet: 600,
                      desktop: 500,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: Responsive.hp(context, 2)),
                      // Profile Avatar
                      CircleAvatar(
                        radius: Responsive.valueWhen(
                          context,
                          mobile: 55,
                          tablet: 70,
                          desktop: 60,
                        ),
                        backgroundColor:
                            const Color(0xFF2f2c6d).withOpacity(0.1),
                        backgroundImage: (memberData != null &&
                                memberData['photo_url'] != null &&
                                memberData['photo_url'].toString().isNotEmpty)
                            ? NetworkImage(memberData['photo_url'])
                            : null,
                        child: (memberData == null ||
                                memberData['photo_url'] == null ||
                                memberData['photo_url'].toString().isEmpty)
                            ? Icon(
                                Icons.person,
                                size: Responsive.valueWhen(
                                  context,
                                  mobile: 55,
                                  tablet: 70,
                                  desktop: 60,
                                ),
                                color: const Color(0xFF2f2c6d),
                              )
                            : null,
                      ),
                      SizedBox(height: Responsive.hp(context, 2)),

                      // User Name
                      Text(
                        userData['full_name'] ?? user.displayName ?? 'User',
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 26,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Responsive.hp(context, 0.5)),

                      // Email
                      Text(
                        userData['email'] ?? user.email ?? '',
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 15,
                            tablet: 18,
                            desktop: 16,
                          ),
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: Responsive.hp(context, 1)),

                      // Approval Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: userData['approval_status'] == 'approved'
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: userData['approval_status'] == 'approved'
                                ? Colors.green.shade300
                                : Colors.orange.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              userData['approval_status'] == 'approved'
                                  ? Icons.check_circle
                                  : Icons.pending,
                              size: 16,
                              color: userData['approval_status'] == 'approved'
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              userData['approval_status'] == 'approved'
                                  ? 'Approved Member'
                                  : 'Pending Approval',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: userData['approval_status'] == 'approved'
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 4)),

                      // Profile Information Card
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Full Name
                              _buildInfoRow(
                                icon: Icons.person_outline,
                                label: 'Full Name',
                                value: userData['full_name'] ?? 'Not provided',
                              ),
                              const Divider(height: 24),

                              // Email
                              _buildInfoRow(
                                icon: Icons.email_outlined,
                                label: 'Email',
                                value: userData['email'] ?? 'Not provided',
                              ),
                              const Divider(height: 24),

                              // Role
                              _buildInfoRow(
                                icon: Icons.shield_outlined,
                                label: 'Role',
                                value: userData['role'] == 'admin'
                                    ? 'Administrator'
                                    : 'Member',
                              ),

                              // Additional member information if available
                              if (memberData != null) ...[
                                // Hall
                                if (memberData['hall'] != null &&
                                    memberData['hall']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.home_outlined,
                                    label: 'Hall',
                                    value: memberData['hall'].toString(),
                                  ),
                                ],
                                // Batch
                                if (memberData['batch'] != null &&
                                    memberData['batch']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.school_outlined,
                                    label: 'Batch',
                                    value: memberData['batch'].toString(),
                                  ),
                                ],
                                // Department
                                if (memberData['department'] != null &&
                                    memberData['department']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.business_outlined,
                                    label: 'Department',
                                    value: memberData['department'].toString(),
                                  ),
                                ],
                                // Profession / Current Position
                                if (memberData['profession'] != null &&
                                    memberData['profession']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.work_outline,
                                    label: 'Profession',
                                    value: memberData['profession'].toString(),
                                  ),
                                ],
                                if (memberData['current_position'] != null &&
                                    memberData['current_position']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.work_outline,
                                    label: 'Current Position',
                                    value: memberData['current_position']
                                        .toString(),
                                  ),
                                ],
                                // Current Organization
                                if (memberData['current_organization'] !=
                                        null &&
                                    memberData['current_organization']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.business_outlined,
                                    label: 'Organization',
                                    value: memberData['current_organization']
                                        .toString(),
                                  ),
                                ],
                                // Current Location / Country
                                if (memberData['current_location'] != null &&
                                    memberData['current_location']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.location_on_outlined,
                                    label: 'Current Location',
                                    value: memberData['current_location']
                                        .toString(),
                                  ),
                                ],
                                if (memberData['current_country'] != null &&
                                    memberData['current_country']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.public_outlined,
                                    label: 'Country',
                                    value: memberData['current_country']
                                        .toString(),
                                  ),
                                ],
                                // Phone
                                if (memberData['phone'] != null &&
                                    memberData['phone']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.phone_outlined,
                                    label: 'Phone',
                                    value: memberData['phone'].toString(),
                                  ),
                                ],
                                // Blood Group
                                if (memberData['blood_group'] != null &&
                                    memberData['blood_group']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.bloodtype_outlined,
                                    label: 'Blood Group',
                                    value: memberData['blood_group'].toString(),
                                  ),
                                ],
                                // Date of Birth
                                if (memberData['date_of_birth'] != null &&
                                    memberData['date_of_birth']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.cake_outlined,
                                    label: 'Date of Birth',
                                    value:
                                        memberData['date_of_birth'].toString(),
                                  ),
                                ],
                                // Nick Name
                                if (memberData['nick_name'] != null &&
                                    memberData['nick_name']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const Divider(height: 24),
                                  _buildInfoRow(
                                    icon: Icons.person_pin_outlined,
                                    label: 'Nickname',
                                    value: memberData['nick_name'].toString(),
                                  ),
                                ],
                              ],

                              const Divider(height: 24),

                              // Account Created
                              _buildInfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: 'Member Since',
                                value: userData['created_at'] != null
                                    ? _formatDate(userData['created_at'])
                                    : 'Not available',
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: Responsive.hp(context, 4)),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: Responsive.valueWhen(
                          context,
                          mobile: 50,
                          tablet: 58,
                          desktop: 54,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            // Show confirmation dialog
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                    'Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );

                            if (shouldLogout == true && mounted) {
                              await ref.read(authRepositoryProvider).signOut();
                              // AuthWrapper will automatically redirect to LoginScreen
                            }
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // App Version
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF2f2c6d),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Not available';
    try {
      final DateTime date = timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.parse(timestamp.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Not available';
    }
  }
}
