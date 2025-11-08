import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import '../widgets/task_card.dart';
import '../widgets/task_form_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();

  List<TaskModel> tasks = [];
  String? statusFilter;
  DateTime? startDate;
  DateTime? endDate;
  String userName = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadTasks();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getLoggedUser();
    if (user != null) {
      setState(() => userName = user["nome"] ?? "");
    }
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

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      statusFilter = null;
      startDate = null;
      endDate = null;
    });
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) {
      final matchStatus = statusFilter == null || task.status == statusFilter;
      final matchDate = (startDate == null || task.dataInicio.isAfter(startDate!.subtract(const Duration(days: 1))))
          && (endDate == null || task.dataFim.isBefore(endDate!.add(const Duration(days: 1))));
      return matchStatus && matchDate;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Column(
            children: [
              Image.asset('assets/images/arecotasks.png', height: 40),
              const SizedBox(height: 6),
              const SizedBox(height: 10),
            ],
          ),
        ),

        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _filterButton(Icons.refresh, _loadTasks),
                _filterButton(Icons.calendar_month, _selectDateRange),
                _filterButton(Icons.filter_list, () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(1, 100, 0, 0),
                    items: const [
                      PopupMenuItem(value: 'Todos', child: Text('Todos')),
                      PopupMenuItem(value: 'A Realizar', child: Text('A Realizar')),
                      PopupMenuItem(value: 'Aguardando Avaliação', child: Text('Aguardando Avaliação')),
                      PopupMenuItem(value: 'Realizado', child: Text('Realizado')),
                      PopupMenuItem(value: 'Cancelada', child: Text('Cancelada')),
                    ],
                  ).then((value) {
                    if (value != null) {
                      setState(() => statusFilter = value == "Todos" ? null : value);
                    }
                  });
                }),
                _filterButton(Icons.close, _clearFilters),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                      child: Text('Nenhuma tarefa encontrada',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 140, left: 16, right: 16),
                      itemCount: filteredTasks.length,
                      itemBuilder: (_, i) => TaskCard(
                        task: filteredTasks[i],
                        onEdit: () => _openTaskForm(task: filteredTasks[i]),
                        onDelete: () => _deleteTask(filteredTasks[i]),
                      ),
                    ),
            ),
          ],
        ),

        bottomNavigationBar: _bottomNav(),
      ),
    );
  }

  Widget _filterButton(IconData icon, Function() onPressed) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _bottomNav() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.black),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.blue.shade700),
                    onPressed: () => _openTaskForm(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black),
                  onPressed: _confirmLogout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
