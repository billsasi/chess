// import 'package:flutter/material.dart';
// import 'util.dart';

// class CapturedRow extends StatelessWidget {
//   List killedPieces;

//   CapturedRow(this.killedPieces, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//         children: killedPieces.length > 0
//             ? killedPieces.map((item) {
//                 return Container(
//                   width: 20,
//                   height: 20,
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   child: Center(
//                     child: Image.asset(
//                       getPieceImageAsset(item),
//                       height: 20,
//                       width: 20,
//                     ),
//                   ),
//                 );
//               }).toList()
//             : [
//                 Container(
//                   width: 20,
//                   height: 20,
//                   color: Color.fromARGB(255, 255, 255, 255),
//                 )
//               ]);
//   }
// }
