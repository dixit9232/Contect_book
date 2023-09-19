import 'dart:io';

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
  List found_user = [];
  List User = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < Contect_List.contect.length; i++) {
      Contect_Data cd = Contect_List.contect.getAt(i);
      found_user.addAll([
        {
          "name": cd.name,
          "contect": cd.contect,
          "image": cd.cropImage,
          "gender": cd.gender
        }
      ]);
      User = found_user;
    }
  }

  Search(String keyword) {
    var result;
    if (keyword.isEmpty) {
      result = found_user;
    } else {
      result = found_user
          .where((user) => user["name"]
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      User = result;
    });
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
          body: SafeArea(
              child: (found_user.isEmpty)
                  ? Center(
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                      "image/corporate-business-communication-business-team-big-smartphone-business-people-trendy-vector_985641-305-removebg-preview.png")))),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.white54,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.05)),
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.067,
                            decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height * 0.05)),
                            child: TextField(
                                onChanged: (value) {
                                  return Search(value);
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black87,
                                        size: 30,
                                      ),
                                    ),
                                    hintText: "Search Contects",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.height *
                                                0.05)))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: User.length,
                            itemBuilder: (context, index) {
                              Contect_Data cd =
                                  Contect_List.contect.getAt(index);
                              return Slidable(
                                  startActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return Contect_add(cd);
                                              },
                                            ));
                                          },
                                          backgroundColor: Colors.green,
                                          icon: Icons.edit,
                                        )
                                      ]),
                                  endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            Contect_List.contect
                                                .deleteAt(index);
                                            User.removeAt(index);
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
                                            image: (User[index]["image"] !=
                                                    "null")
                                                ? DecorationImage(
                                                    image: FileImage(File(
                                                        User[index]["image"])))
                                                : null),
                                        child: (User[index]["image"] == "null")
                                            ? Icon(
                                                Icons.account_circle,
                                                color: Colors.grey,
                                                size: 50,
                                              )
                                            : Text("")),
                                    title: Text(
                                      "${User[index]["name"]}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    subtitle: Text(
                                        "+91 ${found_user[index]["contect"]}",
                                        style: TextStyle(color: Colors.black)),
                                  ));
                            },
                          ),
                        ),
                      ],
                    )),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
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
      ),
    );
  }
}
