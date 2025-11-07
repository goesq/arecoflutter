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
}
