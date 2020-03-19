function resizeGrid() {
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

    //$("#FechaInicio").attr("readonly", true);
    //$("#FechaFin").attr("readonly", true);
});

function infoSolicitud() {
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
    $('#grid').data('kendoGrid').dataSource.data([]);
    $('#grid').data('kendoGrid').dataSource.read();
    $('#grid').data('kendoGrid').refresh();
}