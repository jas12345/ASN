//////var tmpViewBag = '@Html.Raw(Json.Encode(ViewBag.MyObject))'; //notice I'm using ' and not "
//////var myOptions = [];

//////$(document).ready(function () {
//////    myOptions = JSON.parse(tmpViewBag); 

//////});

function parametroPeriodosNominaActualFuturos() {
    var Active = 1;

    return {
        Active: Active
    };
};

function parametroPeriodosNominaPasados() {
    var Active = 2;

    return {
        Active: Active
    };
};

function parametroPeriodosNominaFuturos() {
    var Active = 3;

    return {
        Active: Active
    };
};

function parametroPeriodosNominaActualPasados() {
    var Active = 4;

    return {
        Active: Active
    };
};

function rellenaPerfilTipoAcceso() {
    //debugger;

    $.post(urlPerfilTipoAcceso + "/?Perfil_Ident=" + ClavePerfil, function (data) {
        //debugger;
        //ClavePerfil = data[0].Perfil_Ident;
        NombrePerfil = data[0].NombrePerfilEmpleados;
        TipoAccesoId = data[0].TipoAccesoId;
        TipoAcceso = data[0].Descripcion;
        //$("#FechaCierreAnio").val(data[0].Active);
        $("#lblPerfilNombre").val(NombrePerfil);
        $("#lblPerfilNombre").text(NombrePerfil);
        $("#lblAccesos").val(TipoAcceso);
        $("#lblAccesos").text(TipoAcceso);

        //@Html.Label("lblPerfilNombre", ",", new { id = "lblPerfilNombre", style = "font-weight:normal" })
        //@Html.Label("lblAccesosNombre", ",", new { id = "lblAccesosNombre", style = "font-weight:normal" })

    })
        .fail(function (ex) {
            console.log("fail" + ex);
        });
}

function onDropDownChange(e) {
    ViewBag(strPeriodoNomina) = $("#PeriodoNomina_Id").data("ViewModel").text();
    ViewBag(intIdPeriodoNomina) = $("#PeriodoNomina_Id").data("kendoDropDownList").value();
}

function onClickDescargarArchivo() {
    TempData["Data1"] = ViewBag.intIdPeriodoNomina;
    TempData["Data2"] = ViewBag.strPeriodoNomina;
    window.location.href = '@Url.Action("DownloadCSV")';
}

function getPeriodoNomina() {
    return {
        PeriodoNomina: $("#PeriodoNomina_Id").data("kendoDropDownList").text(),
    };
}

function getPeriodoNominaId() {
    return {
        IdPeriodoNomina: $("#PeriodoNomina_Id").data("kendoDropDownList").value(),
    };
}


