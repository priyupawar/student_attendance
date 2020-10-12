import 'dart:convert';
import 'dart:io';
import 'package:myproject/localstorage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:myproject/authform.dart';
import 'package:myproject/masterform.dart';
import 'package:myproject/pageroute.dart';
import 'package:myproject/groupsms.dart';
import 'package:myproject/reportlist.dart';
import 'package:myproject/resetpassword.dart';
import 'package:myproject/widgets/cart.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userid;

String password;
String ip;
int port;
String msg;
String path;
String data;
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class MainPage extends StatefulWidget {
  final line2;
  MainPage(this.line2);
  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

void getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userid = prefs.getString('username');
  path = prefs.getString('path');
  // print('path' + path);
  password = prefs.getString('password');
}

void logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.getBool('remember')) {
    prefs.remove('username');
    prefs.remove('password');
    prefs.setBool('isLoggedIn', false);
  }

  //print(prefs.getString('file'));
  LocalStorage().deleteFile(File(prefs.getString('file')));
}

Future getReport(String att, String page) async {
  print('inside get report');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //userid = prefs.getString('username');
  path = prefs.getString('path');
  //print(path);
  String json = '{"AttType":"' + att + '","PageType":"' + page + '"}';
  String url = '' + path + '/GetReportMainPage';
  // print(json);
  fileContent = jsonDecode(jsonFile.readAsStringSync());
  Map<String, String> headers = {
    // "Content-Type": "application/x-www-form-urlencoded"
    "Content-type": "application/json",
    //"token": fileContent['token']
  };
  var response = await http.post(url, headers: headers, body: json);
  if (response.body != '') {
    data = response.body;
  }
  //print(jsonDecode(response.body)[0]);
  // if (jsonDecode(response.body)[0] == null) {
  //   if (jsonDecode(response.body)['message'] == 'Token invalid') {
  //     final snackBar = SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text('Token invalid'),
  //     );
  //     _scaffoldKey.currentState.showSnackBar(snackBar);
  //   }
  //   data = '';
  // } else {
  //   data = response.body;
  // }
  //print(data);
  // Navigator.push(
  //     context,
  //     PageTransition(
  //         type: PageTransitionType.leftToRight,
  //         child: ReportList(response.body)));
}

// Future getReport2() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   path = prefs.getString('path');
//   //String url = '' + path + '/GetMaster';
//   //Map<String, String> headers = {"Content-type": "application/json"};
//   //var response = await http.get(url);
// }

class _MainPage extends State<MainPage> {
  int _currentTabIndex = 0;
  static const _kBottmonNavBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
    BottomNavigationBarItem(
        icon: Icon(Icons.bubble_chart), title: Text('Chart')),
    BottomNavigationBarItem(
        icon: Icon(Icons.perm_identity), title: Text('MasterReport')),
    BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('GroupSMS')),
  ];
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    setState(() {
      getUser();
      data = '';
    });
    // getReport2();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 10,
        title: Text(
          widget.line2,
          overflow: TextOverflow.visible,
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text('Alert!!!'),
                        content: Text('Do you want to Logout?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              logout();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AuthForm()));
                            },
                          ),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ));
            },
            child: Icon(Icons.power_settings_new),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: ResetPassword()));
                      },
                      child: ListTile(title: Text('Reset Password'))),
                ),
                PopupMenuItem(
                  child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Back'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              FlatButton(
                                child: Text('Change'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  DynamicTheme.of(context).setThemeData(
                                      ThemeData(primarySwatch: pickerColor));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: ListTile(title: Text('Change Theme'))),
                )
              ];
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).accentColor,
        selectedItemColor: Theme.of(context).accentColor,
        items: _kBottmonNavBarItems,
        currentIndex: _currentTabIndex,
        onTap: (int index) {
          setState(() => this._currentTabIndex = index);
        },
      ),
      body: IndexedStack(
        children: <Widget>[
          HomePage(),
          PieChartExample(),
          MasterForm('Master Report'),
          GroupSms(),
        ],
        index: _currentTabIndex,
      ),
    );
  }
}

