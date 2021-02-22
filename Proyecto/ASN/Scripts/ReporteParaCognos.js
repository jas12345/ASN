function parametroPeriodosNominaActualPasados() {
    var Active = 6;

    return {
        Active: Active
    };
}
function onDropDownChange(e) {
    PeriodoNomina_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").text();
    PeriodoNomina_Id_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").value();
}

function onClickEnviaArchivo() {    
    window.location.href = '../ReporteParaCognos/EnviaArchivo?PeriodoNominaIdSelected='+ PeriodoNomina_Id_selected + '&periodoNominaNombre=' + PeriodoNomina_selected;
}

