import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  final picker = ImagePicker();

  Future<void> _takePicture() async {
    try {
      final selectedImageFile = await picker.getImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );
      if (selectedImageFile == null) {
        return;
      }
      final imageFile = File(selectedImageFile.path);

      setState(() {
        _storedImage = imageFile;
      });

      final fileName = path.basename(imageFile.path);
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      widget.onSelectImage(savedImage);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Take Picture"),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
