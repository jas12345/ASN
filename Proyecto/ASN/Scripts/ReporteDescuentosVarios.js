﻿function parametroPeriodosNominaTodos() {
    var Active = 0;

    return {
        Active: Active
    };
};

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
;

function onDropDownChange(e) {
    PeriodoNomina_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").text();
    PeriodoNomina_Id_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").value();
}

function onClickDescargarArchivo() {
    window.location.href = '../ReporteDescuentosVarios/DownloadCSV?PeriodoNominaSelected=' + PeriodoNomina_selected + '&IdPeriodoNominaSelected=' + PeriodoNomina_Id_selected + '&EmpresaIdSelected=' + EmpresaId_selected + '&EmpresaSelected=' + Empresa_selected;
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