List<Widget> widgetlist;
Widget list(BuildContext context) {
  if (data == '') {
    return FutureBuilder(
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List reportDetails = jsonDecode(data);
          int i;
          widgetlist = [];
          for (i = 0; i < reportDetails.length; i++) {
            String name = reportDetails[i]['RPT_NAME'];

            String desc = reportDetails[i]['RPT_DESC'];

            int icon = int.parse(reportDetails[i]['ICON']);
            widgetlist.add(SizedBox(
                height: 80,
                child: RaisedButton(
                  elevation: 15,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        CurvedAnimations(
                            widget: ReportList(name),
                            curve: Curves.fastOutSlowIn));
                  },
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        IconData(icon, fontFamily: 'MaterialIcons'),
                        color: Theme.of(context).accentColor,
                        size: 36.0,
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      subtitle: Text(desc),
                    ),
                  ),
                )));
          }
          return Column(
            children: widgetlist,
          );
        } else {
          return Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topCenter,
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getReport('null', 'MainPage'),
    );
  } else {
    List reportDetails = jsonDecode(data);
    int i;
    widgetlist = [];
    for (i = 0; i < reportDetails.length; i++) {
      String name = reportDetails[i]['RPT_NAME'];

      String desc = reportDetails[i]['RPT_DESC'];

      int icon = int.parse(reportDetails[i]['ICON']);
      widgetlist.add(SizedBox(
          height: 80,
          child: RaisedButton(
            elevation: 15,
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  CurvedAnimations(
                      widget: ReportList(name), curve: Curves.fastOutSlowIn));
            },
            child: Card(
              child: ListTile(
                leading: Icon(
                  IconData(icon, fontFamily: 'MaterialIcons'),
                  color: Theme.of(context).accentColor,
                  size: 36.0,
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                subtitle: Text(desc),
              ),
            ),
          )));
    }
    return Column(
      children: widgetlist,
    );
  }
}

class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      height = MediaQuery.of(context).size.height / 3;
    } else {
      height = MediaQuery.of(context).size.height / 1;
    }
    return SizedBox(
        width: double.infinity,
        height: height,
        child: ClipRRect(
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
          child: Center(
              child: Carousel(
            boxFit: BoxFit.fill,
            images: [
              AssetImage('assets/image1.jpg'),
              AssetImage('assets/image2.jpg'),
              AssetImage('assets/image3.jpg'),
              AssetImage('assets/image4.jpg'),
              AssetImage('assets/image5.jpg'),
              AssetImage('assets/image6.jpg'),
            ],
            showIndicator: false,
          )),
        ));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Card(
          child: Column(children: <Widget>[
        ImageCarousel(),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: list(context))),
      ])),
    ));
  }
}

// Future printPage() {
//   Printer.connect(ip, port: port).then((printer) {
//     printer.println(
//         'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//     printer.println('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
//         styles: PosStyles(codeTable: PosCodeTable.westEur));
//     printer.println('Special 2: blåbærgrød',
//         styles: PosStyles(codeTable: PosCodeTable.westEur));

//     printer.println('Bold text', styles: PosStyles(bold: true));
//     printer.println('Reverse text', styles: PosStyles(reverse: true));
//     printer.println('Underlined text',
//         styles: PosStyles(underline: true), linesAfter: 1);
//     printer.println('Align left', styles: PosStyles(align: PosTextAlign.left));
//     printer.println('Align center',
//         styles: PosStyles(align: PosTextAlign.center));
//     printer.println('Align right',
//         styles: PosStyles(align: PosTextAlign.right), linesAfter: 1);
//     printer.printRow([
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: PosStyles(align: PosTextAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col6',
//         width: 6,
//         styles: PosStyles(align: PosTextAlign.center, underline: true),
//       ),
//       PosColumn(
//         text: 'col3',
//         width: 3,
//         styles: PosStyles(align: PosTextAlign.center, underline: true),
//       ),
//     ]);
//     printer.println('Text size 200%',
//         styles: PosStyles(
//           height: PosTextSize.size2,
//           width: PosTextSize.size2,
//         ));

//     // Print image
//     // const String filename = 'assets/school.jpeg';
//     // final Image image = decodeImage(File(filename).readAsBytesSync());
//     // printer.printImage(image);
//     // // Print image using an alternative (obsolette) command
//     // // printer.printImageRaster(image);

//     // Print barcode
//     final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//     printer.printBarcode(Barcode.upcA(barData));

//     // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
//     // printer.println(
//     //   'hello ! 中文字 # world @ éphémère &',
//     //   styles: PosStyles(codeTable: PosCodeTable.westEur),
//     // );
//     printer.println(msg);
//     print(msg);
//     printer.cut();
//     printer.disconnect();
//   });
// }
