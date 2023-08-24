import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'NavBar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
class ImageViewerApp extends StatelessWidget {
  final String userId;
  final String noteId;

  ImageViewerApp({required this.userId, required this.noteId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageViewerScreen(userId: userId, noteId: noteId),
    );
  }
}

class ImageViewerScreen extends StatefulWidget {



  final String userId;
  final String noteId;

  ImageViewerScreen({required this.userId, required this.noteId});

  @override
  _ImageViewerScreenState createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  List<dynamic> imageUrls = [
  ];
  final String fetchImagesUrl = '${ApiConstants.baseUrl}fetch_images.php';

  Future<void> _fetchImages() async {
    print(["idusawere" , widget.userId,widget.noteId]);
    final userIdto = widget.userId; // Replace with the actual user ID
    final note_id = widget.noteId; // Replace with the actual user ID
    try {
      final response = await http.get(Uri.parse('$fetchImagesUrl?user_id=$userIdto&note_id=$note_id'));
      print(Uri.parse('$fetchImagesUrl?user_id=$userIdto&note_id=$note_id'));
      if (response.statusCode == 200) {
         imageUrls = jsonDecode(response.body);

        setState(() {
          imageUrls = imageUrls.map((url) => "${ApiConstants.baseUrl}"+url).toList();
        });
        print(imageUrls);
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      print('Error fetching images: $e');
      _showErrorDialog();
    }
  }
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to upload images'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  int currentIndex = 0;
  void initState() {
    super.initState();
    _fetchImages();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

        backgroundColor: Color.fromARGB(255,55, 69, 80),
        title: Text("Image Viewer"),

      ),
      body: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (details.primaryVelocity! > 0) {
            // Swipe right
            setState(() {
              currentIndex = currentIndex > 0 ? currentIndex - 1 : 0;
            });
          } else if (details.primaryVelocity! < 0) {
            // Swipe left
            setState(() {
              currentIndex = currentIndex < imageUrls.length - 1
                  ? currentIndex + 1
                  : imageUrls.length - 1;
            });
          }
        },
        child: PageView.builder(
          itemCount: imageUrls.length,
          itemBuilder: (BuildContext context, int index) {
            // return Image.network(imageUrls[index]);

            String url = imageUrls[index];

            if (_isVideoUrl(url)) {
              return _buildVideoPlayer(url);
            } else {
              return _buildImage(url);
            }




          },
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;

              print(imageUrls[index]);
            });
          },
          controller: PageController(initialPage: currentIndex),
        ),
      ),
    );

  }
  bool _isVideoUrl(String url) {
    // You need to implement the logic to check if the URL is a video URL
    // This can be done by checking the file extension or checking the URL pattern.
    // For simplicity, let's assume all URLs ending with ".mp4" are considered video URLs.
    return url.toLowerCase().endsWith('.mp4');
  }

  Widget _buildVideoPlayer(String videoUrl) {
    VideoPlayerController controller = VideoPlayerController.network(videoUrl);
    controller.initialize().then((_) {
      controller.play();
    });

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }

  Widget _buildImage(String imageUrl) {
    // For simplicity, let's assume you are using a network image.
    // You can use any other Image widget as per your requirements.
    return Image.network(imageUrl);
  }
}
