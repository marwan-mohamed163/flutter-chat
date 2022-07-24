import 'package:chat_app/modal/Room.dart';
import 'package:chat_app/roomsDetails/RoomsDetails.dart';
import 'package:flutter/material.dart';
class RoomWidget extends StatelessWidget {
  late Room room;
  RoomWidget(this.room);
  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: (){
          Navigator.of(context).pushNamed(RoomDetails.ROUTE_NAME,arguments: RoomDetailsArg(room));
        },
        child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 4,
                offset: Offset(4, 8), // Shadow position
              ),
            ]
        ),
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/${room.category}.png'),fit: BoxFit.fitHeight,width: double.infinity,),
            Text(room.name,style: TextStyle(fontSize: 24),)
          ],
        ),
    ),
      );
  }
}
