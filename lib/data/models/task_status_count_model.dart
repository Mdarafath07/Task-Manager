class TaskStatusCountModel {
  final String status;
  final int count;

  TaskStatusCountModel({required this.status, required this.count});

  factory TaskStatusCountModel.fromJson(Map<String, dynamic> jesonData) {
    return TaskStatusCountModel(
      status: jesonData["_id"],
      count: jesonData["sum"],
    );
  }
}
