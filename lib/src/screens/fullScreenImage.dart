import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String username;
  final String userImage;
  final String imageUrl;
  final String tag;

  const FullScreenImage(
      {Key key, this.username, this.userImage, this.imageUrl, this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransformationController controller = TransformationController();
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          username != null && userImage != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(50),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: userImage != null
                                  ? NetworkImage(userImage)
                                  : NetworkImage(
                                      "https://www.pngkey.com/png/full/230-2301779_best-classified-apps-default-user-profile.png"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      Text(
                        username.toString(),
                        style: TextStyle(color: Colors.white),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Container(
              child: GestureDetector(
                child: Center(
                  child: Hero(
                    tag: tag,
                    child: InteractiveViewer(
                      transformationController: controller,
                      constrained: true,
                      scaleEnabled: true,
                      boundaryMargin: EdgeInsets.all(20.0),
                      minScale: 0.1,
                      maxScale: 1.6,
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                        imageUrl: imageUrl,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
