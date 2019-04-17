var editando = 0;
var lstCountry = 0;
var dtFechaInicio = "";
var dtFechaFinal = "";
var nombrePeriodo = "";

function accion(tab)
{
    switch (tab) {
        case 1:
            $("#tab1").show();
            $("#tab2").hide();
            $("#tab3").hide();
            break;
        case 2:
            //debugger;

            //var masterGrid = $("#grid").data("kendoGrid");
            //var detailRows = masterGrid.element.find(".k-detail-row");
            var informacion = null;
            //for (var i = 0; i < detailRows.length; i++) {
            //    var detailGrid = $(detailRows[i]).find(".k-grid").data("kendoGrid");
            //    informacion.push(detailGrid.dataSource.view());
            //}

            GuardarBorrador();
            $("#tab2").show();
            $("#tab1").hide();
            $("#tab3").hide();
            break;
        case 3:
            $("#tab3").show();
            $("#tab1").hide();
            $("#tab2").hide();
            break;
        case 4:
            GuardarBorrador();
            $("#tab1").show();
            $("#tab2").hide();
            $("#tab3").hide();
            break;
        case 5:
            $("#tab2").show();
            $("#tab1").hide();
            $("#tab3").hide();
            break;
    }
}


function edit(e) {
    var validator = e.container.data('kendoValidator');

    $('input[name="NombrePeriodo"]').blur(function () {
        validator.validateInput(this);
    });

    $('input[name="TipoPeriodo"]').change(function () {
        validator.validateInput(this);
    });

    var lstCountryIdents = $("#LstCountryIdents").data("kendoMultiSelect");

    $("#FechaCaptura").attr("readonly", true);
    $("#FechaCierre").attr("readonly", true);

    if (e.model.isNew() === false) {
        e.container.kendoWindow("title", "Editar");

        var paises = e.model.CountryIdents.split(',');
        lstCountryIdents.value(paises);

        $("#FechaInicio").val(e.model.FechaInicio);
        $("#FechaFin").val(e.model.FechaFin);
        $("#FechaCaptura").val(e.model.FechaCaptura);
        $("#FechaCierre").val(e.model.FechaCierre);

        nombrePeriodo = e.model.NombrePeriodo;
        var anios = $("#AnioId").data("kendoDropDownList");
        var Periodo = $("#PeriodicidadNominaId").data("kendoDropDownList");
        var tipoperiodo = $("#TipoPeriodo").data("kendoDropDownList");

        anios.enable(false);
        Periodo.enable(false);
        tipoperiodo.enable(false);

        editando = 1;
    }
    else {
        e.container.kendoWindow("title", "Nuevo");
        editando = 0;
    }

}


//function valida(e) {
//    if (e.type === "create" || e.type === "update") {
//        $('#grid').data('kendoGrid').dataSource.data([]);
//        $('#grid').data('kendoGrid').dataSource.read();
//        $('#grid').data('kendoGrid').refresh();

//        if (e.response.Errors === null) {
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show("Saved", "success");
//        }
//    }
//}

//function errorsote(args) {

//    if (args.errors) {

//        $(document).ready(function () {
//            var notification = $("#popupNotification").data("kendoNotification");
//            notification.show(args.errors.error.errors[0], "error");
//        });

//    }
//}

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
                if (input.is("[name=NombrePeriodo]") && input.val().trim() === "") {
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


function actualizaGrid() {
    $("#grid").data("kendoGrid").dataSource.read();
    $("#grid").data("kendoGrid").refresh();
}

function GetPerfil() {
    return {
        perfil: $("#PerfilUsuarioId").val()
    };
}

function GuardarBorrador() {
    debugger;
    var valoresGrid = $("#grid").data("kendoGrid");
    var listado = valoresGrid.selectedKeyNames().join(", ") 
    var profiles = {
        FolioSolicitud:0,
        Fecha_Solicitud:new Date("yyyy-MM-dd"),
        Perfil_Ident : $("#PerfilUsuarioId").val()
    };
    $.ajax({
        type: "POST",
        url: urlSolicitud,
        data: JSON.stringify({ "profiles": profiles,"listaEmpleados":listado }),
        contentType: 'application/json',
        success: function (resultData) {
            alert("Save Complete");
        }        
    });
}

function onChange(arg) {
    debugger;

    var valoresGrid = $("#grid").data("kendoGrid");
    var listado = valoresGrid.selectedKeyNames();//.join(", ") 

    var selected = $.map(this.select(), function (item) {
        return $(item).text();
    });

    //kendoConsole.log("Selected: " + selected.length + " item(s), [" + selected.join(", ") + "]");
}