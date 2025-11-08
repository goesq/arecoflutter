using Areco.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace Areco.Api.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<TaskModel> Tasks { get; set; }
        public DbSet<UserModel> Users { get; set; }
    }
}
