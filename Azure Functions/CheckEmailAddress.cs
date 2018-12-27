using System;
using System.IO;
using System.Threading.Tasks;
using System.Net.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Company.Function
{
    public static class CheckEmailAddress
    {
        [FunctionName("CheckEmailAddress")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string email = req.Query["email"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            email = email ?? data?.email;

            return await IsValidEmail(email)
                ? (ActionResult)new OkObjectResult($"{email} is valid")
                : new BadRequestObjectResult("Invalid email address");
        }
        static async Task<bool> IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                if (addr.Address != email) return false;

                return await CheckDomainDns(addr.Host);
            }
            catch
            {
                return false;
            }
        }
        static async Task<bool> CheckDomainDns(string domainName)
        {
            try
            {
                HttpClient client = new HttpClient();
                HttpResponseMessage response = await client.GetAsync("https://dns-api.org/MX/" + domainName);
                if (!response.IsSuccessStatusCode) return false;
                
                var result = await response.Content.ReadAsStringAsync();
                if (result == "") return false;
                return true;                
            }
            catch
            {
                return false;
            }
        }
    }
}