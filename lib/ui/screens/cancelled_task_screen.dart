import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/snack_ber_message.dart';
import '../widgets/task_card.dart';
import 'package:provider/provider.dart';
import '../../data/services/task_provider.dart';


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
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.fetchCancelledTasks();
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
    return Consumer<TaskProvider>(
      builder: (context, provider, _) =>
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Visibility(
              visible: !provider.loadingCancelled,
              replacement: CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: provider.cancelledTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: provider.cancelledTasks[index],
                    refreshParent: () {
                      provider.fetchCancelledTasks();
                      provider.fetchTaskStatusCount();
                    },
                    color: Colors.red,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 8),
              ),
            ),
          ),
        ),
    );
  }
}



