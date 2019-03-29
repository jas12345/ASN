﻿

function edit(e) {

    var validator = e.container.data('kendoValidator');

    $('input[name="Descripcion"]').blur(function () {
        validator.validateInput(this);
    });

    $('input[name="TipoConcepto"]').change(function () {
        validator.validateInput(this);
    });


    if (e.model.isNew() === false) {
        //var DispositionName = $("#CatProyectosId").data("kendoDropDownList");
        //var proyecto = $("#Proyecto").data("kendoDropDownList");

        //DispositionName != null ? DispositionName.enable(false) : "";
        //$("#CatProyectosId").attr("readonly", true);
        //$(e.form).find("#CatProyectosId").closest(".editor-field").prev().andSelf().remove();
        //$("#EID").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Editar");
    }
    else {
        //$("#Active").attr("disabled", "disabled");
        e.container.kendoWindow("title", "Nuevo");

    }

    //var typeValueDropDown = $("[name=Rol]").data("kendoDropDownList");

    //e.model.bind("set", function (e) {
    //    if (e.field == "Rol") {
    //        this.set(typeValueDropDown.text(), typeValueDropDown.text());
    //    }
    //});
}

function hola(e) {
    if (e.type === "create" || e.type === "update") {
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
                debugger;
                if (input.is("[name=Descripcion]") && input.val().trim() === "") {
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
                debugger;
                // return the message text
                return input.attr("data-val-required");
                //"Ingrese una descripción"
            },
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

function defaultValidate(e)
{
    debugger;
    if (typeof this.Descripcion) {
        var valor = $('input[name="Descripcion"]').val();
        if (valor !== undefined && valor.trim() !== "") {
            return true;
        } else {
            return false;
        }
    }
}