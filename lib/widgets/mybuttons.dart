import 'package:badges/badges.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function onPressed;
  final String name;
  final bool isLoading;
  MyButton({
    this.name,
    this.onPressed,
    this.isLoading,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: onPressed,
        color: customColor,
        textColor: Colors.white,
        child: isLoading
            ? MySpinKitCircle()
            : Container(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
      ),
    );
  }
}

class MyAccountButton extends StatelessWidget {
  final Function onPressed;
  final String image;
  final String name;
  MyAccountButton({this.name, this.onPressed, this.image});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ButtonTheme(
      minWidth: 260,
      height: 60,
      splashColor: customColor[10],
      child: MaterialButton(
        onPressed: onPressed,
        color: Colors.white,
        textColor: Colors.black,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenSize.width * .04,
                  ),
                  Image(
                    image: AssetImage(
                      'assets/$image',
                    ),
                    height: 40,
                  ),
                  SizedBox(
                    width: screenSize.width * .06,
                  ),
                  Text(name, style: buttonText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButtonOrders extends StatelessWidget {
  final Function onPressed;
  final String name;
  final Color color;
  MyButtonOrders({this.onPressed, this.name, this.color});
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 80,
      height: 35,
      splashColor: customColor[10],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        textColor: Colors.white,
        child: Container(
          child: Column(
            children: <Widget>[
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButtonOrderStatus extends StatelessWidget {
  final Function onPressed;
  final String name;
  MyButtonOrderStatus({
    this.onPressed,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    var status = {
      'Queued': Colors.orange[700],
      'Processing': Colors.blue[700],
      'Approved': Colors.green[700],
      'Declined': customColor,
      'Cancelled': customColor
    };
    Color _checkColor() {
      return status[name.toString()];
    }

    return IgnorePointer(
      ignoring: true,
      child: ButtonTheme(
        minWidth: 20,
        height: 20,
        splashColor: customColor[10],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: MaterialButton(
          onPressed: onPressed,
          color: _checkColor(),
          textColor: Colors.white,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  name,
                  style: bodyText.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyFloatingButton extends StatelessWidget {
  final String name;
  final Function onPress;
  final Color buttonColor;
  final Color textColor;
  MyFloatingButton({this.name, this.onPress, this.buttonColor, this.textColor});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPress,
      backgroundColor: buttonColor,
      child: Text(
        name,
        style: appBar.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    );
  }
}

class MyChoiceModalButton extends StatelessWidget {
  final String name;
  final Function onPressed;
  final Color buttonColor;
  MyChoiceModalButton({this.name, this.onPressed, this.buttonColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
          color: buttonColor,
        ),
      ),
      height: 40,
      width: 120,
      // ignore: deprecated_member_use
      child: OutlineButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: buttonColor,
            width: 3,
            style: BorderStyle.solid,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            color: buttonColor,
          ),
        ),
      ),
    );
  }
}

class MyCreateOrderButton extends StatelessWidget {
  final Function onPressed;
  final String name;
  final bool isLoading;
  MyCreateOrderButton({this.onPressed, this.name, this.isLoading});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: onPressed,
      color: customColor[10],
      textColor: Colors.white,
      child: Container(
        child: isLoading
            ? MySpinKitCircle()
            : Text(
                name,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
      ),
    );
  }
}

class MySwitchAccountButton extends StatelessWidget {
  final Function onPressed;
  final String name;
  final bool isLoading;
  MySwitchAccountButton({this.onPressed, this.name, this.isLoading});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onPressed: onPressed,
      color: name == 'Submit'
          ? Colors.yellow
          : name == 'Delete' || name == 'Confirm ' || name == 'Logout'
              ? customColor
              : Colors.grey,
      textColor: Colors.white,
      child: Container(
        child: isLoading
            ? MySpinKitCircle()
            : Text(
                name,
                style: TextStyle(
                    fontSize: 16,
                    color: name == 'Delete' ||
                            name == 'Confirm' ||
                            name == 'Logout'
                        ? Colors.white
                        : Colors.black),
              ),
      ),
    );
  }
}

class MyCartBadgeButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;
  final int quantity;
  MyCartBadgeButton({this.icon, this.onPressed, this.quantity});
  @override
  Widget build(BuildContext context) {
    return quantity > 0
        ? Badge(
            animationType: BadgeAnimationType.scale,
            toAnimate: true,
            position: BadgePosition(
              start: 25,
              top: 5,
            ),
            badgeContent: Text(
              quantity < 100 ? quantity.toString() : '99',
              style: appBar.copyWith(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            badgeColor: Colors.red,
            child: IconButton(
              icon: icon,
              onPressed: onPressed,
            ),
          )
        : IconButton(icon: icon, onPressed: onPressed);
  }
}
