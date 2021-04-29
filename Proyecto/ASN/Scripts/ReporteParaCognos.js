function parametroPeriodosNominaActualPasados() {
    var Active = 6;

    return {
        Active: Active,
        PaisId: $('#PaisId').val()
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
    window.location.href = '../ReporteParaCognos/EnviaArchivo?PeriodoNominaIdSelected='+ PeriodoNomina_Id_selected + '&periodoNominaNombre=' + PeriodoNomina_selected + '&EmpresaId=' + EmpresaId_selected;
}


function onChangePais() {   
    $("#PeriodoNomina_Id").data("kendoDropDownList").dataSource.read(),
        $("#PeriodoNomina_Id").data("kendoDropDownList").refresh();

}