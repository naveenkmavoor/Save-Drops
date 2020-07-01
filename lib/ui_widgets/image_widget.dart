import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Image_Widget extends StatefulWidget {
  @override
  _Image_WidgetState createState() => _Image_WidgetState();
}

class _Image_WidgetState extends State<Image_Widget> {
  File _imageFile;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              backgroundImage: AssetImage('assets/user.png'),
            ),
            Padding(
              padding: EdgeInsets.only(left: 80, top: 65),
              child: MaterialButton(
                shape: new CircleBorder(),
                onPressed: () => _showImageSelect(context),
                color: Color(0xff09A603),
                child: new Icon(
                  Icons.camera_alt,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        _imageFile == null ? Text('Please select an image') : Container()
      ],
    );
  }

  Future<Null> _showImageSelect(context) {
    return showModalBottomSheet(  
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black,
            height: 150,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  child: Container(
                    child: Text('Camera'),
                    height: 50,
                    width: 400,
                    alignment: Alignment.center,
                  ),
                  onPressed: () => _getImage(context, ImageSource.camera),
                ),
                SizedBox(
                  height: 5,
                ),
                MaterialButton(
                    child: Container(
                      child: Text('Gallery'),
                      height: 50,
                      width: 400,
                      alignment: Alignment.center,
                    ),
                    onPressed: () => _getImage(context, ImageSource.gallery)),
              ],
            ),
          );
        });
  }

  void _getImage(context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      Navigator.pop(context);
    });
  }
}
