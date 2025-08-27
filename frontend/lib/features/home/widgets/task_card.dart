// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class TaskCard extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const TaskCard({
    super.key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: [
          Text(
            headerText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(descriptionText, style: TextStyle(
            fontSize: 14,
          ), 
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
