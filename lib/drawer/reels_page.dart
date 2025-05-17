import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Mock data - Replace with actual data from MongoDB
  final List<Map<String, dynamic>> _reels = [
    {
      'id': '1',
      'videoUrl': 'https://example.com/video1.mp4',
      'thumbnailUrl': 'https://picsum.photos/400/800',
      'userName': 'User 1',
      'description': 'Amazing video! #trending',
      'likes': 1200,
      'comments': 150,
      'shares': 45,
    },
    {
      'id': '2',
      'videoUrl': 'https://example.com/video2.mp4',
      'thumbnailUrl': 'https://picsum.photos/400/800',
      'userName': 'User 2',
      'description': 'Check this out! #viral',
      'likes': 800,
      'comments': 90,
      'shares': 30,
    },
    // Add more reels here
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Video Feed
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _reels.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final reel = _reels[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Video Thumbnail
                  CachedNetworkImage(
                    imageUrl: reel['thumbnailUrl'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
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
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),

                  // User Info and Description
                  Positioned(
                    bottom: 100,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@${reel['userName']}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          reel['description'],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Interaction Buttons
                  Positioned(
                    right: 16,
                    bottom: 100,
                    child: Column(
                      children: [
                        _buildInteractionButton(
                          Icons.favorite,
                          reel['likes'].toString(),
                          () {
                            // TODO: Implement like functionality
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildInteractionButton(
                          Icons.comment,
                          reel['comments'].toString(),
                          () {
                            // TODO: Implement comment functionality
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildInteractionButton(
                          Icons.share,
                          reel['shares'].toString(),
                          () {
                            // TODO: Implement share functionality
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Upload Button
          Positioned(
            right: 16,
            top: 16,
            child: FloatingActionButton(
              onPressed: () {
                // TODO: Implement video upload
              },
              backgroundColor: theme.primaryColor,
              child: const Icon(Icons.add),
            ),
          )
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 600))
          .slideX(begin: 0.5, end: 0),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(
    IconData icon,
    String count,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.white,
          onPressed: onTap,
        ),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
} 