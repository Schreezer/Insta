import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:photo_view/photo_view.dart";
import "package:photo_view/photo_view_gallery.dart";

class ImageGrid extends StatelessWidget {
  final List<String> images;

  ImageGrid({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Adjust the number of grid columns here
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             ImageFullScreen(images: images, initialIndex: index)));
          },
          child: 
          Text("h "),
          // Hero(
          //   tag: 'image$index',
          //   child: Container(
          //     margin: EdgeInsets.all(2.0),
          //     child: Image.network(
          //       images[index],
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}

class ImageFullScreen extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  ImageFullScreen({Key? key, required this.images, this.initialIndex = 0})
      : super(key: key);

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => goBack(context),
        ),
      ),
      body: Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(images[index]),
              heroAttributes: PhotoViewHeroAttributes(tag: 'image$index'),
            );
          },
          itemCount: images.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
          backgroundDecoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}
