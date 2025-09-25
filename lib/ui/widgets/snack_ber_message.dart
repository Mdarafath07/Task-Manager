

import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String massage){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(massage)));

}