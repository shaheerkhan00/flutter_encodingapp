import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'dart:async';

class FileEncryptScreen extends StatefulWidget {
  //const FileEncryptScreen({Key? key}) : super(key: key);

  @override
  State<FileEncryptScreen> createState() => _FileEncryptScreenState();
}

class MyEncrypt {
  static final mykey = enc.Key.fromUtf8('TechwithVpTechwithVpTechwithVp12');
  static final myIv = enc.IV.fromUtf8('VivekPanchal1122');
  static final myEncrypter = enc.Encrypter(enc.AES(mykey));
}

class _FileEncryptScreenState extends State<FileEncryptScreen> {
  bool _isgranted = true;
  String filename = 'demo.mp4';
  String _videoUrl =
      "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4";
  String _pdfUrl = "";
  String _imageUrl =
      "https://commons.wikimedia.org/wiki/File:Michael_Jackson_in_1988.jpg#/media/File:Michael_Jackson_in_1988.jpg";
  String path = '/storage/emulated/0/MyencFolder';
  String _zipUrl = '';

  Future<void> get getAppDir async {
    final appDocDir = await getExternalStorageDirectory();
    //return appDocDir;
  }

  Future<Directory> get getExternalVisibleDir async {
    if (await Directory(path).exists()) {
      final externaldir = Directory(path);
      return externaldir;
    } else {
      await Directory(path).create(recursive: true);
      final externalDir = Directory(path);
      return externalDir;
    }
  }

  _downloadAndCreate(String url, Directory d, filename) async {
    if (await canLaunch(url)) {
      print('Data Downloading');
      var resp = await http.get(Uri.parse(url));
      var encResult = _encryptData(resp.bodyBytes);
      String p = await _writeData(encResult, d.path + '/$filename.aes');
      print('file encrypted succesfully: $p');
    } else {
      print("cant launch url");
    }
  }

  _getNormalFile(Directory d, filename) async {
    Uint8List encData = await _readData(d.path + '/$filename.aes');
    var plainData = await _decryptData(encData);
    String p = await _writeData(plainData, d.path + '/$filename');
    print("file decrypted successfuly : $p");
  }

  _encryptData(plainString) {
    print("Encrypting file");
    final encrypted =
        MyEncrypt.myEncrypter.encryptBytes(plainString, iv: MyEncrypt.myIv);
    return encrypted.bytes;
  }

  _decryptData(encData) {
    print("decrypting file");
    enc.Encrypted en = new enc.Encrypted(encData);
    return MyEncrypt.myEncrypter.decryptBytes(en, iv: MyEncrypt.myIv);
  }

  Future<Uint8List> _readData(fileNameWithPath) async {
    print('Reading data');
    File f = File(fileNameWithPath);
    return await f.readAsBytes();
  }

  Future<String> _writeData(dataToWrite, fileNameWithPath) async {
    print('Writing data');

    File f = File(fileNameWithPath);
    await f.writeAsBytes(dataToWrite);
    return f.absolute.toString();
  }

  requestStoragePermission() async {
    if (!await Permission.storage.isGranted) {
      PermissionStatus result = await Permission.storage.request();
      if (result.isGranted) {
        setState(() {
          _isgranted = true;
        });
      } else {
        _isgranted = false;
      }
    }
  }

  Future getStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    //PermissionStatus status1 = await Permission.accessMediaLocation.request();
    PermissionStatus status2 = await Permission.manageExternalStorage.request();
    print('status $status   -> $status2');
    if (status.isGranted && status2.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied || status2.isPermanentlyDenied) {
      await openAppSettings();
    } else if (status.isDenied) {
      print('Permission Denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    //requestStoragePermission();
    getStoragePermission();
    return Scaffold(
      appBar: AppBar(title: Text('Encrypt/decrypt file')),
      body: Center(
          child: Column(
        children: [
          RaisedButton(
              child: Text('Download file and encrypt'),
              onPressed: () async {
                if (_isgranted) {
                  Directory d = await getExternalVisibleDir;

                  _downloadAndCreate(_videoUrl, d, filename);
                } else {
                  print('No permission granted');
                  requestStoragePermission();
                }
              }),
          RaisedButton(
              child: Text('decrypt'),
              onPressed: () async {
                if (_isgranted) {
                  Directory d = await getExternalVisibleDir;
                  _getNormalFile(d, filename);
                } else {
                  print('no permission granted');
                  requestStoragePermission();
                }
              })
        ],
      )),
    );
  }
}
