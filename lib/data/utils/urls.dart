 class Urls{
  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";
  static const String registrationUrl = "$_baseUrl/Registration";
  static const String loginUrl = "$_baseUrl/Login";
  static const String createTaskUrl = "$_baseUrl/createTask";
  static const String taskStatusCountUrl = "$_baseUrl/taskStatusCount";
  static const String newTaskListUrl = "$_baseUrl/listTaskByStatus/New";
  static const String progressTaskListUrl = "$_baseUrl/listTaskByStatus/Progress";
  static const String CancelledTaskListUrl = "$_baseUrl/listTaskByStatus/Cancelled";
  static const String CompletedTaskListUrl = "$_baseUrl/listTaskByStatus/Completed";


  static String recoverVerifyEmailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyOTPUrl(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static const String recoverResetPasswordUrl = '$_baseUrl/RecoverResetPassword';

  static String updateTaskStatusUrl(String Id, String status) =>
      '$_baseUrl/updateTaskStatus/$Id/$status';

  static String deleteTaskUrl(String Id) => '$_baseUrl/deleteTask/$Id';
  static const String updateProfileUrl = '$_baseUrl/ProfileUpdate';
}