import 'package:chat_app/modal/Room.dart';
import 'package:flutter/material.dart';

class RoomDetails extends StatelessWidget{
  static const String ROUTE_NAME = 'rooms-Details';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as RoomDetailsArg;
    return Container();
  }
}
 class RoomDetailsArg{
  Room? room;
  RoomDetailsArg(this.room);
 }