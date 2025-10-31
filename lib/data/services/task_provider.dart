import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/task_status_count_model.dart';
import '../services/api_caller.dart';
import '../utils/urls.dart';

class TaskProvider extends ChangeNotifier {
  bool loadingNew = false, loadingProgress = false, loadingCompleted = false, loadingCancelled = false, loadingCount = false;
  List<TaskModel> newTasks = [];
  List<TaskModel> progressTasks = [];
  List<TaskModel> completedTasks = [];
  List<TaskModel> cancelledTasks = [];
  List<TaskStatusCountModel> statusCounts = [];

  Future<void> fetchTaskStatusCount() async {
    loadingCount = true;
    notifyListeners();
    final response = await ApiCaller.getRequest(url: Urls.taskStatusCountUrl);
    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (final json in response.responseData['data']) {
        list.add(TaskStatusCountModel.fromJson(json));
      }
      statusCounts = list;
    }
    loadingCount = false;
    notifyListeners();
  }

  Future<void> fetchNewTasks() async {
    loadingNew = true;
    notifyListeners();
    final response = await ApiCaller.getRequest(url: Urls.newTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (final json in response.responseData['data']) {
        list.add(TaskModel.fromJson(json));
      }
      newTasks = list;
    }
    loadingNew = false;
    notifyListeners();
  }

  Future<void> fetchProgressTasks() async {
    loadingProgress = true;
    notifyListeners();
    final response = await ApiCaller.getRequest(url: Urls.progressTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (final json in response.responseData['data']) {
        list.add(TaskModel.fromJson(json));
      }
      progressTasks = list;
    }
    loadingProgress = false;
    notifyListeners();
  }

  Future<void> fetchCompletedTasks() async {
    loadingCompleted = true;
    notifyListeners();
    final response = await ApiCaller.getRequest(url: Urls.CompletedTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (final json in response.responseData['data']) {
        list.add(TaskModel.fromJson(json));
      }
      completedTasks = list;
    }
    loadingCompleted = false;
    notifyListeners();
  }

  Future<void> fetchCancelledTasks() async {
    loadingCancelled = true;
    notifyListeners();
    final response = await ApiCaller.getRequest(url: Urls.CancelledTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (final json in response.responseData['data']) {
        list.add(TaskModel.fromJson(json));
      }
      cancelledTasks = list;
    }
    loadingCancelled = false;
    notifyListeners();
  }

  Future<ApiResponse> addTask({required String title, required String description}) async {
    final response = await ApiCaller.postRequest(
      url: Urls.createTaskUrl,
      body: {'title': title, 'description': description, 'status': 'New'},
    );
    // Optionally refresh after adding
    await fetchNewTasks();
    await fetchTaskStatusCount();
    return response;
  }

  Future<ApiResponse> deleteTask(String id, String status) async {
    final response = await ApiCaller.getRequest(url: Urls.deleteTaskUrl(id));
    await _refreshByStatus(status);
    await fetchTaskStatusCount();
    return response;
  }

  Future<ApiResponse> updateTaskStatus(String id, String fromStatus, String toStatus) async {
    final response = await ApiCaller.getRequest(url: Urls.updateTaskStatusUrl(id, toStatus));
    await _refreshByStatus(fromStatus);
    await _refreshByStatus(toStatus);
    await fetchTaskStatusCount();
    return response;
  }

  Future<void> _refreshByStatus(String status) async {
    switch (status) {
      case 'New':
        await fetchNewTasks();
        break;
      case 'Progress':
        await fetchProgressTasks();
        break;
      case 'Completed':
        await fetchCompletedTasks();
        break;
      case 'Cancelled':
        await fetchCancelledTasks();
        break;
    }
  }
}
