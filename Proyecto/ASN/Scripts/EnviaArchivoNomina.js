function parametroPeriodosNominaActualPasados() {
    var Active = 4;

    return {
        Active: Active
    };
}
function onDropDownChange(e) {
    PeriodoNomina_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").text();
    PeriodoNomina_Id_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").value();
}

function onEmpresaDropDownChange(e) {
    Empresa_selected = $("#ddlEmpresa").data("kendoDropDownList").text();
    EmpresaId_selected = $("#ddlEmpresa").data("kendoDropDownList").value();
}

function onClickEnviaArchivo() {
    window.location.href = '../EnviaArchivoNomina/EnviaArchivo?EmpresaIdSelected=' + EmpresaId_selected + '&PeriodoNominaIdSelected=' + PeriodoNomina_Id_selected + '&periodoNominaNombre=' + PeriodoNomina_selected;
}

