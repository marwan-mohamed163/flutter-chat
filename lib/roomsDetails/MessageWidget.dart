import 'package:chat_app/AppProvider.dart';
import 'package:chat_app/modal/Message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  Message message;
  MessageWidget(this.message);
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    return message == null? Container():(
        message.senderId == provider.CurrentUser?.id?
            SendMessage(message):
            ReceivedMessage(message)
    );
  }
}

class SendMessage extends StatelessWidget {
  Message message;
  SendMessage(this.message);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(message.getDateFormatted(),),
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)
            )
          ),
          child: Text(message.content,style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}

class ReceivedMessage extends StatelessWidget {
    Message message;
    ReceivedMessage(this.message);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12)
          ),
        ),
          child: Text(message.content,style: TextStyle(color: Colors.black54),),
        ),
        Text(message.getDateFormatted(),)
      ],
    );
  }
}



