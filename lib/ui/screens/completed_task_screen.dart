import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/snack_ber_message.dart';
import '../widgets/task_card.dart';
import 'package:provider/provider.dart';
import '../../data/services/task_provider.dart';


class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  static const String name = "/completed-task";

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskInProgress = false;

  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.fetchCompletedTasks();
  }


  Future<void> _getAllCompletedTask() async {
    _getCompletedTaskInProgress = true;
    setState(() {});
    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.CompletedTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jesonData in response.responseData["data"]) {
        list.add(TaskModel.fromJson(jesonData));
      }
      _completedTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCompletedTaskInProgress = false;
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
              visible: !provider.loadingCompleted,
              replacement: CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: provider.completedTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: provider.completedTasks[index],
                    refreshParent: () {
                      provider.fetchCompletedTasks();
                      provider.fetchTaskStatusCount();
                    },
                    color: Colors.green,
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



