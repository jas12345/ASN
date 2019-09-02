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
    $("#parent").height(document.body.offsetHeight - 140);
}

$(window).resize(function () {
    resizeWrapper();
    resizeGrid();
});

$(document).ready(function () {
    $(window).trigger("resize");
});

function errorsote(args) {

    if (args.errors) {

        $(document).ready(function () {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show(args.errors.error.errors[0], "error");
        });

    }
}

//function MandaFolio() {
//    return {

//    };
//}

//function dateFilter(e) {
//    e.element.kendoDatePicker({
//        format: "yyyy-MM-dd",
//    });
//}



//$(document).ready(function () {
//    //OcultaSave();
//    setTimeout(function () {
//        var Hoy = kendo.toString(new Date(), 'yyyy-MM-dd');
//        $("#FechaInicio").data('kendoDatePicker').value(Hoy);
//        $("#FechaCierre").data('kendoDatePicker').value(Hoy);
//    }, 0);
//});

