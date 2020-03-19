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
    if (e.model.isNew() === false) {
        $("#PeriodicidadNominaId").attr("disabled", "disabled");
        $("#Consecutivos").attr("disabled", "disabled");

        e.container.kendoWindow("title", "Editar");
    }
    else {
        e.container.kendoWindow("title", "Nuevo");

    }
}

function hola(e) {
    if (e.type === "create" || e.type === "update") {
        $('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();

        if (e.response.Errors === null) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Guardado", "success");
        }
    }
}

function errorsote(args) {

    if (args.errors) {

        $(document).ready(function () {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show(args.errors.error.errors[0], "error");
        });

    }
}

function onSave(e) {
    var hayCambios = false;
    var sonNuevos = false;
    jQuery.grep(e.sender._data, function (item) {

        if (item.dirty || item.id <= 0) {
            hayCambios = true;
        }

        if (item.id <= 0) {
            sonNuevos = true;
        }

    });

    if (hayCambios) {
        //$.blockUI({ message: null });
        if (sonNuevos) {
            handleSaveChanges(e, this);
        }
        else {
            handleEditChanges(e, this);
        }
    }
}


function handleEditChanges(e, grid) {
    var valid = true;
    var rows = grid.tbody.find("tr");
    var objeto = jQuery.grep(grid._data, function (item) {
        return item.dirty;
    });

    for (var i = 0; i < objeto.length; i++) {

        var cols = $(rows[i]).find("td");
        //var disposition = objeto[i].Disposition;
        var displayname = objeto[i].Mercado;
    }

    if (!valid) {
        e.preventDefault(true);
        //setTimeout($.unblockUI, 1000);
    }
}

function handleSaveChanges(e, grid) {
    var valid = true;
    var rows = grid.tbody.find("tr");
    for (var i = 0; i < rows.length; i++) {

        var model = grid.dataItem(rows[i]);

        var cols = $(rows[i]).find("td");
        var displaynameObj = $(cols[0]);
        //var dispositionObj = $(cols[1]);

        if (model && model.id <= 0 && valid) {

            //nothing

        }
        else {
            break;
        }
    }

    if (!valid) {
        e.preventDefault(true);
        //setTimeout($.unblockUI, 1000);
    }
}


(function ($, kendo) {
    $.extend(true, kendo.ui.validator, {
        rules: { // custom rules
            customRule1: function (input, params) {
                if (input.is("[name=PeriodicidadNominaId]") && input.val().trim() === "") {
                    return false;
                }
                if (input.is("[name=Descripcion]") && input.val().trim() === "") {
                    return false;
                }
                if (input.is("[name=Consecutivos]") && input.val().trim() === "") {
                    return false;
                }
                return true;
            },
            productnamevalidation: function (input, params) {

                return true;
            }
        },
        messages: { //custom rules messages
            customRule1: function (input) {
                return input.attr("data-val-required");
            },
            productnamevalidation: function (input) {
                // return the message text
                return input.attr("data-val-number");
            }
        }
    });
})(jQuery, kendo);
