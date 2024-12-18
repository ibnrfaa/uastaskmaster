import 'package:flutter/material.dart';
import 'home.dart';

class SubTaskScreen extends StatefulWidget {
  final ToDoItem task;

  const SubTaskScreen({super.key, required this.task});

  @override
  State<SubTaskScreen> createState() => _SubTaskScreenState();
}

class _SubTaskScreenState extends State<SubTaskScreen> {
  final List<Map<String, dynamic>> _subTasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  double get _progressPercentage {
    final completedTasks = _subTasks.where((task) => task['done'] == true).length;
    return completedTasks / _subTasks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.task.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(widget.task.description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 16),
              if (_subTasks.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _progressPercentage,
                        backgroundColor: Colors.grey[300],
                        color: Colors.blue,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${(_progressPercentage * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  SelectableText(
                    widget.task.location,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    showCursor: true, // Menampilkan kursor saat dipilih
                    cursorColor: Colors.blue, // Menentukan warna kursor
                    // ignore: deprecated_member_use
                    toolbarOptions: const ToolbarOptions(copy: true), // Menambahkan opsi salin ke toolbar
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateInfo('Start Date', widget.task.fromDate),
                  _buildDateInfo('End Date', widget.task.toDate),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Subtask', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildSubTaskList(),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Subtask Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date & Time',
                  border: const OutlineInputBorder(),
                  hintText: _formatDateTime(DateTime.now()), // Menampilkan format saat ini
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      // ignore: use_build_context_synchronously
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(pickedDate),
                    );
                    if (pickedTime != null) {
                      DateTime finalDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      _dateController.text = _formatDateTime(finalDateTime);
                    }
                  }
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_titleController.text.isNotEmpty && _dateController.text.isNotEmpty) {
                        _subTasks.add({
                          'title': _titleController.text,
                          'date': _dateController.text,
                          'done': false,
                        });
                      }
                    });
                    _titleController.clear();
                    _dateController.clear();
                  },
                  child: const Text('+ Add Subtask'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Format manual: 'yyyy-MM-dd HH:mm'
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildDateInfo(String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
            const SizedBox(width: 4),
            Text('${date.day} ${_getMonthName(date.month)}, ${date.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  List<Widget> _buildSubTaskList() {
    return _subTasks.map((subTask) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Checkbox(
            value: subTask['done'],
            onChanged: (value) {
              setState(() {
                subTask['done'] = value;
              });
            },
          ),
          title: Text(subTask['title'], style: TextStyle(decoration: subTask['done'] ? TextDecoration.lineThrough : null)),
          subtitle: Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(subTask['date'], style: const TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editSubTask(subTask),
          ),
        ),
      );
    }).toList();
  }

  // Fungsi untuk edit subtask
  void _editSubTask(Map<String, dynamic> subTask) {
    _titleController.text = subTask['title'];
    _dateController.text = subTask['date'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Subtask'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Subtask Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: 'Date & Time'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      // ignore: use_build_context_synchronously
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(pickedDate),
                    );
                    if (pickedTime != null) {
                      DateTime finalDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      _dateController.text = _formatDateTime(finalDateTime);
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  subTask['title'] = _titleController.text;
                  subTask['date'] = _dateController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}