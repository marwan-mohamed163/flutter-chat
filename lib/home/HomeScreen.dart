import 'package:chat_app/addRoom/AddRoom.dart';
import 'package:chat_app/dataBase/DataBaseHelper.dart';
import 'package:chat_app/home/RoomWidget.dart';
import 'package:chat_app/roomsDetails/RoomsDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../modal/Room.dart';

class HomeScreen extends StatelessWidget{
  late CollectionReference <Room> roomCollectionRef;
  HomeScreen(){
      roomCollectionRef = getRoomCollectionWithConverter();
      }
  static const String ROUTE_NAME ='home';
  @override
  Widget build(BuildContext context) {
    return
     Stack(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            color: Colors.white,
          ),
          Image(image: AssetImage('assets/images/BackGround.png'),
            fit: BoxFit.fill,width: double.infinity,),
          Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.pushNamed(context, AddRoom.ROUTE_NAME);
              },
              child: Icon(Icons.add),
            ),
            appBar: AppBar(title: Text('Room Chat'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body:Container(
              margin: EdgeInsets.only(left: 12,right: 12,top: 64,bottom: 12),
              child: FutureBuilder<QuerySnapshot<Room> > (
                future: roomCollectionRef.get(),
                builder:  (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Room>> snapshot){
                  if(snapshot.hasError){
                    return Text('Data has Error');
                  }else  if (snapshot.connectionState == ConnectionState.done) {
                  final List<Room> roomsList = snapshot.data?.docs.map((singleDoc) =>singleDoc.data()).toList()??[];
                    return Center(
                      child: GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        childAspectRatio: 1/1.2
                      ),
                          itemBuilder: (buildContext,index){
                        return RoomWidget(roomsList[index]);
                          },itemCount: roomsList.length,),
                    );
                  }
                  return Center(child:CircularProgressIndicator(),);
                },
              )
            )  ,
          )
        ],

    );
  }
}