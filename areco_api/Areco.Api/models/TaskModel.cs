using System.ComponentModel.DataAnnotations;

namespace Areco.Api.Models
{
    public class TaskModel
    {
        public int Id { get; set; }

        [Required]
        public string Codigo { get; set; }

        public string Observacao { get; set; }

        public string Atendimento { get; set; }

        [Required]
        public DateTime DataInicio { get; set; }

        [Required]
        public DateTime DataFim { get; set; }

        [Required]
        public string Status { get; set; } 
    }
}
