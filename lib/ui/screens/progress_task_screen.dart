import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_progress_indicator.dart';
import '../widgets/snack_ber_message.dart';
import '../widgets/task_card.dart';
import 'package:provider/provider.dart';
import '../../data/services/task_provider.dart';


class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  static const String name = "/progress-task";

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskInProgress = false;

  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.fetchProgressTasks();
  }


  Future<void> _getAllProgressTask() async {
    _getProgressTaskInProgress = true;
    setState(() {});
    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.progressTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jesonData in response.responseData["data"]) {
        list.add(TaskModel.fromJson(jesonData));
      }
      _progressTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getProgressTaskInProgress = false;
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
              visible: !provider.loadingProgress,
              replacement:      CenteredProgressIndicator(),
              child: ListView.separated(
                itemCount: provider.progressTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: provider.progressTasks[index],
                    refreshParent: () {
                      provider.fetchProgressTasks();
                      provider.fetchTaskStatusCount();
                    },
                    color: Colors.grey,
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



