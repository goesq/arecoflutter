namespace Areco.Api.Models
{
    public class UserModel
    {
        public int Id { get; set; }
        public string Nome { get; set; } = default!;
        public string Email { get; set; } = default!;
        public string SenhaHash { get; set; } = default!;
    }
}
