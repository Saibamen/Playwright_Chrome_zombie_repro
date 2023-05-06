using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Playwright;

namespace Playwright_Chrome_zombie_repro.Controllers
{
    [Route("api/[controller]")]
    [AllowAnonymous]
    [ApiController]
    public class VersionController : ControllerBase
    {
        public async Task<IActionResult> Index()
        {
            using var playwright = await Playwright.CreateAsync();
            await using var browser = await playwright.Chromium.LaunchAsync();

            await browser.CloseAsync();
            await browser.DisposeAsync();

            return Ok();
        }
    }
}
