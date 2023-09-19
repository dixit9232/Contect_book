import 'dart:io';

import 'package:contect_book_using_hive_database/contect_data.dart';
import 'package:contect_book_using_hive_database/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Contect_add extends StatefulWidget {
  Contect_Data? cd;

  Contect_add([this.cd]);

  @override
  State<Contect_add> createState() => _Contect_addState();
}

class _Contect_addState extends State<Contect_add> {
  TextEditingController name_controller = TextEditingController();
  TextEditingController contect_controller = TextEditingController();
  var gender = "None";
  File? file;
  var image;
  var cropImage;

  get_image() async {
    image = await ImagePicker().pickImage(source: ImageSource.camera);
    await Future.delayed(Duration.zero);
    if (image != null) {
      cropImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
      );
    }
    if (cropImage != null) {
      setState(() {
        file = File(cropImage.path);
      });
    }
  }

  select_image() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    await Future.delayed(Duration.zero);
    if (image != null) {
      cropImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
      );
    }
    if (cropImage != null) {
      setState(() {
        file = File(cropImage.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.cd != null) {
      name_controller.text = widget.cd!.name!;
      contect_controller.text = widget.cd!.contect!;
      gender = widget.cd!.gender!;
      if (widget.cd!.cropImage != "null") {
        cropImage = widget.cd!.cropImage;
        file = File(cropImage);
      }
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return Contect_List();
                              },
                            ), (route) => true);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 35,
                            color: Colors.black,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.5),
                        splashColor: Colors.transparent,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Colors.transparent,
                                title: const Text("Choose Option",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white)),
                                content: SizedBox(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          get_image();
                                          Navigator.pop(context);
                                        },
                                        child: const Card(
                                          elevation: 10,
                                          color: Colors.white70,
                                          shadowColor: Colors.grey,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Camera",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          select_image();
                                          Navigator.pop(context);
                                        },
                                        child: const Card(
                                          elevation: 10,
                                          color: Colors.white70,
                                          shadowColor: Colors.grey,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Gallary",
                                                style: TextStyle(fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              image: (file != null)
                                  ? DecorationImage(
                                      image: FileImage(file!), fit: BoxFit.fill)
                                  : null),
                          child: (file == null)
                              ? Icon(Icons.add_a_photo,
                                  size: 120, color: Colors.black45)
                              : null,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: name_controller,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                          color: Colors.black, fontSize: 20),
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),
                            allow: true)
                      ],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: contect_controller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: 20, color: Colors.black),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelText: "Contect",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 35,
                            color: Colors.grey,
                          )),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          fillColor:
                              MaterialStatePropertyAll(Colors.black),
                          value: "Male",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "Male",
                          style: TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          fillColor:
                              MaterialStatePropertyAll(Colors.black),
                          value: "Female",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "Female",
                          style: TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          fillColor:
                              MaterialStatePropertyAll(Colors.black),
                          value: "Other",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "Other",
                          style: TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          fillColor:
                              MaterialStatePropertyAll(Colors.black),
                          value: "None",
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value!;
                            });
                          },
                        ),
                        Text(
                          "None",
                          style: TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(Size(
                            MediaQuery.of(context).size.width * 0.95,
                            MediaQuery.of(context).size.height * 0.06)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      if (name_controller.text != "" &&
                          contect_controller != "") {
                        if (widget.cd != null) {
                          widget.cd!.name = name_controller.text;
                          widget.cd!.contect = contect_controller.text;
                          widget.cd!.gender = gender;

                          if (widget.cd!.cropImage != "null") {
                            if (widget.cd!.cropImage != cropImage.toString()) {
                              widget.cd!.cropImage = cropImage.path.toString();
                            } else {
                              widget.cd!.cropImage = cropImage;
                            }
                          } else {
                            String cropimage = (cropImage == null)
                                ? cropImage.toString()
                                : cropImage.path.toString();
                            widget.cd!.cropImage = cropimage;
                          }
                          widget.cd!.save();
                          setState(() {
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return const Contect_List();
                              },
                            ), (route) => false);
                          });
                        } else {
                          String name = name_controller.text;
                          String contect = contect_controller.text;
                          String cropimage = (cropImage == null)
                              ? cropImage.toString()
                              : cropImage.path.toString();
                          Contect_Data cd =
                              Contect_Data(name, contect, gender, cropimage);
                          Contect_List.contect.add(cd);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Contect_List();
                              },
                            ),
                            (route) => false,
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Fill all required fileds");
                      }
                    },
                    child: const Text(
                      "SAVE",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
