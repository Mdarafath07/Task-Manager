import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_ber_message.dart';

import '../../data/utils/urls.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.refreshParent, required this.color,
  });

  final TaskModel taskModel;
  final VoidCallback refreshParent;
  final Color? color;



  @override
  State<TaskCard> createState() => _TaskCardState();
}

bool _chnageStatusInProgress = false;
bool _deleteInProgress = false;

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          title: Text(
            widget.taskModel.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                widget.taskModel.description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.taskModel.createdDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Chip(
                    label: Text(widget.taskModel.status),
                    backgroundColor: widget.color ?? Colors.blue,
                    labelStyle: const TextStyle(color: Colors.white),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  ),
                ],
              ),
              const Divider(height: 18, thickness: 1, color: Color(0xFFEAEAEA)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: !_deleteInProgress,
                    replacement: const CenteredProgressIndicator(),
                    child: IconButton(
                      onPressed: () {
                        _deleteTask();
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: 'Delete Task',
                    ),
                  ),
                  Visibility(
                    visible: !_chnageStatusInProgress,
                    replacement: const CenteredProgressIndicator(),
                    child: IconButton(
                      onPressed: _showChangeStatusDialog,
                      icon: const Icon(Icons.edit_note, color: Colors.grey),
                      tooltip: 'Edit Task',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Change Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _chnageStatus("New");
                },
                title: Text("New"),
                trailing: widget.taskModel.status == 'New'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _chnageStatus("Progress");
                },
                title: Text("Progress"),
                trailing: widget.taskModel.status == 'Progress'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _chnageStatus("Cancelled");
                },
                title: Text("Cancelled"),
                trailing: widget.taskModel.status == 'Cancelled'
                    ? Icon(Icons.done)
                    : null,
              ),
              ListTile(
                onTap: () {
                  _chnageStatus("Completed");
                },
                title: Text("Completed"),
                trailing: widget.taskModel.status == 'Completed'
                    ? Icon(Icons.done)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _chnageStatus(String status) async {
    if (status == widget.taskModel.status) {
      return;
    }
    Navigator.pop(context);
    _chnageStatusInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );
    _chnageStatusInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }
  Future<void> _deleteTask() async {

    _deleteInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );
    _deleteInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      widget.refreshParent();
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }
}
