import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/date_utils.dart';

class TaskFormDialog extends StatefulWidget {
  final TaskModel? task;
  final Future<void> Function(TaskModel) onSave;

  const TaskFormDialog({
    Key? key,
    this.task,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController codigoController;
  late TextEditingController obsController;

  DateTime? dataInicio;
  DateTime? dataFim;

  String status = 'A Realizar';
  String atendimento = 'Online';

  final List<String> statusList = [
    'A Realizar',
    'Aguardando Avaliação',
    'Realizado',
    'Cancelada'
  ];

  final List<String> atendimentoList = [
    'Online',
    'Presencial',
    'Telefone',
    'Outro'
  ];

  @override
  void initState() {
    super.initState();
    codigoController = TextEditingController(text: widget.task?.codigo ?? '');
    obsController = TextEditingController(text: widget.task?.observacao ?? '');
    dataInicio = widget.task?.dataInicio ?? DateTime.now();
    dataFim = widget.task?.dataFim ?? DateTime.now();
    status = widget.task?.status ?? 'A Realizar';
    atendimento = widget.task?.atendimento ?? 'Online';
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (dataInicio!.isAfter(dataFim!)) {
      _showError('A data de início não pode ser maior que a data de fim.');
      return;
    }

    final task = TaskModel(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch,
      codigo: codigoController.text,
      observacao: obsController.text,
      dataInicio: dataInicio!,
      dataFim: dataFim!,
      status: status,
      atendimento: atendimento,
    );

    try {
      await widget.onSave(task);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: codigoController,
                decoration: const InputDecoration(labelText: 'Nome/Código'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o código' : null,
              ),
              TextFormField(
                controller: obsController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: statusList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => status = v.toString()),
              ),

              DropdownButtonFormField(
                value: atendimento,
                decoration: const InputDecoration(labelText: 'Atendimento'),
                items: atendimentoList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => atendimento = v.toString()),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: dataInicio!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() => dataInicio = date);
                        }
                      },
                      child: Text('Início: ${formatDate(dataInicio!)}'),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: dataFim!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() => dataFim = date);
                        }
                      },
                      child: Text('Fim: ${formatDate(dataFim!)}'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _saveTask,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
