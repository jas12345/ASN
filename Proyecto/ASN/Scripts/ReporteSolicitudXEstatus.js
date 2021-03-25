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
    $("#parent").height(document.body.offsetHeight - 220);
}

$(window).resize(function () {
    resizeWrapper();
    resizeGrid();
});

$(document).ready(function () {
    $(window).trigger("resize");
    $("#paisID").closest('.k-dropdown').addClass('mandatory');
   

    //$("#FechaInicio").attr("readonly", true);
    //$("#FechaFin").attr("readonly", true);
});

function infoSolicitud() {
    if ($("#PeriodoNomina").val() == '') {
        //$("#PeriodoNomina").val() = 0
        $("#PeriodoNomina").data('kendoDropDownList').value(0)
    }
    return {
        //fechaIni: $("#FechaInicio").val(),//"2019-09-28",
        //fechaFin: $("#FechaFin").val(),//"2019-10-30"
        //city: 1,
        //site: 317,
        //solicitanteCCMSID: 1286941,
        periodoNomina: $("#PeriodoNomina").val(),
        estatusConcepto: $("#EstatusCon").val(),//"A"
        estatusSolicitud: $("#EstatusSol").val()//"A"
    };
}

function searchSolicitud() {

    $("#bar").removeClass('hidden'); 
    $('#grid').data('kendoGrid').dataSource.data([]);
    $('#grid').data('kendoGrid').dataSource.read();
    $('#grid').data('kendoGrid').refresh();
   
}
function request_end() {
    $("#bar").add("hidden");
}
function onChangePais()
{
    //$('#PeriodoNomina').data('kendoGrid').dataSource.data([]);
    $("#PeriodoNomina").data("kendoDropDownList").dataSource.read(),
    $("#PeriodoNomina").data("kendoDropDownList").refresh();
   
}

function parametrosConceptos() {   
    return {
        PaisId: $("#PaisId").val()
    }
}
