import 'package:flutter/material.dart';

import '../widgets/task_card.dart';


class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});
  static const String name = "/progress-task";

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Expanded(child:  ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index){
            return TaskCard(title: 'Progress title will be here', description: 'Description will be here', date: '11/11/2025', chipLable: 'Proress', chipBgColor: Colors.green,);
          },
          separatorBuilder: (context, index){
            return SizedBox(height: 8,);
          },
        )),
      ),

    );
  }
}



