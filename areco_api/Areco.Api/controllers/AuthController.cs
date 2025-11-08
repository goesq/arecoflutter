using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Areco.Api.Data;
using Areco.Api.Models;
using Areco.Api.Dto;

namespace Areco.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(UserRegisterDto request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                return BadRequest(new { message = "Email já cadastrado" });
            }

            var user = new UserModel
            {
                Nome = request.Nome,
                Email = request.Email,
                SenhaHash = BCrypt.Net.BCrypt.HashPassword(request.Password)
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Usuário registrado com sucesso" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(UserLoginDto request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null || !BCrypt.Net.BCrypt.Verify(request.Password, user.SenhaHash))
            {
                return Unauthorized(new { message = "Email ou senha inválidos" });
            }

            return Ok(new
            {
                message = "Login realizado com sucesso",
                welcome = $"Seja bem-vindo, {user.Nome}",
                user = new
                {
                    user.Id,
                    user.Nome,
                    user.Email
                }
            });
        }

        [HttpPost("logout")]
        public IActionResult Logout()
        {
            return Ok(new { message = "Logout realizado com sucesso" });
        }

        [HttpPost("me")]
        public async Task<IActionResult> Me([FromBody] UserEmailDto request)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null)
            {
                return NotFound(new { message = "Usuário não encontrado" });
            }

            return Ok(new
            {
                user.Id,
                user.Nome,
                user.Email
            });
        }

        [HttpGet("users")]
        public async Task<IActionResult> GetUsers()
        {
            var users = await _context.Users
                .Select(u => new
                {
                    u.Id,
                    u.Nome,
                    u.Email
                })
                .ToListAsync();

            return Ok(users);
        }
    }
}
