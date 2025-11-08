namespace Areco.Api.Dto
{
    public class TaskDto
    {
        public string Codigo { get; set; }
        public string Observacao { get; set; }
        public string Atendimento { get; set; }
        public DateTime DataInicio { get; set; }
        public DateTime DataFim { get; set; }
        public string Status { get; set; }
    }
}
