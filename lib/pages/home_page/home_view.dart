// import 'package:cashify/widgets/custom_text_widget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final PageController _controller = PageController(initialPage: 0);
//   bool isOn = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Stack(
//         children: [
//           AnimatedContainer(
//             height: isOn ? 400 : 600,
//             width: 400,
//             color: Colors.red,
//             duration: const Duration(milliseconds: 500),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Positioned(
//               top: 0,
//               bottom: 0,
//               right: 0,
//               left: 0,
//               child: SizedBox(
//                 height: 300,
//                 width: 300,
//                 child: PageView(
//                   controller: _controller,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     Container(height: 300, width: 300, color: Colors.green),
//                     Container(height: 300, width: 300, color: Colors.blue),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _controller.animateToPage(1,
//                   duration: Duration(milliseconds: 500),
//                   curve: Curves.bounceOut); // Animate to page 2
//               isOn = true;
//               setState(() {});
//             },
//             child: Text('Animate to Page 2'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _controller.jumpToPage(0); // Jump to page 0 instantly
//               isOn = false;
//               setState(() {});
//             },
//             child: Text('Jump to Page 0'),
//           ),
//         ],
//       )),
//     );
//   }
// }
