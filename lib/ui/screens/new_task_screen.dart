import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_ber_message.dart';

import '../../data/models/task_status_count_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});
  static const String name = "/new-task";

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getTaskStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
  }


  Future<void> _getAllTaskStatusCount() async {
    _getTaskStatusCountInProgress = true;
    setState(() {});
    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.taskStatusCountUrl);
    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jesonData in response.responseData["data"]) {
        list.add(TaskStatusCountModel.fromJson(jesonData));
      }
      _taskStatusCountList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getTaskStatusCountInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            SizedBox(
              height: 90,
              child: Visibility(
                visible: _getTaskStatusCountInProgress == false,
                replacement: CenteredProgressIndicator(),
                child: ListView.separated(
                  itemCount: _taskStatusCountList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCounterByStatusCard(
                      title: _taskStatusCountList[index].status,
                      count: _taskStatusCountList[index].count,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 4,);
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return TaskCard(
                    title: 'Title will be here',
                    description: 'Description will be here',
                    date: '11/11/2025',
                    chipLable: 'New',
                    chipBgColor: Colors.blue,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8,);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapANewTaskButton,
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onTapANewTaskButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );
  }
  }


