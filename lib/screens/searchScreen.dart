import 'package:edq/screens/detaiItem.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/myMessage.dart';
import 'package:edq/widgets/singleCards.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String agentCode;
  final List products;
  final String orderNo;
  SearchScreen({this.agentCode, this.products, this.orderNo});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

//design the search screen
class _SearchScreenState extends State<SearchScreen> {
  Size screenSize;
  final searchWordHolder = TextEditingController();
  String searchWord;
  var filterProducts;

  List filterAll(String word) {
    int len = 0;
    for (int i = 0; i < widget.products.length; i++) {
      if (widget.products[i]['ItemDesc']
              .contains(new RegExp(word, caseSensitive: false)) ||
          widget.products[i]['ItemCode']
              .toString()
              .contains(new RegExp(word, caseSensitive: false)) ||
          widget.products[i]['Brand']
              .contains(new RegExp(word, caseSensitive: false)) ||
          widget.products[i]['Category']
              .contains(new RegExp(word, caseSensitive: false)) ||
          widget.products[i]['PartNo']
              .contains(new RegExp(word, caseSensitive: false)) ||
          widget.products[i]['Unit']
              .contains(new RegExp(word, caseSensitive: false))) {
        len++;
      }
    }

    if (len > 0) {
      var list = new List.filled(len, []);
      int x = 0;
      for (int i = 0; i < widget.products.length; i++) {
        if (widget.products[i]['ItemDesc']
                .contains(new RegExp(word, caseSensitive: false)) ||
            widget.products[i]['ItemCode']
                .toString()
                .contains(new RegExp(word, caseSensitive: false)) ||
            widget.products[i]['Brand']
                .contains(new RegExp(word, caseSensitive: false)) ||
            widget.products[i]['Category']
                .contains(new RegExp(word, caseSensitive: false)) ||
            widget.products[i]['PartNo']
                .contains(new RegExp(word, caseSensitive: false)) ||
            widget.products[i]['Unit']
                .contains(new RegExp(word, caseSensitive: false))) {
          list[x++].add(widget.products[i]);
        }
      }
      return list;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor[10],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          width: screenSize.width * .77,
          height: screenSize.height * 0.04,
          child: TextFormField(
            controller: searchWordHolder,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.yellow[700],
              border: InputBorder.none,
              hintText: 'Search',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10),
              suffixIcon: IconButton(
                padding: EdgeInsets.only(bottom: 3),
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  searchWordHolder.clear();
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25.7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(25.7),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchWord = value;
              });
              filterProducts = filterAll(searchWord);
            },
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 5.0),
          color: customColor[20],
          child: filterProducts != null
              ? GridView.builder(
                  itemCount: filterProducts[0].length,
                  itemBuilder: (ctx, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => DetailScreen(
                            brand: filterProducts[0][index]['Brand'],
                            category: filterProducts[0][index]['Category'],
                            itemCode:
                                filterProducts[0][index]['ItemCode'].toString(),
                            itemDesc: filterProducts[0][index]['ItemDesc'],
                            partNo: filterProducts[0][index]['PartNo'],
                            price: filterProducts[0][index]['Price'].toString(),
                            unit: filterProducts[0][index]['Unit'],
                            image: filterProducts[0][index]['Image'],
                            orderNo: widget.orderNo,
                          ),
                        ),
                      );
                    },
                    child: SingleItem(
                      category: filterProducts[0][index]['Category'],
                      itemDesc: filterProducts[0][index]['ItemDesc'],
                      image: filterProducts[0][index]['Image'],
                    ),
                  ),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //For No Image
                    // mainAxisSpacing: 0,
                    // childAspectRatio: 5,
                    // crossAxisCount: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8,
                    crossAxisCount: 2,
                  ),
                )
              : NoDataFound(name: '0 Result Found')),
    );
  }
}
