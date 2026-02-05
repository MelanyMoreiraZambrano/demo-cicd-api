var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/api/v1/ping", () =>
    Results.Ok(new { ok = true, ts = DateTime.UtcNow })
);

app.MapGet("/health", () => Results.Ok("OK"));

app.MapGet("/version", () => Results.Ok(new
{
    service = "Demo.CICD.Api",
    env = app.Environment.EnvironmentName,
    build = Environment.GetEnvironmentVariable("GIT_SHA") ?? "local"
}));

app.Run();
