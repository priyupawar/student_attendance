import 'dart:convert';
import 'package:flutter/material.dart';

List jsonData;
List keys;
bool dataPresent;
List _desserts = [];
List<DataCell> cell = [];
List datatosubmit = [];
int _selectedCount;
void submitData(data) {
  datatosubmit.add(data);
  print(datatosubmit);
}

class GetList extends StatefulWidget {
  final String details;
  final String name;
  GetList(this.details, this.name);
  @override
  State<StatefulWidget> createState() {
    return _GetList();
  }
}

class _GetList extends State<GetList> {
  int i;
  @override
  void initState() {
    if (widget.details != '') {
      jsonData = jsonDecode(widget.details);
      // print(jsonData.length);
      if (jsonData.length > 0) {
        dataPresent = true;
        keys = jsonData[0].keys.toList();
      } else {
        dataPresent = false;
      }
    } else {
      dataPresent = false;
    }

    // print(dataPresent);
    datatosubmit = [];
    _selectedCount = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Padding(
            padding: EdgeInsets.all(5),
            child: Card(
                child: Column(
              children: <Widget>[
                Flexible(flex: 10, child: JsonDemo()),
                Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {},
                          child: Text('Add'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('Edit'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('Delete'),
                        )
                      ],
                    ))
              ],
            ))));
  }
}

//
class JsonDemo extends StatefulWidget {
  @override
  _JsonDemoState createState() => _JsonDemoState();
}

class _JsonDemoState extends State<JsonDemo> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  void initState() {
    cell = [];

    if (jsonData != null) {
      for (int i = 0; i < jsonData.length; i++) {
        // print(jsonData[i].values.toList());
        _desserts.add(Attendance(
            jsonData[i].values.toList(), jsonData[i].values.toList()));
      }

      //print('i:' + i.toString());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: dataPresent
            ? PaginatedDataTable(
                header: Text('Table Heading'),
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: <int>[5, 10, 20],
                onRowsPerPageChanged: (int value) {
                  setState(() {
                    _rowsPerPage = value;
                  });
                },
                columns: List.generate(
                    keys.length,
                    (index) => DataColumn(
                            label: Text(
                          keys[index].toString().toUpperCase(),
                          //textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ))),
                source: AttDataSource(),
              )
            : Center(child: Text('No Data Found')));
  }
}

////// Data class.
class Attendance {
  Attendance(this.data, this.cell);
  final List data;
  final List cell;
  bool selected = false;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class AttDataSource extends DataTableSource {
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _desserts.length) return null;
    final Attendance dessert = _desserts[index];
    //print(index);
    //cell = [];
    return DataRow.byIndex(
        index: index,
        selected: dessert.selected,
        onSelectChanged: (bool value) {
          if (dessert.selected != value) {
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            dessert.selected = value;
            notifyListeners();

            // submitData(jsonData[index][keys[0]]);
            //print(_selectedCount);
          }
          if (value) {
            datatosubmit.add(jsonData[index][keys[0]]);
          } else {
            int i = datatosubmit.indexOf(jsonData[index][keys[0]]);
            datatosubmit.removeAt(i);
          }
          print(datatosubmit);
        },
        cells: _fillCell(jsonData[index].values.toList()));
  }

  _fillCell(details) {
    //print(details);
    cell = List.generate(
        details.length, (index) => DataCell(Text(details[index].toString())));
    // print(cell);
    return cell;
  }

  @override
  int get rowCount => jsonData.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

//class JsonTable extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _JsonTable();
//   }
// }

// class _JsonTable extends State<JsonTable> {
//   int i;
//   List columns;
//   String tabletitle;
//   ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
//       subtitle: Text(
//         subtitle,
//         // overflow: TextOverflow.clip,
//         //softWrap: false,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 20,
//         ),
//         // textAlign: TextAlign.center,
//       ),
//       title: Text(title.toUpperCase() + ":",
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 20,
//           )),
//       leading: CircleAvatar(
//         child: Text(
//           title.substring(0, 1).toUpperCase(),
//           style: TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 20,
//           ),
//         ),
//       ));
//   DataRow _rowdetails(details) {
//     List<DataCell> rows = [];
//     int i;

//     for (i = 0; i < keys.length; i++) {
//       rows.add(DataCell(
//           GestureDetector(
//             child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 margin: EdgeInsets.all(10),
//                 //color: Colors.yellow,
//                 child: Text(
//                   details[keys[i]].toString(),
//                   textAlign: TextAlign.start,
//                   style: TextStyle(fontSize: 15),
//                 )),
//             onLongPress: () {
//               print(details);
//               showBottomSheet(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return PageView(
//                       // elevation: 20,
//                       //color: Colors.white12,
//                       children: <Widget>[
//                         ListView.builder(
//                           shrinkWrap: true,
//                           primary: false,
//                           itemCount: details.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return _tile(
//                                 keys[index].toString(),
//                                 details[keys[index]].toString(),
//                                 Icons.theaters);
//                           },
//                         )
//                       ]);
//                 },
//               );
//             },
//           ),
//           onTap: () {}));
//     }

//     return DataRow(
//       cells: rows,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return dataPresent
//         ? SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     child: DataTable(
//                       horizontalMargin: 10,
//                       columnSpacing: 10,
//                       columns: List.generate(
//                           keys.length,
//                           (index) => DataColumn(
//                                   label: Text(
//                                 keys[index].toString().toUpperCase(),
//                                 //textAlign: TextAlign.justify,
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ))),
//                       rows: List.generate(jsonData.length,
//                           (index) => _rowdetails(jsonData[index])),
//                       sortColumnIndex: 1,
//                       sortAscending: true,
//                     ))))
//         : Center(
//             child: Text(
//             'No Data Found',
//             style: TextStyle(
//               fontSize: 18,
//             ),
//           ));
//   }
// }
