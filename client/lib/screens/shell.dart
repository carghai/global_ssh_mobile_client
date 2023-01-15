import 'package:client/func/redis/read_all.dart';
import 'package:client/widgets/coolButtion.dart';
import 'package:client/widgets/coolText.dart';
import 'package:flutter/material.dart';

import '../widgets/error_display.dart';
import '../widgets/loading.dart';

class MoreData extends StatefulWidget {
  const MoreData({Key? key, required this.where}) : super(key: key);
  final String where;

  @override
  _MoreDataState createState() => _MoreDataState();
}

class _MoreDataState extends State<MoreData> {
  List<String> shellData = [];
  bool allowedSend = false;
  TextEditingController textController = TextEditingController();

  update() async {
    String oldData = "";
    while (true) {
      try {
        String data = await redis.getCommand(widget.where);
        if (oldData != data) {
          allowedSend = true;
          shellData.add(data);
          oldData = data;
          if (mounted) {
            setState(() {});
          }
        }
      } catch (e) {
        if (mounted) {
          error = e.toString();
          ScaffoldMessenger.of(context).showSnackBar(showError);
        }
      }
    }
  }

  send() async {
    if (allowedSend) {
      RedisCommand.sendCommand(widget.where, textController.text);
      allowedSend = false;
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
      shellData[0];
    } catch (e) {
      return const Loading(
        text: "Waiting:  ",
      );
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
          child: Column(
            children: [
              Expanded(
                flex: 18,
                child: ListView.builder(
                  itemCount: shellData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: coolText(text: shellData[index], fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                  child: TextField(
                onSubmitted: send(),
                controller: textController,
                decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Enter Command"),
              )),
              ExpandedButton(
                  onPressed: () {
                    RedisCommand.kill(widget.where);
                  },
                  text: "Kill Command",
                  flex: 1,
                  fontSize: 14,
                  width: 250),
              const Spacer(),
            ],
          ),
        )));
  }
}