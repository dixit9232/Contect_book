import 'dart:io';

import 'package:animate_gradient/animate_gradient.dart';
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
        print("fghdgdgfdfgdgfdfgggggdggff=$cropImage");
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
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("Add Contect"),
          ),
          body: AnimateGradient(
            primaryColors: [
              Color(0xdda6c0fe),
              Color(0xffa18cd1),
              Color(0xfffbc2eb)
            ],
            secondaryColors: [
              Color(0xffa18cd1),
              Color(0xfffbc2eb),
              Color(0xdda6c0fe),
            ],
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(85),
                          splashColor: Colors.black,
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
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                                  style:
                                                      TextStyle(fontSize: 20),
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
                                        image: FileImage(file!),
                                        fit: BoxFit.fill)
                                    : null),
                            child: (file == null)
                                ? Icon(Icons.add_a_photo,
                                    size: 120, color: Colors.black54)
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
                        inputFormatters: [
                          FilteringTextInputFormatter(RegExp("[a-z A-Z 0-9]"),
                              allow: true)
                        ],
                        decoration: const InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.account_circle)),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: contect_controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelText: "Contect",
                            prefixIcon: Icon(Icons.phone)),
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
                            value: "Male",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          const Text(
                            "Male",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Female",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          const Text(
                            "Female",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Other",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          const Text(
                            "Other",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "None",
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value!;
                              });
                            },
                          ),
                          const Text(
                            "None",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.deepPurpleAccent.shade100)),
                      onPressed: () {
                        if (name_controller.text != "" &&
                            contect_controller != "") {
                          if (widget.cd != null) {
                            widget.cd!.name = name_controller.text;
                            widget.cd!.contect = contect_controller.text;
                            widget.cd!.gender = gender;

                            if (widget.cd!.cropImage != "null") {
                              if (widget.cd!.cropImage !=
                                  cropImage.toString()) {
                                widget.cd!.cropImage =
                                    cropImage.path.toString();
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
      ),
    );
  }
}
