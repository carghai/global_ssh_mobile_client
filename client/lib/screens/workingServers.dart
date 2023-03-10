import 'package:client/func/redis/read_all.dart';
import 'package:client/screens/shell.dart';
import 'package:client/screens/what_db.dart';
import 'package:client/widgets/coolText.dart';
import 'package:flutter/material.dart';

import '../widgets/error_display.dart';
import '../widgets/loading.dart';

class ShowDb extends StatefulWidget {
  const ShowDb({Key? key}) : super(key: key);

  @override
  _ShowDbState createState() => _ShowDbState();
}

class _ShowDbState extends State<ShowDb> {
  Redis redisVals = Redis();

  checkDb() async {
    try {
      await redisVals.workingServers();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      error = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(showError);
    }
  }

  @override
  void initState() {
    checkDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      redisVals.allKeys[0];
    } catch (_) {
      return const Loading(
        text: "Searching:   ",
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Redis.makeClient();
            },
          ),
        ],
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.portrait_rounded),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
        ),
        title: const coolText(
          text: "Working Servers",
          fontSize: 16,
        ),
      ),
      body: Center(
          child: SizedBox(
              width: 800,
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: ListView.builder(
                      itemCount: redisVals.allKeys.length,
                      itemBuilder: (BuildContext context, int index) {
                        late Color whatTextColor;
                        if (redisVals.data[index].contains("**")) {
                          whatTextColor = Colors.white;
                        } else if (redisVals.data[index].contains("%%")) {
                          whatTextColor = Colors.amber;
                        } else {
                          whatTextColor = Colors.red;
                        }
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.computer_rounded),
                            title: Text(
                              redisVals.allKeys[index].toString(),
                              style:
                                  TextStyle(fontSize: 12, color: whatTextColor),
                            ),
                            subtitle: const Text(
                              'Click to Access',
                              style: TextStyle(fontSize: 10),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MoreData(
                                        where: redisVals.allKeys[index]
                                            .toString())),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ))),
    );
  }
}
