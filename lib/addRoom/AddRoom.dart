import 'package:chat_app/dataBase/DataBaseHelper.dart';
import 'package:chat_app/modal/Room.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRoom extends StatefulWidget {
  static final String ROUTE_NAME = 'addRoom';

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final _addRoomFormKey = GlobalKey<FormState>();

  String roomName = '';

  String desc = '';

  List<String> Categories = ['sports', 'movie', 'music'];

  String SelectedCategories = 'sports';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        Image(
          image: AssetImage('assets/images/BackGround.png'),
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('ChatApp'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(4, 8), // Shadow position
                    ),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create New Room',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Image(image: AssetImage('assets/images/imageCreateRoom.png')),
                  Form(
                    key: _addRoomFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          onChanged: (textValue) {
                            roomName = textValue;
                          },
                          decoration: InputDecoration(
                              labelText: 'Enter Room Name',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.auto),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please enter room name';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        TextFormField(
                          onChanged: (textValue) {
                            desc = textValue;
                          },
                          decoration: InputDecoration(
                              labelText: 'descreption',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.auto),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Descreption';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),

                        // isLoading?Center(child: CircularProgressIndicator(),)

                        DropdownButton(
                            onChanged: (newSelected) {
                              setState(() {
                                SelectedCategories = newSelected as String;
                              });
                            },
                            value: SelectedCategories,
                            iconSize: 24,
                            elevation: 16,
                            items: Categories.map((name) {
                              return DropdownMenuItem(
                                  value: name,
                                  child: Row(children: [
                                    Image(
                                      image: AssetImage(
                                        'assets/images/$name.png',
                                      ),
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text(name)
                                  ]));
                            }).toList()),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60))),
                            onPressed: () {
                              if (_addRoomFormKey.currentState!.validate() ==
                                  true) {
                                addRoom();
                              }
                            },
                            child: Text('Create Room')),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void addRoom() {
    final docRef = getRoomCollectionWithConverter().doc();
    Room room = Room(
        id: docRef.id,
        name: roomName,
        description: desc,
        category: SelectedCategories);
    docRef.set(room).then((value) => Fluttertoast.showToast(
        msg: 'Room add Successful', toastLength: Toast.LENGTH_LONG));
    Navigator.pop(context);
  }
}
