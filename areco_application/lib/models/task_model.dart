class TaskModel {
  final int? id;
  final String codigo;
  final String observacao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String status;
  final String atendimento;

  TaskModel({
    this.id,
    required this.codigo,
    required this.observacao,
    required this.dataInicio,
    required this.dataFim,
    required this.status,
    required this.atendimento,
  });

  factory TaskModel.fromJson(Map<String, dynamic> j) {
    return TaskModel(
      id: j['id'],
      codigo: j['codigo'],
      observacao: j['observacao'],
      dataInicio: DateTime.parse(j['dataInicio']),
      dataFim: DateTime.parse(j['dataFim']),
      status: j['status'],
      atendimento: j['atendimento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'observacao': observacao,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'status': status,
      'atendimento': atendimento,
    };
  }
}
