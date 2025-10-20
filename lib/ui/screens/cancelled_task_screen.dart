import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_ber_message.dart';
import '../widgets/task_card.dart';


class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  static const String name = "/cancelled-task";

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskInProgress = false;

  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCancelledTask();
  }


  Future<void> _getAllCancelledTask() async {
    _getCancelledTaskInProgress = true;
    setState(() {});
    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.CancelledTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jesonData in response.responseData["data"]) {
        list.add(TaskModel.fromJson(jesonData));
      }
      _cancelledTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCancelledTaskInProgress = false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Visibility(
          visible: _getCancelledTaskInProgress == false,
          child: ListView.separated(
            itemCount: _cancelledTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _cancelledTaskList[index], refreshParent: () {
                _getAllCancelledTask();
              }, color: Colors.red,);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 8,);
            },
          ),
        ),
      ),

    );
  }
}



