﻿//////var tmpViewBag = '@Html.Raw(Json.Encode(ViewBag.MyObject))'; //notice I'm using ' and not "
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
        Active: Active,
        PaisId: $("#PaisId").val()
    };
};

function onDropDownChange(e) {
    PeriodoNomina_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").text();
    PeriodoNomina_Id_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").value();
}

function onClickDescargarArchivo() {
    window.location.href = '../DescargaArchivos/DownloadCSV?PeriodoNominaSelected=' + PeriodoNomina_selected + '&IdPeriodoNominaSelected=' + PeriodoNomina_Id_selected + '&EmpresaIdSelected=' + EmpresaId_selected + '&EmpresaSelected=' + Empresa_selected;
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

function onEmpresaDropDownChange(e) {
    Empresa_selected = $("#ddlEmpresa").data("kendoDropDownList").text();
    EmpresaId_selected = $("#ddlEmpresa").data("kendoDropDownList").value();
}


function onChangePais() {
    //$('#PeriodoNomina').data('kendoGrid').dataSource.data([]);
    $("#PeriodoNomina_Id").data("kendoDropDownList").dataSource.read(),
        $("#PeriodoNomina_Id").data("kendoDropDownList").refresh();

}