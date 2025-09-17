import 'package:flutter/material.dart';
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key, required this.title, required this.description, required this.date, required this.chipLable, required this.chipBgColor,
  });
  final String title;
  final String description;
  final String date;
  final String chipLable;
  final Color chipBgColor;

  @override
  Widget build(BuildContext context) {


    return ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      tileColor: Colors.white,
      title: Text(title),
      subtitle: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(description),
          Text("Date: $date",style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),),
          Row(
            children: [
              Chip(label: Text(chipLable),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: chipBgColor,
                labelStyle: TextStyle(
                  color: Colors.white,
                ),),
              Spacer(),
              IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
              IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.grey,)),

            ],
          )


        ],
      ),
    );
  }
}