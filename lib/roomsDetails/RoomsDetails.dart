import 'package:chat_app/AppProvider.dart';
import 'package:chat_app/dataBase/DataBaseHelper.dart';
import 'package:chat_app/modal/Message.dart';
import 'package:chat_app/modal/Room.dart';
import 'package:chat_app/roomsDetails/MessageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetails extends StatefulWidget {
  static const String ROUTE_NAME = 'rooms-Details';

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  late Room room;

  String typedMessage = '';
  late TextEditingController messageController;
  late CollectionReference<Message> messageRef;
  late AppProvider provider;

  @override
  void initState() {
    super.initState();
    messageController =  TextEditingController(text: typedMessage);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as RoomDetailsArg;
    room = args.room!;
    messageRef = getMessageCollectionWithConverter(room.id);
    final Stream<QuerySnapshot<Message>> messageStream = messageRef.orderBy('time').snapshots();
    provider = Provider.of<AppProvider>(context);
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Image(
            image: AssetImage('assets/images/BackGround.png'),
            fit: BoxFit.fill,
            width: double.infinity,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(args.room!.name),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
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
                ]),
            child: Column(
              children: [
                Expanded(
                  child:
                  StreamBuilder<QuerySnapshot<Message>>(
                    stream: messageStream,
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Message>> snapshot,){
                       if(snapshot.hasError){
                      return Text(snapshot.error.toString()) ;
                      }else if(snapshot.hasData){
                         return ListView.builder(itemBuilder: (BuildContext,index){
                           return MessageWidget(snapshot.data!.docs[index].data());
                         },
                         itemCount: snapshot.data?.size,
                           reverse:false,
                         );
                       }
                       return Center(child:CircularProgressIndicator(),);
                 },
                )),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                      onChanged: (newText) {
                        typedMessage = newText;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          hintText: 'type a massage',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12)))),
                    )),
                    InkWell(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.blue),
                        child: Image.asset('assets/images/ic_send.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void sendMessage() {
    if (typedMessage.isEmpty) return;
    final newMessageObj = messageRef.doc();
    final message = Message(
        id: newMessageObj.id,
        content: typedMessage,
        senderName: provider.CurrentUser?.userName ?? '',
        senderId: provider.CurrentUser?.id??'',
        time: DateTime.now().millisecondsSinceEpoch);
    newMessageObj.set(message).then((value) {
      setState(() {
        messageController.clear();
      });
    });
  }
}

class RoomDetailsArg {
  Room? room;
  RoomDetailsArg(this.room);
}
