import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imagefirebaseupload/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

//FirebaseAuth.instance.currentUser.uid
class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // <2> Pass `Future<QuerySnapshot>` to future
// var FirebaseUser user = await auth.currentUser();
// final userid = user.uid;
      future: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .get(),
      builder: (context, futureSnapshot) {
        // <3> Retrieve `List<DocumentSnapshot>` from snapshot
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder<QuerySnapshot<Object?>>(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .get()
                .asStream(),
            builder: (ctx, snapshot) {
              var documents = snapshot.data!.docs;
              print(documents);
              return ListView.builder(
                reverse: true,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  //  print(documents.length);
                  return MessageBubble(
                    documents[index]['text'],
                    documents[index]['username'],
                    documents[index]['userimage'],
                    documents[index]['userId'] == snapshot.data!.docs,
                    key: ValueKey(documents[index].id),
                  );
                },
              );
            });
      },
    );
  }
}



    //     FutureBuilder(
    //   stream:FirebaseFirestore.instance.,
    //   builder: (ctx, chatSnapshot) {
    //     if (chatSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     final chatDocs = chatSnapshot.data;
    //     return ListView.builder(
    //       reverse: true,
    //       itemCount: chatDocs.length,
    //       itemBuilder: (ctx, index) {
    //         return Text(chatDocs[index]['text']);
    //       },
    //     );
    //   },
    // );

    // FutureBuilder<QuerySnapshot>(
    //     // <2> Pass `Future<QuerySnapshot>` to future
    //     future: FirebaseFirestore.instance
    //         .collection('chat')
    //         .orderBy('createdAt', descending: true)
    //         .get(),
    //     builder: (context, snapshot) {
    //       // <3> Retrieve `List<DocumentSnapshot>` from snapshot
    //       final List<DocumentSnapshot> documents = snapshot.data!.docs;

    //       return ListView.builder(
    //         reverse: true,
    //         itemCount: documents.length,
    //         itemBuilder: (context, index) {
    //           //print(documents.length);
    //           return Text(documents[index]['text']);
    //         },
    //       );
    //     })