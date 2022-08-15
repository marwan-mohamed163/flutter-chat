import 'package:chat_app/modal/Message.dart';
import 'package:chat_app/modal/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modal/User.dart';

CollectionReference<User> getUserCollectionWithConverter(){
   return FirebaseFirestore.instance.collection(User.COLLECTION_NAME)
       .withConverter<User>(
       fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
       toFirestore: (user, _) => user.toJson());
}

CollectionReference<Room> getRoomCollectionWithConverter(){
   return FirebaseFirestore.instance.collection(Room.COOLECTION_NAME)
       .withConverter<Room>(
       fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
       toFirestore: (room, _) => room.toJson());
}


CollectionReference<Message> getMessageCollectionWithConverter(roomId){
   final roomsCollection = getRoomCollectionWithConverter();
   return roomsCollection.doc(roomId).collection(Message.COOLECTION_NAME).withConverter<Message>(
       fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
       toFirestore: (message, _) => message.toJson());
}