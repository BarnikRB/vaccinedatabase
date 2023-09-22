import 'package:flutter/cupertino.dart';
import 'package:postgres/postgres.dart';

class PostgresSql extends ChangeNotifier {

  late String hostName;
  late int port;
  late String dataBaseName;
  late String username;
  late String password;
  int sortIndex = 0;
  bool sortReversed= false;


  late PostgreSQLConnection connection;
  List<dynamic> dbReturn=[];
  List<List<dynamic>> dbTable=[["Loading..."]];
  List<dynamic> dbTableColumnName=["Loading..."];


  void initSQL(hostName, port, dataBaseName, username, password) async {
    connection = PostgreSQLConnection(hostName, port, dataBaseName, username: username, password: password);
    await connection.open();

    if (! connection.isClosed){
      print("connection open! ");
    }
    getDb();
  }

  Future<List> getDb() async {
    dbReturn.clear();
    List<List<dynamic>> results = await connection.query("SELECT tablename FROM pg_catalog.pg_tables where schemaname = 'public' ");

    for (final row in results) {

      print(row[0]);
      dbReturn.add(row[0]);
    }
    notifyListeners();
    return dbReturn;
  }

  void getTable(String tableName) async {
    sortIndex = -1;

    dbTableColumnName=await connection.query("SELECT column_name FROM information_schema.columns WHERE table_name  = '$tableName' ; ; ");
    dbTable = await connection.query("select * from $tableName");

    for (final row in dbTable) {

      for (final a in row){
        
        print(a);
      }
    print("------------------");
    }
    notifyListeners();



    print(dbTableColumnName);
    print("-----asddddddddddddddddddddddd------");
    return ;
  }

  void sortTable(int index){

    print("index: $index , sortIndex: $sortIndex");




    List<List<dynamic>> sortedList = List.from(dbTable);
    sortedList.sort((a, b) => a[index].compareTo(b[index]));


    if (index == sortIndex){
      dbTable = dbTable.reversed.toList();
      sortReversed = !sortReversed;


    }
    else{
      dbTable = sortedList;
      sortReversed =false;

    }


    sortIndex = index;


    notifyListeners();
  }



}