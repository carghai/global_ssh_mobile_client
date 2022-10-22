import 'package:client/func/redis/read_all.dart';
import 'package:client/screens/show_db.dart';
import 'package:client/widgets/coolText.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';

class MoreData extends StatefulWidget {
  const MoreData({Key? key, required this.where}) : super(key: key);
  final String where;

  @override
  _MoreDataState createState() => _MoreDataState();
}

class _MoreDataState extends State<MoreData> {
  late List<dynamic> redisVals;

  update() async {
    while (true) {
      try {
        redisVals = await redis.readOneKey(widget.where);
        if (mounted) {
          setState(() {});
        }
        await Future.delayed(const Duration(seconds: 10));
      } catch (_) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  @override
  void initState() {
    update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      redisVals[0];
    } catch (e) {
      return const Loading();
    }
    return Scaffold(
        appBar: AppBar(
          title: coolText(
            text: "Data For: ${widget.where}",
            fontSize: 12,
          ),
        ),
        body: Center(
            child: SizedBox(
          width: 500,
          child: ListView.builder(
            itemCount: redisVals.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: coolText(text: "${redisVals[index]}", fontSize: 12),
                ),
              );
            },
          ),
        )));
  }
}