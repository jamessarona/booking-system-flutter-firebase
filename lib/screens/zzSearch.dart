import 'package:flutter/material.dart';

class SearchScreen extends SearchDelegate<void> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

// import 'package:edq/shared/constants.dart';
// import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   final String agentCode;
//   final List products;
//   final String orderNo;
//   SearchScreen({this.agentCode, this.products, this.orderNo});
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// //design the search screen
// class _SearchScreenState extends State<SearchScreen> {
//   Size screenSize;
//   @override
//   Widget build(BuildContext context) {
//     screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: customColor[10],
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Container(
//           width: screenSize.width * .77,
//           height: screenSize.height * 0.04,
//           child: TextFormField(
//             decoration: InputDecoration(
//               filled: true,

//               fillColor: Colors.yellow[700],
//               border: InputBorder.none,
//               hintText: 'Search',
//               contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
//               suffixIcon: IconButton(
//                   icon: Icon(
//                     Icons.search,
//                     color: Colors.black,
//                   ),
//                   onPressed: () {}),
//               // contentPadding:
//               //     const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.transparent),
//                 borderRadius: BorderRadius.circular(25.7),
//               ),
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: Colors.transparent),
//                 borderRadius: BorderRadius.circular(25.7),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
