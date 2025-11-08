import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task_model.dart';
import '../utils/date_utils.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status) {
      case 'A Realizar':
        return Colors.blue.shade700;
      case 'Aguardando Avaliação':
        return Colors.orange.shade700;
      case 'Realizado':
        return Colors.green.shade700;
      case 'Cancelada':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'A Realizar':
        return Icons.hourglass_top;
      case 'Aguardando Avaliação':
        return Icons.search;
      case 'Realizado':
        return Icons.check_circle;
      case 'Cancelada':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.codigo,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              PopupMenuButton(
                icon: const Icon(Icons.more_vert, size: 22),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  if (task.status == 'A Realizar')
                    const PopupMenuItem(value: 'delete', child: Text('Excluir')),
                ],
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            task.observacao,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                formatDateShortRange(task.dataInicio, task.dataFim),
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _getStatusColor(task.status).withOpacity(0.12),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(task.status),
                  size: 15,
                  color: _getStatusColor(task.status),
                ),
                const SizedBox(width: 6),
                Text(
                  task.status,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(task.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
