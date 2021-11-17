import 'package:edq/screens/screenAccount.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/myListTile.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final String agentCode;
  Settings({this.agentCode});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var agentData;
  String agentKey;
  Size screenSize;
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor[10],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => Account(),
            ),
          ),
        ),
        title: Text(
          'Settings',
          style: appBar,
        ),
      ),
      body: StreamBuilder(
        stream: _dbRef
            .child('Agent')
            .orderByChild('AgentCode')
            .equalTo(widget.agentCode)
            .onChildAdded,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data.snapshot.value != null) {
            agentKey = snapshot.data.snapshot.key;
            agentData = snapshot.data.snapshot.value;
          } else {
            return MySpinKitFadingCube();
          }
          return Container(
            color: customColor[20],
            child: Column(
              children: <Widget>[
                Container(
                  height: screenSize.height * .15,
                  width: screenSize.width,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: screenSize.width * .03),
                        width: screenSize.width * .25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: AssetImage('assets/profile.png'),
                            height: screenSize.height * .1,
                            width: screenSize.width * .1,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: screenSize.width * .02),
                        width: screenSize.width * .75,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                agentData['AgentName'],
                                style: appBar,
                              ),
                              Text(
                                '#${agentData['AgentCode']}',
                                style: appBar.copyWith(
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                agentData['AgentUser'],
                                style: appBar.copyWith(
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0,
                                  fontSize: 11,
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: screenSize.width * 0.05,
                  ),
                  width: screenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: screenSize.height * .05,
                        width: screenSize.width,
                        child: Row(
                          children: [
                            Text(
                              'ACCOUNT INFORMATION',
                              style: appBar.copyWith(
                                  letterSpacing: 0, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: screenSize.height * .65,
                        width: screenSize.width,
                        child: ListView(
                          children: [
                            MyAccountInformationListTile(
                              leading: 'Name',
                              title: agentData['AgentName'] != null
                                  ? agentData['AgentName']
                                  : '',
                            ),
                            MyAccountInformationListTile(
                              leading: 'Email',
                              title: agentData['AgentEmail'] != null
                                  ? agentData['AgentEmail']
                                  : '',
                            ),
                            MyAccountInformationListTile(
                              leading: 'Password',
                              title: '',
                            ),
                            MyAccountInformationListTile(
                              leading: 'Contact',
                              title: agentData['AgentContact'] != null
                                  ? agentData['AgentContact']
                                  : '',
                            ),
                            MyAccountInformationListTile(
                              leading: 'Address',
                              title: agentData['AgentAdd'] != null
                                  ? agentData['AgentAdd']
                                  : '',
                            ),
                            MyAccountInformationListTile(
                              leading: 'Supervisor',
                              title: agentData['AgentSup'] != null
                                  ? agentData['AgentSup']
                                  : '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
