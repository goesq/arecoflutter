import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskService {
  static const String _base = 'http://10.0.2.2:5081/api/tasks';

  Future<List<TaskModel>> getTasks({String? status, DateTime? start, DateTime? end}) async {
    final query = <String, String>{};

    if (status != null && status.isNotEmpty) query['status'] = status;
    if (start != null) query['start'] = start.toIso8601String();
    if (end != null) query['end'] = end.toIso8601String();

    final uri = Uri.parse(_base).replace(
      queryParameters: query.isEmpty ? null : query,
    );

    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Erro ao carregar tarefas: ${res.body}');
    }

    final body = res.body;

    if (!body.trim().startsWith('[')) {
      return [];
    }

    final data = jsonDecode(body) as List;

    return data.map((j) => TaskModel(
      id: j['id'],
      codigo: j['codigo'],
      observacao: j['observacao'],
      dataInicio: DateTime.parse(j['dataInicio']),
      dataFim: DateTime.parse(j['dataFim']),
      status: j['status'],
      atendimento: j['atendimento'],
    )).toList();
  }

  Future<void> addTask(TaskModel t) async {
    final res = await http.post(
      Uri.parse(_base),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'codigo': t.codigo,
        'observacao': t.observacao,
        'dataInicio': t.dataInicio.toIso8601String(),
        'dataFim': t.dataFim.toIso8601String(),
        'status': t.status,
        'atendimento': t.atendimento,
      }),
    );

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  Future<void> updateTask(TaskModel t) async {
    final res = await http.put(
      Uri.parse('$_base/${t.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'codigo': t.codigo,
        'observacao': t.observacao,
        'dataInicio': t.dataInicio.toIso8601String(),
        'dataFim': t.dataFim.toIso8601String(),
        'status': t.status,
        'atendimento': t.atendimento,
      }),
    );

    if (res.statusCode != 204 && res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  Future<void> deleteTask(int id) async {
    final res = await http.delete(Uri.parse('$_base/$id'));

    if (res.statusCode != 204) {
      throw Exception(res.body);
    }
  }
}
