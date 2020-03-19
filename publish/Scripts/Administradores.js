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

function edit(e) {
    if (e.model.isNew() == false) {
        e.container.kendoWindow("title", "Edit");
        $("#UserCCMSId").attr("disabled", "disabled");
    }
    else {
        $("#Active").attr("disabled", "disabled");
        e.container.kendoWindow("title", "New");
    }
}

function onChangeCCMSId() {
    //debugger;

    //CCMSId = "";

    $.post(InfoCCMSID + "/?ccms=" + UserCCMSId.value, function (data) {

        //FolioSolicitud = data.FolioSolicitud;

        //UserCCMSId = data.Ident
        Nombre.value = data.Nombre;
    }).fail(function (ex) {
        //debugger;
        console.log("fail" + ex);
    });
}

function reload(e) {
    if ((e.type == "create" || e.type == "update")) {
        $('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();

        if (e.response.Errors == null) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Saved", "success");
        }
    }
}

function errores(args) {

    if (args.errors) {

        $(document).ready(function () {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show(args.errors.error.errors[0], "error");
        });

    }
}