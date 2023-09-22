import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PostSqlClass.dart';

class Tables extends StatefulWidget {

  String tableName;
  Tables(this.tableName, {super.key});



  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {


  @override
  void initState() {
    print("table name: ${widget.tableName}");
    //Provider.of<PostgresSql>(context, listen: false).getTable(widget.tableName);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    var screenSize=MediaQuery.of(context);
    final double screenHeight = screenSize.size.height;
    final double screenWidth = screenSize.size.width;

    return Scaffold(
      body: Center(
          child: Consumer<PostgresSql?>(
              builder: (context, objectIndex, child) =>
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: (() {
                        if(objectIndex!.dbTable[0].length <= 2){
                          return screenWidth;
                        }
                        else{
                          return screenWidth*(objectIndex!.dbTable[0].length / 2) ;
                        }
                      }()),
                      child: GridView.builder(
                          itemCount: ((objectIndex!.dbTable.length + 1) * objectIndex!.dbTable[0].length),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:objectIndex!.dbTable[0].length ,
                              childAspectRatio: (3 / 1),
                          ),
                          itemBuilder: (subContxt, subObjectIndex){

                            if(subObjectIndex < objectIndex!.dbTable[0].length){
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: Card(
                                  color: Colors.grey,
                                  child: InkWell(
                                      onTap: () {
                                        objectIndex?.sortTable(subObjectIndex);
                                      },
                                      child: Center(
                                          child: (() {
                                            if (objectIndex.sortIndex == subObjectIndex){
                                              return Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("${objectIndex!.dbTableColumnName[subObjectIndex][0]}"),

                                                  (() {
                                                    if(objectIndex?.sortReversed== true){
                                                    return Icon(Icons.upload);
                                                    }
                                                    if(objectIndex?.sortReversed== false){
                                                      return Icon(Icons.download);
                                                    }
                                                    else{
                                                      return Icon(Icons.question_mark);
                                                    }
                                                  }())

                                                ],
                                              );
                                            }else {
                                              return Text("${objectIndex!.dbTableColumnName[subObjectIndex][0]}");
                                            }

                                          }())
                                      )
                                  ),
                                ),
                              );
                            }
                            else{
                              return Padding(//todo: move right for dbTable[0].length
                                padding: const EdgeInsets.all(0),
                                child: Card(
                                  color: Colors.amber,
                                  child: Center(child: Text("${objectIndex!.dbTable[(subObjectIndex-objectIndex!.dbTable[0].length) ~/ objectIndex!.dbTable[0].length][(subObjectIndex-objectIndex!.dbTable[0].length) % objectIndex!.dbTable[0].length]}")),
                                ),
                              );
                            }


                          }

                      ),
                    ),
                  )
          )
      ),
    );
  }
}
