import 'dart:io';
import 'dart:ui';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:contect_book_using_hive_database/contect_add.dart';
import 'package:contect_book_using_hive_database/contect_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(ContectDataAdapter());
  await Hive.openBox("Contect");
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Contect_List()));
}

class Contect_List extends StatefulWidget {
  const Contect_List({super.key});

  static var contect = Hive.box("Contect");

  @override
  State<Contect_List> createState() => _Contect_ListState();
}

class _Contect_ListState extends State<Contect_List> {
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text("Contect Book"),
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
              child: ListView.builder(
            itemCount: Contect_List.contect.length,
            itemBuilder: (context, index) {
              Contect_Data cd = Contect_List.contect.getAt(index);
              return Card(color: Colors.transparent,
                child: Slidable(
                    startActionPane:
                        ActionPane(motion: ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Contect_add(cd);
                            },
                          ));
                        },
                        backgroundColor: Colors.green,
                        icon: Icons.edit,
                      )
                    ]),
                    endActionPane: ActionPane(motion: ScrollMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          Contect_List.contect.deleteAt(index);
                          setState(() {});
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                      )
                    ]),
                    child: ListTile(
                      leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: (cd.cropImage != "null")
                                  ? DecorationImage(
                                      image: FileImage(File(cd.cropImage)))
                                  : null),
                          child: (cd.cropImage == "null")
                              ? Icon(
                                  Icons.account_circle,
                                  size: 50,
                                )
                              : Text("")),
                      title: Text(
                        "${cd.name}",
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text("+91 ${cd.contect}"),
                    )),
              );
            },
          )),
        ),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.deepPurpleAccent.shade100,
          isExtended: true,
          elevation: 10,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Contect_add();
              },
            ));
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
