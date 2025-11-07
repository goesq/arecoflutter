import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  List<TaskModel> tasks = [];
  String? statusFilter;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final result = await _taskService.getTasks();
    setState(() => tasks = result);
  }

  void _openTaskForm({TaskModel? task}) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
        onSave: (newTask) async {
          if (task == null) {
            await _taskService.addTask(newTask);
          } else {
            await _taskService.updateTask(newTask);
          }
          _loadTasks();
        },
      ),
    );
  }

  void _deleteTask(TaskModel task) async {
    if (task.status != 'A Realizar') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Só é possível excluir tarefas com status "A Realizar"'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _taskService.deleteTask(task.id!);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = statusFilter == null
        ? tasks
        : tasks.where((t) => t.status == statusFilter).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/areco_logo.png',
              height: 90,
            ),
            const SizedBox(height: 6),
            const Text(
              'Gerenciador de Tarefas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) => setState(() {
              statusFilter = value == 'Todos' ? null : value;
            }),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Todos', child: Text('Todos')),
              PopupMenuItem(value: 'A Realizar', child: Text('A Realizar')),
              PopupMenuItem(value: 'Aguardando Avaliação', child: Text('Aguardando Avaliação')),
              PopupMenuItem(value: 'Realizado', child: Text('Realizado')),
              PopupMenuItem(value: 'Cancelada', child: Text('Cancelada')),
            ],
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 140, left: 16, right: 16),
          child: filteredTasks.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma tarefa encontrada',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TaskCard(
                      task: task,
                      onEdit: () => _openTaskForm(task: task),
                      onDelete: () => _deleteTask(task),
                    );
                  },
                ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskForm(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
