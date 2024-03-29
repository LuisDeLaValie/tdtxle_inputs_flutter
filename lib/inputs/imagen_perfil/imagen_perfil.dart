import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

part 'imagen_perfil_form_file.dart';
part 'imagen_perfil_widget.dart';
part 'selcet_imagen.dart';

enum TypePicker { camara, galeria, seleccionar }

class ImagenPerfil {
  final String path;
  ImagenPerfil({required this.path});
  

  @override
  String toString() => 'ImagenPerfil(path: $path)';
}

class ImagenPerfilFile extends ImagenPerfil {
  ImagenPerfilFile({required super.path});

  File getFile() => File(path);

  Future<File> mover({required String newPath, bool delete=false}) async {
    var file = File(path);
    var exist = await file.exists();

    if (exist) {
      var newFile = File(newPath);
      newFile.writeAsBytes(await file.readAsBytes());
      if (delete) await file.delete();
      return newFile;
    } else {
      throw "No se encontro la imagen\n$path";
    }
  }
}

class ImagenPerfilWeb extends ImagenPerfil {
  ImagenPerfilWeb({required super.path});

  Future<File> dowloader(String path) async {
    var isweb = RegExp(r"https*://").hasMatch(this.path);
    if (isweb) {
      var imageData = await NetworkAssetBundle(Uri.parse(this.path)).load("");
      var bytes = imageData.buffer.asUint8List();
      var newFile = await File(path).writeAsBytes(bytes);
      return newFile;
    } else {
      throw "No se reconose el formato\n$path";
    }
  }
}
