import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_ber_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';
import 'package:provider/provider.dart';
import '../../data/services/task_provider.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String name = "/add-new-task";

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    "Add new task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: "Title"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your title";
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 6,
                    decoration: InputDecoration(hintText: "Description"),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your description";
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: CenteredProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapAddButton,
                      child: Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapAddButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  void _addNewTask() async {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    _addNewTaskInProgress = true;
    setState(() {});
    final response = await provider.addTask(
      title: _titleTEController.text.trim(),
      description: _descriptionTEController.text.trim(),
    );
    _addNewTaskInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextFields();
      provider.fetchNewTasks();
      provider.fetchTaskStatusCount();
      showSnackBarMessage(context, "Task added successfully");
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();

    super.dispose();
  }
}
