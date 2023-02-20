// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:encrypt_app/myencryption.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import '../myencryption.dart';

class Mymain extends StatefulWidget {
  static const routeName = '/mymain';
  @override
  State<Mymain> createState() => _MymainState();
}

class _MymainState extends State<Mymain> {
  //const Mymain({Key? key}) : super(key: key);
  TextEditingController tec = TextEditingController();

  var encryptedtext, plaintext;
  var isdecrypt = false;

  @override
  Widget build(BuildContext context) {
    double dev_height = MediaQuery.of(context).size.height - 100;
    return Scaffold(
      appBar: AppBar(title: Text('Text Encryption via AES')),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(dev_height * 0.05),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter the text to be encrypted',
                ),
                controller: tec,
              ),
            ),
            Column(
              children: [
                Text(
                  'Entered Text :',
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.all(dev_height * 0.05),
                  child:
                      Text(plaintext == null ? 'Nothing Entered' : plaintext),
                )
              ],
            ),
            SizedBox(
              height: dev_height * 0.1,
            ),
            Column(
              children: [
                Text(
                  isdecrypt ? 'Decrypted text ' : 'Encrypted Text:',
                  style: TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.all(dev_height * 0.05),
                  child: Text(encryptedtext == null
                      ? 'Nothing to encrypt/decrypt'
                      : encryptedtext is encrypt.Encrypted
                          ? encryptedtext.base64
                          : encryptedtext),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    plaintext = tec.text;
                    setState(() {
                      isdecrypt = false;
                      encryptedtext =
                          MyEncryptionDecryption.encryptAES(plaintext);
                    });
                  },
                  child: Text('Encrypt'),
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      isdecrypt = true;
                      // plaintext = encryptedtext;
                      encryptedtext =
                          MyEncryptionDecryption.decryptAES(encryptedtext);
                    });
                  },
                  child: Text('Decrypt'),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
