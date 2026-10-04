// import 'package:flutter/material.dart';
// import 'package:gosmart_self_checkout/styles/colors.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
// import 'package:provider/provider.dart';

// class LoadingPercentDialog extends StatelessWidget {
//   const LoadingPercentDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         backgroundColor: Colors.transparent,
//         content: SizedBox(
//           height: 35,
//           width: MediaQuery.sizeOf(context).width * 0.25,
//           child: Center(
//             child: LinearPercentIndicator(
//               width: MediaQuery.sizeOf(context).width * 0.2,
//               lineHeight: 30.0,
//               percent: 0.5,
//               backgroundColor: Colors.white,
//               progressColor: goSmartBlue.withOpacity(0.5),
//               alignment: MainAxisAlignment.center,
//               center: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 3),
//                 child: Text(
//                   context.watch<PosProvider>().loadingPercentage.toString(),
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: goSmartBlue),
//                 ),
//               ),
//               animation: true,
//               barRadius: const Radius.circular(3),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
