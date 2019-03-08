

function edit(e) {
    if (e.model.isNew() === false) {
        //var DispositionName = $("#CatProyectosId").data("kendoDropDownList");
        //var proyecto = $("#Proyecto").data("kendoDropDownList");

        //DispositionName != null ? DispositionName.enable(false) : "";
        //$("#CatProyectosId").attr("readonly", true);
        //$(e.form).find("#CatProyectosId").closest(".editor-field").prev().andSelf().remove();
        //$("#EID").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Edit");
    }
    else {
        //$("#Active").attr("disabled", "disabled");
        e.container.kendoWindow("title", "New");

    }

    //var typeValueDropDown = $("[name=Rol]").data("kendoDropDownList");

    //e.model.bind("set", function (e) {
    //    if (e.field == "Rol") {
    //        this.set(typeValueDropDown.text(), typeValueDropDown.text());
    //    }
    //});
}

//function filtroCli() {
//    return {
//        sacuaz: $("#Location").val()
//    };
//}

//function filtroPro() {
//    return {
//        sacuazLoc: $("#Location").val(),
//        sacuazCli: $("#Client").val()
//    };
//}

//function filtroDispoId() {
//    return {
//        sacuaz: $("#Program").val()
//    };
//}

//$('#Program').change(function () {

//    var selectedID = $(this).val();
//    var loc = $("#Location").val();
//    var cli = $("#Client").val();

//    $.post('@Url.Action("MyGrid", "DispositionJobsManager")/?selectedID=' + selectedID + '&loc=' + loc + "&cli=" + cli, function (data) {
//        $('#partialPlaceHolder').html(data);
//        $('#partialPlaceHolder').fadeIn('fast');
//    });

//});

//$('#Client').change(function () {
//    $('#partialPlaceHolder').empty();
//});

//$('#Location').change(function () {
//    $('#partialPlaceHolder').empty();
//});

function hola(e) {
    if ((e.type === "create" || e.type === "update")) {
        $('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();

        if (e.response.Errors === null) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Saved", "success");
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
        return (item.dirty);
    });

    for (var i = 0; i < objeto.length; i++) {

        var cols = $(rows[i]).find("td");
        //var disposition = objeto[i].Disposition;
        var displayname = objeto[i].Mercado;

        //if (disposition == "") {
        //    //grid.editCell(grid.tbody.find("tr td span").parent("td"));
        //    var notification = $("#popupNotification").data("kendoNotification");
        //    notification.show("Invalid disposition name", "error");
        //    e.preventDefault(true);
        //    valid = false;
        //    //setTimeout($.unblockUI, 1000);
        //    return false;
        //}

        //if (ValidaDisplayNameVal(displayname) != 0) {
        //    var notification = $("#popupNotification").data("kendoNotification");
        //    notification.show("El nombre del Mercado es invalido", "error");
        //    grid.editCell(grid.tbody.find("tr td span").parent("td"));
        //    e.preventDefault(true);
        //    valid = false;
        //    //setTimeout($.unblockUI, 1000);
        //    return false;
        //}
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

            //if (dispositionObj.text() == "") {
            //    var notification = $("#popupNotification").data("kendoNotification");
            //    notification.show("Invalid disposition name", "error");
            //    grid.editCell(dispositionObj);
            //    e.preventDefault(true);
            //    valid = false;
            //    //setTimeout($.unblockUI, 1000);
            //    return false;
            //}

            //if (ValidaDisplayNameVal(displaynameObj.text()) != 0) {
            //    var notification = $("#popupNotification").data("kendoNotification");
            //    notification.show("Invalid disposition values", "error");
            //    grid.editCell(displaynameObj);
            //    e.preventDefault(true);
            //    valid = false;
            //    //setTimeout($.unblockUI, 1000);
            //    return false;
            //}

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
            productnamevalidation: function (input, params) {

                //if (input.is("[name='Mercado']")) {
                //    if (ValidaDisplayNameVal(input.val()) != 0) {
                //        input.attr("validationmessage", ValidaDisplayNameVal(input.val()));
                //        return false;
                //    }
                //}

                return true;
            }
        },
        messages: { //custom rules messages
            productnamevalidation: function (input) {
                // return the message text
                return input.attr("data-val-number");
            }
        }
    });
})(jQuery, kendo);


function ValidaDisplayNameVal(obj) {
    //if (obj == "" || (obj.length > 150 || obj.length < 3) || obj.match(/^[a-z A-Z0-9 ñáéíóú\)\(]*$/) == null) {
    //    return "El nombre del Mercado debe ser entre 3 y 150 caracteres y solo se aceptan numeros,letras y parentesis.";
    //}
    //else {
    //    return 0;
    //}
}

//function sendItem() {
//    $("#Envios").removeAttr("onclick");
//    var notification = $("#popupNotification").data("kendoNotification");
//    $.post('@Url.Action("sendItem", "DispositionJobsManager")/?pro=' + $("#Program").val(), function (data) {
//        if (data == 1) {
//            notification.show("Sended", "upload-success");
//            $("#Envios").attr("onclick", "sendItem();");
//        }
//        else if (data == 2) {
//            notification.show("Without DispositionJobs active", "error");
//            $("#Envios").attr("onclick", "sendItem();");
//        }
//        else {
//            notification.show("Error sending mail", "error");
//            $("#Envios").attr("onclick", "sendItem();");
//        }
//    });
//}