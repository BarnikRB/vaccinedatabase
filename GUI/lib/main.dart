import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PostSqlClass.dart';
import 'Tables.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PostgresSql()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        ),
        darkTheme: ThemeData(
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}








class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    Provider.of<PostgresSql>(context, listen: false).initSQL("dbcourse.cs.aalto.fi", 5432, "grp06db_2023", "grp06_2023", "8gSxbXiq");
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Consumer<PostgresSql?>(
            builder: (context, objectIndex, child) =>
              ListView.builder(
                itemCount: objectIndex?.dbReturn.length,
                itemBuilder: (contextItem, index){
                  return Card(

                    color: Colors.amber,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () {
                        objectIndex?.getTable((objectIndex?.dbReturn[index]));
                        print(index);
                        Navigator.push(context,MaterialPageRoute(builder: (context)=> Tables(objectIndex?.dbReturn[index]),));
                        },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Text(objectIndex?.dbReturn[index],
                            style: const TextStyle(fontSize: 20),),
                        )
                      ),
                    ),
                  );
                },
              )
        )
      )
    );
  }
}

