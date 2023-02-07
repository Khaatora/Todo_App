import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_own/models/task.dart';
import 'package:todo_own/modules/tasks/edit_task/edit_task_screen.dart';
import 'package:todo_own/modules/tasks/tasks_provider/task_item_provider.dart';
import 'package:todo_own/shared/network/local/firebase_utils.dart';
import 'package:todo_own/shared/styles/colors.dart';

class TaskItem extends StatelessWidget {
  TaskData task;

  TaskItem(this.task);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskItemProvider(),
      builder: (context, child) => Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.01),
        child: Slidable(
          startActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: (context) {
                deleteTaskFromFirestore(task.id);
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: "Delete",
            )
          ]),
          endActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(12),
              onPressed: (context) {
                Navigator.pushNamed(context, EditTaskScreen.routeName,
                    arguments: task);
              },
              backgroundColor: colorLightBlue,
              icon: Icons.edit,
              label: "Edit",
            )
          ]),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.01),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.02,
                  color: task.isDone! ? colorLightBlue : Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title!),
                      Text(task.description!),
                      Text("${task.time}")
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    decoration: BoxDecoration(
                        color: task.isDone! ? colorLightBlue : Colors.red,
                        borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      onPressed: () {
                        TaskItemProvider provider =
                            Provider.of<TaskItemProvider>(context,
                                listen: false);
                        provider.onStatusChanged(task.id!, !task.isDone!);
                      },
                      icon: Icon(
                        task.isDone! ? Icons.done : Icons.close,
                        size: 30,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
