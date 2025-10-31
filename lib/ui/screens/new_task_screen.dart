import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_ber_message.dart';

import '../../data/models/task_status_count_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status_card.dart';
import 'package:provider/provider.dart';
import '../../data/services/task_provider.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  static const String name = "/new-task";

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<TaskProvider>(context, listen: false);
    provider.fetchTaskStatusCount();
    provider.fetchNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 90,
                  child: Visibility(
                    visible: !provider.loadingCount,
                    replacement: CenteredProgressIndicator(),
                    child: ListView.separated(
                      itemCount: provider.statusCounts.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final c = provider.statusCounts[index];
                        return TaskCounterByStatusCard(
                          title: c.status,
                          count: c.count,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(width: 4),
                    ),
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: !provider.loadingNew,
                    replacement: CenteredProgressIndicator(),
                    child: ListView.separated(
                      itemCount: provider.newTasks.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskModel: provider.newTasks[index],
                          refreshParent: (){
                            provider.fetchNewTasks();
                            provider.fetchTaskStatusCount();
                          },
                          color: Colors.purple,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _onTapANewTaskButton,
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.purple.withOpacity(0.5),
          ),
        );
      },
    );
  }

  void _onTapANewTaskButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );
  }
}


