import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController taskController = TextEditingController();
  final CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  void addTask(String name) {
    tasks.add({'name': name, 'isCompleted': false, 'priority': 'Low'});
    taskController.clear();
  }

  void updateTask(String id, bool isCompleted) {
    tasks.doc(id).update({'isCompleted': isCompleted});
  }

  void deleteTask(String id) {
    tasks.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: Column(
        children: [
          TextField(controller: taskController, decoration: InputDecoration(labelText: 'New Task')),
          ElevatedButton(onPressed: () => addTask(taskController.text), child: Text('Add Task')),
          Expanded(
            child: StreamBuilder(
              stream: tasks.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView(
                  children: snapshot.data!.docs.map((task) {
                    return ListTile(
                      title: Text(task['name']),
                      leading: Checkbox(
                        value: task['isCompleted'],
                        onChanged: (bool? value) => updateTask(task.id, value!),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(task.id),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}