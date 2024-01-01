

// class AudioMessage extends StatelessWidget {
//   const AudioMessage({Key? key, this.message}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.55,
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 8,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5),
//         color: context.theme.colorScheme.primary
//             .withOpacity(message!.isSender ? 1 : 0.1),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.play_arrow,
//             color: message!.isSender
//                 ? Colors.white
//                 : context.theme.colorScheme.primary,
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16 / 2),
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 2,
//                     color: message!.isSender
//                         ? Colors.white
//                         : context.theme.colorScheme.primary.withOpacity(0.4),
//                   ),
//                   Positioned(
//                     left: 0,
//                     child: Container(
//                       height: 8,
//                       width: 8,
//                       decoration: BoxDecoration(
//                         color: message!.isSender
//                             ? Colors.white
//                             : context.theme.colorScheme.primary,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Text(
//             "0.37",
//             style: TextStyle(
//                 fontSize: 12, color: message!.isSender ? Colors.white : null),
//           ),
//         ],
//       ),
//     );
//   }
// }
