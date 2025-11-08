using Areco.Api.Data;
using Areco.Api.Dto;
using Areco.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Areco.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TasksController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TasksController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var tasks = await _context.Tasks.ToListAsync();
            return Ok(tasks);
        }

        [HttpPost]
        public async Task<IActionResult> Create(TaskDto dto)
        {
            if (dto.DataInicio > dto.DataFim)
                return BadRequest("Data de início não pode ser maior que a data de fim.");

            var task = new TaskModel
            {
                Codigo = dto.Codigo,
                Observacao = dto.Observacao,
                Atendimento = dto.Atendimento,
                DataInicio = dto.DataInicio,
                DataFim = dto.DataFim,
                Status = dto.Status
            };

            _context.Tasks.Add(task);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetAll), new { id = task.Id }, task);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, TaskDto dto)
        {
            var task = await _context.Tasks.FindAsync(id);
            if (task == null) return NotFound();

            task.Codigo = dto.Codigo;
            task.Observacao = dto.Observacao;
            task.Atendimento = dto.Atendimento;
            task.DataInicio = dto.DataInicio;
            task.DataFim = dto.DataFim;
            task.Status = dto.Status;

            await _context.SaveChangesAsync();
            return Ok(task);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var task = await _context.Tasks.FindAsync(id);
            if (task == null) return NotFound();

            if (task.Status != "A Realizar")
                return BadRequest("Só é possível excluir tarefas com status 'A Realizar'.");

            _context.Tasks.Remove(task);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
