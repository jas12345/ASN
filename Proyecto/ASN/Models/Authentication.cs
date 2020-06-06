﻿using Newtonsoft.Json;
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

            var httpClient = new HttpClient();
            string HTTPSecurityService = System.Configuration.ConfigurationManager.AppSettings["HTTPSecurityService"];

            httpClient.BaseAddress = new Uri(HTTPSecurityService + "values/?ccmsUsername=" + HttpUtility.UrlEncode(username) + "&ccmspassword=" + HttpUtility.UrlEncode(password) + "");
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/xml"));
            string json = "";

            ///json = httpClient.GetStringAsync(string.Empty).Result;
            ///Cadena Dummy  para pruebas
            ///Administrador
            ///raygozatorres.5
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Javier  Raygoza Torres\",\"ident\":844795,\"manager_ident\":2881731,\"manager_first_name\":\"Enrique\",\"manager_last_name\":\"Barrera Pedraza\",\"payroll_number\":\"844795\",\"current_status\":\"Active\",\"hire_date\":\"2012-07-16\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"844795\",\"account_id\":\"raygozatorres.5\",\"Position_Code_Title\":\"Admin Software Development Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1984-11-27\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43098412596\",\"sex\":\"Male\",\"email1\":\"javier.raygoza@teleperformance.com\",\"civil_status\":\"Single\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Development Supervisor\",\"position_code_abbr_name\":\"Development Supervisor\",\"Instalacion_Id\":2,\"employee_common_name\":\"Javier Raygoza Torres\",\"manager_employee_common_name\":\"Enrique Barrera Pedraza\",\"contract_type_full_name\":\"HTC\",\"contract_type_ident\":831,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":364}]";

            ///Solicitantes
            ///rangelalonso.5            666484
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Juana Janeth Rangel Alonso\",\"ident\":666484,\"manager_ident\":844795,\"manager_first_name\":\"Javier\",\"manager_last_name\":\"Raygoza Torres\",\"payroll_number\":\"666484\",\"current_status\":\"Active\",\"hire_date\":\"2007-04-19\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"0\",\"account_id\":\"rangelalonso.5\",\"Position_Code_Title\":\"Admin Software Developer\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1979-06-11\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43997909387\",\"sex\":\"Female\",\"email1\":\"janeth.rangel@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Developer I\",\"position_code_abbr_name\":\"Developer I\",\"Instalacion_Id\":2,\"employee_common_name\":\"Juana Rangel Alonso\",\"manager_employee_common_name\":\"Javier Raygoza Torres\",\"contract_type_full_name\":\"HTC\",\"contract_type_ident\":831,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":129}]";
            ///garcialucio.5            1671994
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Jaime Antonio Garcia Lucio\",\"ident\":1671994,\"manager_ident\":687070,\"manager_first_name\":\"Sanjuana\",\"manager_last_name\":\"Jimenez Navarro\",\"payroll_number\":\"1671994\",\"current_status\":\"Active\",\"hire_date\":\"2015-05-04\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":16017,\"program_name\":\"TPMX CHTMC Finance\",\"phone_ident\":\"0\",\"account_id\":\"garcialucio.5\",\"Position_Code_Title\":\"Database Services Specialist\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Infrastructure Database\",\"dob\":\"1992-03-05\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"47109241696\",\"sex\":\"Male\",\"email1\":\"jaime.garcialucio@teleperformance.com\",\"civil_status\":\"Single\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Database Administrator I\",\"position_code_abbr_name\":\"Database Administrator I\",\"Instalacion_Id\":2,\"employee_common_name\":\"Jaime Garcia Lucio\",\"manager_employee_common_name\":\"Sanjuana Jimenez Navarro\",\"contract_type_full_name\":\"HTC\",\"contract_type_ident\":831,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":351}]";
            ///barrerapedraza.5         2881731
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Enrique Gerardo Barrera Pedraza\",\"ident\":2881731,\"manager_ident\":599670,\"manager_first_name\":\"Luis Enrique\",\"manager_last_name\":\"Rosado Baez\",\"payroll_number\":\"2881731\",\"current_status\":\"Active\",\"hire_date\":\"2018-05-14\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"0\",\"account_id\":\"barrerapedraza.5\",\"Position_Code_Title\":\"Admin Software Development Sr. Manager\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1963-06-10\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43886323245\",\"sex\":\"Male\",\"email1\":\"Enrique.BarreraP@teleperformance.com\",\"civil_status\":\"Married\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Development Manager\",\"position_code_abbr_name\":\"Development Manager\",\"Instalacion_Id\":2,\"employee_common_name\":\"Enrique Barrera Pedraza\",\"manager_employee_common_name\":\"Luis Enrique Rosado Baez\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":117}]";
            ///esparza.26               1621097
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Jesus Armando Esparza Rodriguez\",\"ident\":1621097,\"manager_ident\":687070,\"manager_first_name\":\"Sanjuana\",\"manager_last_name\":\"Jimenez Navarro\",\"payroll_number\":\"1621097\",\"current_status\":\"Active\",\"hire_date\":\"2015-03-17\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"0\",\"account_id\":\"esparza.26\",\"Position_Code_Title\":\"Database Services Specialist\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Infrastructure Database\",\"dob\":\"1990-01-01\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"47079020104\",\"sex\":\"Male\",\"email1\":\"Jesus.Esparza@teleperformance.com\",\"civil_status\":\"Single\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Database Administrator I\",\"position_code_abbr_name\":\"Database Administrator I\",\"Instalacion_Id\":2,\"employee_common_name\":\"Jesus Esparza Rodriguez\",\"manager_employee_common_name\":\"Sanjuana Jimenez Navarro\",\"contract_type_full_name\":\"HTC\",\"contract_type_ident\":831,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":351}]";
            ///segoviaaguilar.5         666660
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Alfonso Fabian Segovia Aguilar\",\"ident\":666660,\"manager_ident\":650033,\"manager_first_name\":\"Braulio\",\"manager_last_name\":\"Rea Miranda\",\"payroll_number\":\"666660\",\"current_status\":\"Active\",\"hire_date\":\"2007-12-14\",\"company_ident\":107,\"company_name\":\"Teleperformance MX Nearshore North\",\"location_ident\":180,\"location_name\":\"TPMXN Alpha\",\"client_ident\":191,\"client_name\":\"Teleperformance Nearshore North\",\"program_ident\":25795,\"program_name\":\"TPNSN ALPHA Finance\",\"phone_ident\":\"0\",\"account_id\":\"segoviaaguilar.5\",\"Position_Code_Title\":\"Payroll Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Payroll\",\"dob\":\"1981-05-14\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"04048138988\",\"sex\":\"Male\",\"email1\":\"fabian.segovia@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Payroll Manager\",\"position_code_abbr_name\":\"Payroll Manager\",\"Instalacion_Id\":2,\"employee_common_name\":\"Alfonso Segovia Aguilar\",\"manager_employee_common_name\":\"Braulio Rea Miranda\",\"contract_type_full_name\":\"HTG\",\"contract_type_ident\":830,\"city\":\"Zapopan\",\"state\":\"JAL\",\"position_code_type_ident\":208}]";
            ///rosadobaez.5              599670
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Luis Enrique  Rosado Baez\",\"ident\":599670,\"manager_ident\":3345712,\"manager_first_name\":\"Jose\",\"manager_last_name\":\"Guereque Flores\",\"payroll_number\":\"599670\",\"current_status\":\"Active\",\"hire_date\":\"1996-09-02\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"599670\",\"account_id\":\"rosadobaez.5\",\"Position_Code_Title\":\"Software Development Director\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1971-04-23\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"28957102222\",\"sex\":\"Male\",\"email1\":\"luis.rosado@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Director of Development\",\"position_code_abbr_name\":\"Director of Development\",\"Instalacion_Id\":2,\"employee_common_name\":\"Luis Enrique Rosado Baez\",\"manager_employee_common_name\":\"Jose Guereque Flores\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":109}]";
            ///rubiomoncayo.5              746205
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Pamela Maria Rubio Moncayo\",\"ident\":746205,\"manager_ident\":3345712,\"manager_first_name\":\"Jose\",\"manager_last_name\":\"Guereque Flores\",\"payroll_number\":\"599670\",\"current_status\":\"Active\",\"hire_date\":\"1996-09-02\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"599670\",\"account_id\":\"rubiomoncayo.5\",\"Position_Code_Title\":\"Payroll Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1971-04-23\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"28957102222\",\"sex\":\"Male\",\"email1\":\"luis.rosado@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Director of Development\",\"position_code_abbr_name\":\"Director of Development\",\"Instalacion_Id\":2,\"employee_common_name\":\"Luis Enrique Rosado Baez\",\"manager_employee_common_name\":\"Jose Guereque Flores\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":109}]";
            ///mendozarojas.7              667823
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Yesenia Mendoza Rojas\",\"ident\":667823,\"manager_ident\":3345712,\"manager_first_name\":\"Jose\",\"manager_last_name\":\"Guereque Flores\",\"payroll_number\":\"599670\",\"current_status\":\"Active\",\"hire_date\":\"1996-09-02\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"599670\",\"account_id\":\"mendozarojas.7\",\"Position_Code_Title\":\"Payroll Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1971-04-23\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"28957102222\",\"sex\":\"Male\",\"email1\":\"luis.rosado@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Director of Development\",\"position_code_abbr_name\":\"Director of Development\",\"Instalacion_Id\":2,\"employee_common_name\":\"Luis Enrique Rosado Baez\",\"manager_employee_common_name\":\"Jose Guereque Flores\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":109}]";

            ///Autorizantes
            ///guerrerolopez.8          960310
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Alfredo  Guerrero Lopez\",\"ident\":960310,\"manager_ident\":844795,\"manager_first_name\":\"Javier\",\"manager_last_name\":\"Raygoza Torres\",\"payroll_number\":\"960310\",\"current_status\":\"Active\",\"hire_date\":\"2013-01-02\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":19207,\"program_name\":\"TPMX CHTMC Technology \",\"phone_ident\":\"960310\",\"account_id\":\"guerrerolopez.8\",\"Position_Code_Title\":\"Admin Software Developer\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1983-09-02\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43078301157\",\"sex\":\"Male\",\"email1\":\"alfredo.guerrero@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Developer I\",\"position_code_abbr_name\":\"Developer I\",\"Instalacion_Id\":2,\"employee_common_name\":\"Alfredo Guerrero Lopez\",\"manager_employee_common_name\":\"Javier Raygoza Torres\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":129}]";
            ///navarroloera.5           666336
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Carlos Adrian Navarro Loera\",\"ident\":666336,\"manager_ident\":666335,\"manager_first_name\":\"Carlos\",\"manager_last_name\":\"Nolasco Cruz\",\"payroll_number\":\"666336\",\"current_status\":\"Active\",\"hire_date\":\"1997-12-22\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":19207,\"program_name\":\"TPMX CHTMC Technology \",\"phone_ident\":\"666336\",\"account_id\":\"navarroloera.5\",\"Position_Code_Title\":\"Software Development Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1975-05-08\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43917598005\",\"sex\":\"Male\",\"email1\":\"carlos.navarro@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Development Supervisor\",\"position_code_abbr_name\":\"Development Supervisor\",\"Instalacion_Id\":2,\"employee_common_name\":\"Carlos Navarro Loera\",\"manager_employee_common_name\":\"Carlos Nolasco Cruz\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":364}]";
            ///villarreal.144           666229
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Miguel Angel Villarreal Mancha\",\"ident\":666229,\"manager_ident\":666336,\"manager_first_name\":\"Carlos\",\"manager_last_name\":\"Navarro Loera\",\"payroll_number\":\"666229\",\"current_status\":\"Active\",\"hire_date\":\"2007-01-15\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":19207,\"program_name\":\"TPMX CHTMC Technology \",\"phone_ident\":\"666229\",\"account_id\":\"villarreal.144\",\"Position_Code_Title\":\"Software Developer\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1970-03-25\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"03917025086\",\"sex\":\"Male\",\"email1\":\"miguel.villarrealmancha@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Developer I\",\"position_code_abbr_name\":\"Developer I\",\"Instalacion_Id\":2,\"employee_common_name\":\"Miguel Villarreal Mancha\",\"manager_employee_common_name\":\"Carlos Navarro Loera\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":129}]";
            ///lopezserna.6             893576
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Gaudencio  Lopez Serna\",\"ident\":893576,\"manager_ident\":870481,\"manager_first_name\":\"Lidia\",\"manager_last_name\":\"Bernal Garcia\",\"payroll_number\":\"893576\",\"current_status\":\"Active\",\"hire_date\":\"2006-06-11\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":19207,\"program_name\":\"TPMX CHTMC Technology \",\"phone_ident\":\"893576\",\"account_id\":\"lopezserna.6\",\"Position_Code_Title\":\"Application Support Specialist\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1986-01-22\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43058655184\",\"sex\":\"Male\",\"email1\":\"gaudencio.lopez@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Development Application Analyst\",\"position_code_abbr_name\":\"Development Application Analyst\",\"Instalacion_Id\":2,\"employee_common_name\":\"Gaudencio Lopez Serna\",\"manager_employee_common_name\":\"Lidia Bernal Garcia\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":469}]";
            ///navarrogutierrez.6       666386
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Maydelline Elizabeth Navarro Gutierrez\",\"ident\":666386,\"manager_ident\":3345712,\"manager_first_name\":\"Jose\",\"manager_last_name\":\"Guereque Flores\",\"payroll_number\":\"599670\",\"current_status\":\"Active\",\"hire_date\":\"1996-09-02\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"599670\",\"account_id\":\"navarrogutierrez.6\",\"Position_Code_Title\":\"Payroll Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1971-04-23\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"28957102222\",\"sex\":\"Male\",\"email1\":\"luis.rosado@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Director of Development\",\"position_code_abbr_name\":\"Director of Development\",\"Instalacion_Id\":2,\"employee_common_name\":\"Luis Enrique Rosado Baez\",\"manager_employee_common_name\":\"Jose Guereque Flores\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":109}]";
            ///cantulozano.5            668221
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Mario Alberto Cantu Lozano\",\"ident\":668221,\"manager_ident\":3345712,\"manager_first_name\":\"Jose\",\"manager_last_name\":\"Guereque Flores\",\"payroll_number\":\"599670\",\"current_status\":\"Active\",\"hire_date\":\"1996-09-02\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPMX CHTMC IT Development\",\"phone_ident\":\"599670\",\"account_id\":\"cantulozano.5\",\"Position_Code_Title\":\"Payroll Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1971-04-23\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"28957102222\",\"sex\":\"Male\",\"email1\":\"luis.rosado@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Director of Development\",\"position_code_abbr_name\":\"Director of Development\",\"Instalacion_Id\":2,\"employee_common_name\":\"Luis Enrique Rosado Baez\",\"manager_employee_common_name\":\"Jose Guereque Flores\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":109}]";

            ///Responsables
            ///cavazosaranda.5          656654
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Mireya  Cavazos Aranda\",\"ident\":656654,\"manager_ident\":1993069,\"manager_first_name\":\"Emilio\",\"manager_last_name\":\"Torres Flores\",\"payroll_number\":\"656654\",\"current_status\":\"Active\",\"hire_date\":\"2003-05-21\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":315,\"location_name\":\"TPMXN Universidad\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":16053,\"program_name\":\"TPMX NICLS Payroll \",\"phone_ident\":\"656654\",\"account_id\":\"cavazosaranda.5\",\"Position_Code_Title\":\"Payroll Sr. Manager\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Payroll\",\"dob\":\"1975-10-27\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"03977531270\",\"sex\":\"Female\",\"email1\":\"mireya.cavazos@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Payroll Manager\",\"position_code_abbr_name\":\"Payroll Manager\",\"Instalacion_Id\":2,\"employee_common_name\":\"Mireya Cavazos Aranda\",\"manager_employee_common_name\":\"Emilio Torres Flores\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":208}]";
            ///floresluna.5            910749
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Juan Carlos Flores Luna\",\"ident\":910749,\"manager_ident\":910622,\"manager_first_name\":\"Lorena\",\"manager_last_name\":\"Rodriguez Lara\",\"payroll_number\":\"910749\",\"current_status\":\"Active\",\"hire_date\":\"2002-06-11\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":317,\"location_name\":\"TPMXN Cuauhtemoc\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":16014,\"program_name\":\"TPMX CHTMC Payroll \",\"phone_ident\":\"0\",\"account_id\":\"floresluna.5\",\"Position_Code_Title\":\"IMSS Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Payroll\",\"dob\":\"1976-08-05\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"47947652724\",\"sex\":\"Male\",\"email1\":\"jcflores@tpmex.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Payroll Coordinator\",\"position_code_abbr_name\":\"Payroll Coordinator\",\"Instalacion_Id\":2,\"employee_common_name\":\"Juan Flores Luna\",\"manager_employee_common_name\":\"Lorena Rodriguez Lara\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":473}]";
            ///fuenteszavala.6         910754
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Tania Citlalli Fuentes Zavala\",\"ident\":910754,\"manager_ident\":910754,\"manager_first_name\":\"Karla\",\"manager_last_name\":\"Rodriguez Horabuena\",\"payroll_number\":\"910754\",\"current_status\":\"Active\",\"hire_date\":\"2005-10-11\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":315,\"location_name\":\"TPMXN Universidad\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":16053,\"program_name\":\"TPMX NICLS Payroll \",\"phone_ident\":\"910754\",\"account_id\":\"fuenteszavala.6\",\"Position_Code_Title\":\"Payroll Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Payroll\",\"dob\":\"1980-10-17\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"03968033831\",\"sex\":\"Female\",\"email1\":\"Tania.Fuentes@teleperformance.com\",\"civil_status\":\"Unknown\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Payroll Coordinator\",\"position_code_abbr_name\":\"Payroll Coordinator\",\"Instalacion_Id\":2,\"employee_common_name\":\"Tania Fuentes Zavala\",\"manager_employee_common_name\":\"Karla Rodriguez Horabuena\",\"contract_type_full_name\":\"ICISA\",\"contract_type_ident\":547,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":473}]";
            ///rodriguezhorabuena.5    910707
            json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Karla Rodriguez Horabuena\",\"ident\":910707,\"manager_ident\":650033,\"manager_first_name\":\"Braulio\",\"manager_last_name\":\"Rea Miranda\",\"payroll_number\":\"910707\",\"current_status\":\"Active\",\"hire_date\":\"2008-10-15\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":315,\"location_name\":\"TPMXN Universidad\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPNSN CUERV Finance\",\"phone_ident\":\"0\",\"account_id\":\"gutierrezaguirre.5\",\"Position_Code_Title\":\"Admin Software Development Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1984-11-27\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43098412596\",\"sex\":\"Male\",\"email1\":\"javier.raygoza@teleperformance.com\",\"civil_status\":\"Single\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Development Supervisor\",\"position_code_abbr_name\":\"Development Supervisor\",\"Instalacion_Id\":2,\"employee_common_name\":\"Javier Raygoza Torres\",\"manager_employee_common_name\":\"Enrique Barrera Pedraza\",\"contract_type_full_name\":\"HTC\",\"contract_type_ident\":831,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":364}]";
            ///gutierrezaguirre.5              667412
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Rafael Gutierrez Aguirre\",\"ident\":667412,\"manager_ident\":650033,\"manager_first_name\":\"Braulio\",\"manager_last_name\":\"Rea Miranda\",\"payroll_number\":\"667412\",\"current_status\":\"Active\",\"hire_date\":\"2008-10-15\",\"company_ident\":109,\"company_name\":\"Teleperformance MX NSC Monterrey\",\"location_ident\":315,\"location_name\":\"TPMXN Universidad\",\"client_ident\":307,\"client_name\":\"Teleperformance Mexico\",\"program_ident\":49669,\"program_name\":\"TPNSN CUERV Finance\",\"phone_ident\":\"0\",\"account_id\":\"gutierrezaguirre.5\",\"Position_Code_Title\":\"Admin Software Development Coordinator\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Development Developer\",\"dob\":\"1984-11-27\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43098412596\",\"sex\":\"Male\",\"email1\":\"javier.raygoza@teleperformance.com\",\"civil_status\":\"Single\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Development Supervisor\",\"position_code_abbr_name\":\"Development Supervisor\",\"Instalacion_Id\":2,\"employee_common_name\":\"Javier Raygoza Torres\",\"manager_employee_common_name\":\"Enrique Barrera Pedraza\",\"contract_type_full_name\":\"HTC\",\"contract_type_ident\":831,\"city\":\"Monterrey\",\"state\":\"NLE\",\"position_code_type_ident\":364}]";

            /// No aplican como responsables
            ///torresflores.17          1993069
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Emilio  Torres Flores\",\"ident\":1993069,\"manager_ident\":1213638,\"manager_first_name\":\"Rogelio\",\"manager_last_name\":\"Cavazos Davila\",\"payroll_number\":\"1993069\",\"current_status\":\"Active\",\"hire_date\":\"2016-03-01\",\"company_ident\":107,\"company_name\":\"Teleperformance MX Nearshore North\",\"location_ident\":497,\"location_name\":\"TPMXN VAO\",\"client_ident\":191,\"client_name\":\"Teleperformance Nearshore North\",\"program_ident\":25829,\"program_name\":\"TPNSN HQUAR Finance\",\"phone_ident\":\"0\",\"account_id\":\"torresflores.17\",\"Position_Code_Title\":\"Business Evolution VP\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Finance\",\"dob\":\"1963-11-21\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"43856313366\",\"sex\":\"Male\",\"email1\":\"EMILIO.TORRES@teleperformance.com\",\"civil_status\":\"Married\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Vice President of Finance\",\"position_code_abbr_name\":\"Vice President of Finance\",\"Instalacion_Id\":2,\"employee_common_name\":\"Emilio Torres Flores\",\"manager_employee_common_name\":\"Rogelio Cavazos Davila\",\"contract_type_full_name\":\"HTG MTY\",\"contract_type_ident\":1580,\"city\":\"Garza Garcia\",\"state\":\"NLE\",\"position_code_type_ident\":158}]";
            ///leonbarrera.6            2087374
            ///json = "[{\"Ccmspassword\":null,\"Ccmsusername\":null,\"Name\":\"Ana Silvia Leon Barrera\",\"ident\":2087374,\"manager_ident\":1993069,\"manager_first_name\":\"Emilio\",\"manager_last_name\":\"Torres Flores\",\"payroll_number\":\"2087374\",\"current_status\":\"Active\",\"hire_date\":\"2016-05-16\",\"company_ident\":107,\"company_name\":\"Teleperformance MX Nearshore North\",\"location_ident\":497,\"location_name\":\"TPMXN VAO\",\"client_ident\":191,\"client_name\":\"Teleperformance Nearshore North\",\"program_ident\":25829,\"program_name\":\"TPNSN HQUAR Finance\",\"phone_ident\":\"0\",\"account_id\":\"leonbarrera.6\",\"Position_Code_Title\":\"Business Evolution Sr. Consultant\",\"Position_Code_Group\":\"\",\"Position_Code_Department\":\"Business Operations\",\"dob\":\"1972-05-15\",\"ETN_type\":\"IMSS\",\"ETN_flag\":\"03967260336\",\"sex\":\"Female\",\"email1\":\"Ana.Leon@teleperformance.com\",\"civil_status\":\"Married\",\"phone_number\":\"\",\"pay_type\":\"\",\"benefit_schedule\":\"\",\"changes\":null,\"position_code_company_name\":null,\"position_code_full_name\":\"Business Optimization Manager\",\"position_code_abbr_name\":\"Business Optimization Manager\",\"Instalacion_Id\":2,\"employee_common_name\":\"Ana Leon Barrera\",\"manager_employee_common_name\":\"Emilio Torres Flores\",\"contract_type_full_name\":\"ICISA - Indefinite\",\"contract_type_ident\":144,\"city\":\"Garza Garcia\",\"state\":\"NLE\",\"position_code_type_ident\":299}]";

            List<UserViewModel> Users = JsonConvert.DeserializeObject<List<UserViewModel>>(json);

            if (Users.Count > 0)
            {
                user = Users[0];
            }

            return user;
        }
    }
}