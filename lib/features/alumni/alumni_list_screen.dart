import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/member.dart';
import '../../core/utils/responsive.dart';

class AlumniListScreen extends ConsumerStatefulWidget {
  const AlumniListScreen({super.key});

  @override
  ConsumerState<AlumniListScreen> createState() => _AlumniListScreenState();
}

class _AlumniListScreenState extends ConsumerState<AlumniListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  String _selectedDepartment = 'All';
  String _selectedHall = 'All';
  String _selectedCity = 'All';
  String _selectedCountry = 'All';
  String _selectedBloodGroup = 'All';
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Members Directory'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(Responsive.wp(context, 4)),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, department, or location...',
                    hintStyle: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 15,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showFilters ? Icons.filter_list : Icons.filter_list_outlined,
                        color: _showFilters ? Colors.teal.shade700 : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
                      borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: Responsive.hp(context, 1.5),
                      horizontal: Responsive.wp(context, 4),
                    ),
                  ),
                ),
                if (_showFilters) ...[
                  SizedBox(height: Responsive.hp(context, 2)),
                  // Department Filter
                  _buildFilterSection(
                    'Department / Institute',
                    _selectedDepartment,
                    [
                      'All',
                      'CSE',
                      'EEE',
                      'Physics',
                      'Chemistry',
                      'Mathematics',
                      'Statistics',
                      'Economics',
                      'Law',
                      'Business',
                      'English',
                      'Other'
                    ],
                    (value) => setState(() => _selectedDepartment = value),
                  ),
                  const SizedBox(height: 12),
                  // Hall Filter
                  _buildFilterSection(
                    'Hall',
                    _selectedHall,
                    [
                      'All',
                      'Shahidullah Hall',
                      'Salimullah Muslim Hall',
                      'Fazlul Huq Muslim Hall',
                      'Haji Muhammad Muhsin Hall',
                      'Jagannath Hall',
                      'Surja Sen Hall',
                      'Bangabandhu Hall',
                      'Kabi Jasimuddin Hall',
                      'Rokeya Hall',
                      'Bangladesh-Kuwait Maitree Hall',
                      'Other'
                    ],
                    (value) => setState(() => _selectedHall = value),
                  ),
                  const SizedBox(height: 12),
                  // City Filter (showing common cities)
                  _buildFilterSection(
                    'Present City',
                    _selectedCity,
                    [
                      'All',
                      'Dhaka',
                      'Chittagong',
                      'Sylhet',
                      'Khulna',
                      'Rajshahi',
                      'Rangpur',
                      'Barisal',
                      'New York',
                      'London',
                      'Toronto',
                      'Sydney',
                      'Dubai',
                      'Other'
                    ],
                    (value) => setState(() => _selectedCity = value),
                  ),
                  const SizedBox(height: 12),
                  // Country Filter
                  _buildFilterSection(
                    'Country',
                    _selectedCountry,
                    [
                      'All',
                      'Bangladesh',
                      'USA',
                      'UK',
                      'Canada',
                      'Australia',
                      'UAE',
                      'Saudi Arabia',
                      'Malaysia',
                      'Singapore',
                      'Germany',
                      'Other'
                    ],
                    (value) => setState(() => _selectedCountry = value),
                  ),
                  const SizedBox(height: 12),
                  // Blood Group Filter
                  _buildFilterSection(
                    'Blood Group',
                    _selectedBloodGroup,
                    [
                      'All',
                      'A+',
                      'A-',
                      'B+',
                      'B-',
                      'AB+',
                      'AB-',
                      'O+',
                      'O-'
                    ],
                    (value) => setState(() => _selectedBloodGroup = value),
                  ),
                  const SizedBox(height: 12),
                  // Clear Filters Button
                  if (_selectedDepartment != 'All' ||
                      _selectedHall != 'All' ||
                      _selectedCity != 'All' ||
                      _selectedCountry != 'All' ||
                      _selectedBloodGroup != 'All')
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedDepartment = 'All';
                          _selectedHall = 'All';
                          _selectedCity = 'All';
                          _selectedCountry = 'All';
                          _selectedBloodGroup = 'All';
                        });
                      },
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear All Filters'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                      ),
                    ),
                ],
              ],
            ),
          ),
          // Members List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('members')
                  .where('status', isEqualTo: 'approved')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading members',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            snapshot.error.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No members found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Convert to Member objects and filter
                List<Member> members = snapshot.data!.docs
                    .map((doc) => Member.fromFirestore(
                          doc.data() as Map<String, dynamic>,
                          doc.id,
                        ))
                    .where((member) {
                      // Search filter
                      final matchesSearch = _searchQuery.isEmpty ||
                          member.fullName.toLowerCase().contains(_searchQuery) ||
                          (member.nickName?.toLowerCase().contains(_searchQuery) ?? false) ||
                          (member.department?.toLowerCase().contains(_searchQuery) ?? false) ||
                          (member.currentLocation?.toLowerCase().contains(_searchQuery) ?? false) ||
                          (member.currentOrganization?.toLowerCase().contains(_searchQuery) ?? false);

                      // Department filter
                      final matchesDepartment = _selectedDepartment == 'All' ||
                          member.department == _selectedDepartment;

                      // Hall filter
                      final matchesHall = _selectedHall == 'All' ||
                          member.hall == _selectedHall;

                      // City filter - extract city from currentLocation
                      final matchesCity = _selectedCity == 'All' ||
                          (member.currentLocation?.contains(_selectedCity) ?? false);

                      // Country filter - extract from currentLocation or use heuristics
                      final matchesCountry = _selectedCountry == 'All' ||
                          _checkCountryMatch(member.currentLocation, _selectedCountry);

                      // Blood group filter
                      final matchesBloodGroup = _selectedBloodGroup == 'All' ||
                          member.bloodGroup == _selectedBloodGroup;

                      return matchesSearch && matchesDepartment && matchesHall && 
                             matchesCity && matchesCountry && matchesBloodGroup;
                    })
                    .toList();

                // Sort alphabetically by full name
                members.sort((a, b) => a.fullName.compareTo(b.fullName));

                if (members.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No members match your search',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return _buildMemberCard(members[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: Colors.teal.shade700,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.teal.shade700 : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildMemberCard(Member member) {
    return Card(
      margin: EdgeInsets.only(bottom: Responsive.hp(context, 1.5)),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
      ),
      child: InkWell(
        onTap: () {
          _showMemberDetails(member);
        },
        borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
        child: Padding(
          padding: EdgeInsets.all(Responsive.wp(context, 4)),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: Responsive.valueWhen(
                  context,
                  mobile: 28,
                  tablet: 35,
                  desktop: 30,
                ),
                backgroundColor: Colors.teal.shade100,
                backgroundImage: member.photoUrl != null
                    ? NetworkImage(member.photoUrl!)
                    : null,
                child: member.photoUrl == null
                    ? Text(
                        member.fullName.isNotEmpty
                            ? member.fullName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 22,
                            tablet: 28,
                            desktop: 24,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: Responsive.wp(context, 4)),
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.displayName,
                      style: TextStyle(
                        fontSize: Responsive.valueWhen(
                          context,
                          mobile: 15,
                          tablet: 18,
                          desktop: 16,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (member.department != null) ...[
                      SizedBox(height: Responsive.hp(context, 0.5)),
                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            size: Responsive.valueWhen(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 14,
                            ),
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: Responsive.wp(context, 1)),
                          Flexible(
                            child: Text(
                              member.department!,
                              style: TextStyle(
                                fontSize: Responsive.valueWhen(
                                  context,
                                  mobile: 13,
                                  tablet: 15,
                                  desktop: 14,
                                ),
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (member.currentLocation != null) ...[
                      SizedBox(height: Responsive.hp(context, 0.5)),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: Responsive.valueWhen(
                              context,
                              mobile: 14,
                              tablet: 16,
                              desktop: 14,
                            ),
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: Responsive.wp(context, 1)),
                          Expanded(
                            child: Text(
                              member.currentLocation!,
                              style: TextStyle(
                                fontSize: Responsive.valueWhen(
                                  context,
                                  mobile: 13,
                                  tablet: 15,
                                  desktop: 14,
                                ),
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberDetails(Member member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Avatar and Name
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.teal.shade100,
                            backgroundImage: member.photoUrl != null
                                ? NetworkImage(member.photoUrl!)
                                : null,
                            child: member.photoUrl == null
                                ? Text(
                                    member.fullName.isNotEmpty
                                        ? member.fullName[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade700,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            member.fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (member.nickName != null &&
                              member.nickName != member.fullName) ...[
                            const SizedBox(height: 4),
                            Text(
                              '(${member.nickName})',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Details
                    _buildDetailRow(Icons.email, 'Email', member.email),
                    if (member.phone != null)
                      _buildDetailRow(Icons.phone, 'Phone', member.phone!),
                    if (member.department != null)
                      _buildDetailRow(Icons.school, 'Department', member.department!),
                    if (member.hall != null)
                      _buildDetailRow(Icons.home, 'Hall', member.hall!),
                    if (member.batch != null)
                      _buildDetailRow(Icons.calendar_today, 'Batch', member.batch!),
                    if (member.bloodGroup != null)
                      _buildDetailRow(Icons.bloodtype, 'Blood Group', member.bloodGroup!),
                    if (member.currentOrganization != null)
                      _buildDetailRow(Icons.business, 'Organization', member.currentOrganization!),
                    if (member.currentPosition != null)
                      _buildDetailRow(Icons.work, 'Position', member.currentPosition!),
                    if (member.currentLocation != null)
                      _buildDetailRow(Icons.location_on, 'Location', member.currentLocation!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.teal.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Responsive.valueWhen(
              context,
              mobile: 13,
              tablet: 15,
              desktop: 14,
            ),
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: Responsive.hp(context, 1)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options
                .map((option) => Padding(
                      padding: EdgeInsets.only(right: Responsive.wp(context, 2)),
                      child: ChoiceChip(
                        label: Text(option),
                        selected: selectedValue == option,
                        onSelected: (_) => onChanged(option),
                        backgroundColor: Colors.white,
                        selectedColor: Colors.teal.shade700,
                        labelStyle: TextStyle(
                          color: selectedValue == option
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontSize: Responsive.valueWhen(
                            context,
                            mobile: 12,
                            tablet: 14,
                            desktop: 13,
                          ),
                          fontWeight: selectedValue == option
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: selectedValue == option
                              ? Colors.teal.shade700
                              : Colors.grey.shade300,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.wp(context, 3),
                          vertical: Responsive.hp(context, 1),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  bool _checkCountryMatch(String? location, String country) {
    if (location == null) return false;
    
    // Direct country name match
    if (location.toLowerCase().contains(country.toLowerCase())) {
      return true;
    }
    
    // Check for common variations and cities
    final countryMapping = {
      'Bangladesh': ['dhaka', 'chittagong', 'sylhet', 'khulna', 'rajshahi', 'bangladesh'],
      'USA': ['usa', 'united states', 'new york', 'california', 'texas', 'florida', 'washington'],
      'UK': ['uk', 'united kingdom', 'london', 'manchester', 'birmingham', 'england'],
      'Canada': ['canada', 'toronto', 'vancouver', 'montreal', 'ottawa'],
      'Australia': ['australia', 'sydney', 'melbourne', 'brisbane', 'perth'],
      'UAE': ['uae', 'dubai', 'abu dhabi', 'sharjah'],
      'Saudi Arabia': ['saudi', 'riyadh', 'jeddah', 'mecca'],
      'Malaysia': ['malaysia', 'kuala lumpur', 'penang'],
      'Singapore': ['singapore'],
      'Germany': ['germany', 'berlin', 'munich', 'frankfurt'],
    };
    
    final keywords = countryMapping[country];
    if (keywords != null) {
      return keywords.any((keyword) => 
        location.toLowerCase().contains(keyword.toLowerCase())
      );
    }
    
    return false;
  }
}
