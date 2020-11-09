﻿function resizeGrid() {
    var gridElement = $("#grid"),
        dataArea = gridElement.find(".k-grid-content"),
        gridHeight = gridElement.innerHeight(),
        otherElements = gridElement.children().not(".k-grid-content"),
        otherElementsHeight = 0;
    otherElements.each(function () {
        otherElementsHeight += $(this).outerHeight();
    });
    dataArea.height(gridHeight - otherElementsHeight);
}

function resizeWrapper() {
    $("#parent").height(document.body.offsetHeight - 150);
}

$(window).resize(function () {
    resizeWrapper();
    resizeGrid();
});

function columnas(e) {
    var columns = e.workbook.sheets[0].columns;
    columns.forEach(function (column) {
        // also delete the width if it is set
        delete column.width;
        column.autoWidth = true;
    });
}

$(document).ready(function () {
    $(window).trigger("resize");
});


//function onDropDownChange(e) {
//    PeriodoNomina_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").text();
//    PeriodoNomina_Id_selected = $("#PeriodoNomina_Id").data("kendoDropDownList").value();
//}

//function onEmpresaDropDownChange(e) {
//    Empresa_selected = $("#ddlEmpresa").data("kendoDropDownList").text();
//    EmpresaId_selected = $("#ddlEmpresa").data("kendoDropDownList").value();
//}

function infoFiltrar() {
    return {
        periodoSelected : $("#PeriodoNomina_Id").data("kendoDropDownList").text(),
        periodoNomina : $("#PeriodoNomina_Id").val(),
        empresaSelected : $("#ddlEmpresa").data("kendoDropDownList").text(),
        empresa: $("#ddlEmpresa").val()
    }
}

function onClickFiltrar() {
    //window.location.href = '../ReportePendientesAutorizarYRechazados/GetReporte?EmpresaIdSelected=' + EmpresaId_selected + '&PeriodoNominaIdSelected=' + PeriodoNomina_Id_selected ;
    $('#grid').data('kendoGrid').dataSource.data([]);
    $('#grid').data('kendoGrid').dataSource.read();
    $('#grid').data('kendoGrid').refresh();
}
