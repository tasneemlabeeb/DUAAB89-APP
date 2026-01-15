import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/responsive.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedAlbumType = 'all';
  List<AlbumType> _albumTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlbumTypes();
  }

  Future<void> _loadAlbumTypes() async {
    try {
      final snapshot =
          await _firestore.collection('album_types').orderBy('order').get();

      setState(() {
        _albumTypes =
            snapshot.docs.map((doc) => AlbumType.fromFirestore(doc)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: const Color(0xFF2f2c6d),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2f2c6d),
              ),
            )
          : Column(
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
                        'assets/images/gallery-banner.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child: Icon(
                              Icons.photo_library,
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
                          'Gallery',
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
                // Album Type Filter
                if (_albumTypes.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Responsive.wp(context, 4)),
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'All'),
                          ..._albumTypes.map(
                              (type) => _buildFilterChip(type.id, type.name)),
                        ],
                      ),
                    ),
                  ),

                // Collections Grid
                Expanded(
                  child: _buildCollectionsGrid(),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterChip(String id, String label) {
    final isSelected = _selectedAlbumType == id;
    return Padding(
      padding: EdgeInsets.only(right: Responsive.wp(context, 2)),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedAlbumType = id;
          });
        },
        selectedColor: const Color(0xFF2f2c6d),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCollectionsGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('collections').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2f2c6d),
            ),
          );
        }

        final collections = snapshot.data?.docs ?? [];

        // Filter by album type if not 'all'
        final filteredCollections = _selectedAlbumType == 'all'
            ? collections
            : collections.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['albumTypeId'] == _selectedAlbumType;
              }).toList();

        if (filteredCollections.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          padding: EdgeInsets.all(Responsive.wp(context, 4)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.valueWhen(
              context,
              mobile: 2,
              tablet: 3,
              desktop: 4,
            ),
            crossAxisSpacing: Responsive.wp(context, 3),
            mainAxisSpacing: Responsive.wp(context, 3),
            childAspectRatio: 0.85,
          ),
          itemCount: filteredCollections.length,
          itemBuilder: (context, index) {
            final collection =
                filteredCollections[index].data() as Map<String, dynamic>;
            final collectionId = filteredCollections[index].id;
            return _buildCollectionCard(context, collection, collectionId);
          },
        );
      },
    );
  }

  Widget _buildCollectionCard(BuildContext context,
      Map<String, dynamic> collection, String collectionId) {
    final name = collection['name'] ?? 'Untitled';
    final description = collection['description'] ?? '';
    final photoCount = collection['photoCount'] ?? 0;
    final thumbnail = collection['thumbnail'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionPhotosScreen(
              collectionId: collectionId,
              collectionName: name,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Responsive.wp(context, 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Responsive.wp(context, 3)),
                ),
                child: thumbnail != null
                    ? Image.network(
                        thumbnail,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
            ),

            // Info
            Padding(
              padding: EdgeInsets.all(Responsive.wp(context, 3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: Responsive.valueWhen(
                        context,
                        mobile: 14,
                        tablet: 16,
                        desktop: 15,
                      ),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Responsive.hp(context, 0.5)),
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 14,
                        color: const Color(0xFF2f2c6d),
                      ),
                      SizedBox(width: Responsive.wp(context, 1)),
                      Text(
                        '$photoCount photos',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: const Color(0xFF2f2c6d).withOpacity(0.1),
      child: const Center(
        child: Icon(
          Icons.photo_library,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            'Error loading gallery',
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 17,
              ),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined,
              size: 64, color: Colors.grey.shade300),
          SizedBox(height: Responsive.hp(context, 2)),
          Text(
            'No collections available',
            style: TextStyle(
              fontSize: Responsive.valueWhen(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 17,
              ),
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// Collection Photos Screen
class CollectionPhotosScreen extends StatelessWidget {
  final String collectionId;
  final String collectionName;

  const CollectionPhotosScreen({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(collectionName),
        backgroundColor: const Color(0xFF2f2c6d),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('photos')
            .where('collectionId', isEqualTo: collectionId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading photos'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2f2c6d),
              ),
            );
          }

          final photos = snapshot.data?.docs ?? [];

          if (photos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo, size: 64, color: Colors.grey.shade300),
                  SizedBox(height: Responsive.hp(context, 2)),
                  const Text('No photos in this collection'),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(Responsive.wp(context, 2)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.valueWhen(
                context,
                mobile: 3,
                tablet: 4,
                desktop: 5,
              ),
              crossAxisSpacing: Responsive.wp(context, 2),
              mainAxisSpacing: Responsive.wp(context, 2),
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index].data() as Map<String, dynamic>;
              final url = photo['url'];

              return GestureDetector(
                onTap: () {
                  _showPhotoDialog(context, url, photo['caption']);
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Responsive.wp(context, 2)),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child:
                            const Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showPhotoDialog(BuildContext context, String url, String? caption) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(url),
            if (caption != null && caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  caption,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Album Type Model
class AlbumType {
  final String id;
  final String name;
  final int order;

  AlbumType({
    required this.id,
    required this.name,
    required this.order,
  });

  factory AlbumType.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AlbumType(
      id: doc.id,
      name: data['name'] ?? '',
      order: data['order'] ?? 0,
    );
  }
}
