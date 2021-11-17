import 'package:edq/shared/constants.dart';
import 'package:flutter/material.dart';

class SingleItem extends StatelessWidget {
  final String category;
  final String itemDesc;
  final String image;
  SingleItem({
    this.itemDesc,
    this.category,
    this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 230,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image != null
                      ? NetworkImage('$image')
                      : AssetImage('assets/no-image.jpg'), //assets/$image'
                ),
              ),
            ),
            Container(
              height: 70,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 175,
                    height: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(itemDesc,
                            style: listStyle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                        Text(
                          'Category: ${titleCase(category.toLowerCase())}',
                          textAlign: TextAlign.left,
                          style: listStyle.copyWith(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //For No Image
    // return Card(
    //   child: Container(
    //     width: double.infinity,
    //     padding: EdgeInsets.only(
    //         left: screenSize.width * .05, right: screenSize.width * .05),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Text(
    //               itemDesc,
    //               style: listStyle.copyWith(fontSize: 20),
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             Text(
    //               'Category: ${titleCase(category.toLowerCase())}',
    //               textAlign: TextAlign.left,
    //               style: listStyle.copyWith(
    //                 fontSize: 12,
    //                 color: Colors.grey[700],
    //               ),
    //             )
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

// ignore: must_be_immutable
class SingleCart extends StatelessWidget {
  final String clientName;
  final String cleintContact;
  final String address;
  final int totalQuantity;
  final int uniqueProduct;
  final double total;
  SingleCart({
    this.clientName,
    this.cleintContact,
    this.address,
    this.totalQuantity,
    this.uniqueProduct,
    this.total,
  });

  Widget _buildCartInfo() {
    return Container(
      height: screenSize.height * .12,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  clientName.toLowerCase().capitalizeFirstofEach,
                  style: appBar,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                  ),
                  onTap: () {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cleintContact,
                  style: bodyText.copyWith(letterSpacing: 0),
                ),
                Text(
                  totalQuantity <= 1
                      ? '${totalQuantity.toString()} item'
                      : '${totalQuantity.toString()} items',
                  style: bodyText.copyWith(letterSpacing: 0),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 4),
              width: screenSize.width * .8,
              height: screenSize.height * .05,
              child: Text(
                address.toLowerCase().capitalizeFirstofEach,
                style: bodyText.copyWith(
                  letterSpacing: 0,
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Row(
      children: [
        Container(
          width: 2,
        ),
        Container(
          height: 80,
          width: 90,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/no-image.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }

  Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCartInfo(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              uniqueProduct <= 0
                  ? Container(
                      width: screenSize.width * .8,
                      height: screenSize.height * .1,
                    )
                  : _buildImage(),
              uniqueProduct <= 1 ? Text('') : _buildImage(),
              uniqueProduct <= 2 ? Text('') : _buildImage(),
              uniqueProduct <= 3 ? Text('') : _buildImage(),
              uniqueProduct <= 4 ? Text('') : Text('...'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  '₱${total.toStringAsFixed(2)}',
                  style: roboto.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0,
                    color: customColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
