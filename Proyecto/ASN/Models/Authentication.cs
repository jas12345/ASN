using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;

namespace ASN.Models
{
    public class Authentication
    {
        public static UserViewModel CCMSLogin(string username, string password)
        {
            UserViewModel user = new UserViewModel();

            //Cadena Dummy  para pruebas
            //string json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Javier  Raygoza Torres\",\"ident\":844795,\"manager_ident\":2881731,\"manager_first_name\":\"Enrique\",\"manager_last_name\":\"Barrera Pedraza\",\"payroll_number\":\"844795\",\"current_status\":\"Active\",\"hire_date\":\"2012-07-16\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"844795\",\"account_id\":\"raygozatorres.5\",\"Position_Code_Title\":\"Admin Software Development Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1984-11-27\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43098412596\",\"sex\":\"Male\",\"email1\":\"javier.raygoza@teleperformance.com\",\"civil_status\":\"Single\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Development Supervisor\",\"position_code_abbr_name\":\"Development Supervisor\",\"Instalacion_Id\":2,\"employee_common_name\":\"Javier Raygoza Torres\",\"manager_employee_common_name\":\"Enrique Barrera Pedraza\",\"contract_type_full_name\":\"HTC\",\"contract_type_ident\":831,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":364}]";

            var httpClient = new HttpClient();
            string HTTPSecurityService = System.Configuration.ConfigurationManager.AppSettings["HTTPSecurityService"];

            httpClient.BaseAddress = new Uri(HTTPSecurityService + "values/?ccmsUsername=" + HttpUtility.UrlEncode(username) + "&ccmspassword=" + HttpUtility.UrlEncode(password) + "");
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));
            string json = "";

            json = httpClient.GetStringAsync(string.Empty).Result;

            List<UserViewModel> Users = JsonConvert.DeserializeObject<List<UserViewModel>>(json);

            if (Users.Count > 0)
            {
                user = Users[0];
            }

            return user;
        }
    }
}