//(function () {

//    // custom checkbox
//    var CHANGE = 'change';
//    kendo.ui.plugin(kendo.ui.Widget.extend({
//        init: function (element, options) {
//            kendo.ui.Widget.fn.init.call(this, element, options);
//            this._create();
//        },
//        options: {
//            name: 'CustomCheckbox'
//        },
//        events: [
//            CHANGE],
//        enable: function (val) {
//            if (val === false) {
//                $(this.element).attr('disabled', 'disabled');
//                $(this.wrapper).addClass('k-state-disabled');
//            } else {
//                $(this.element).removeAttr('disabled');
//                $(this.wrapper).removeClass('k-state-disabled');
//            }
//        },
//        value: function (checked) {
//            var $element = $(this.element),
//                currentValue = $element.prop('checked');

//            if (typeof checked === 'boolean') {
//                if (checked !== currentValue) {
//                    $element.prop('checked', checked);
//                    this.trigger(CHANGE, {
//                        field: 'value'
//                    });
//                }
//            } else {
//                return $element.prop('checked');
//            }
//        },
//        _create: function () {
//            var me = this,
//                $element = $(me.element),
//                text = $element.data('label') || me.options.label || '';

//            me.element.prop('type', 'checkbox');
//            me.wrapper = $element.wrap('<span class="custom-k-checkbox"></span>')
//                .parent();
//            $element.after('<label>' + text + '</label>');
//            $element.siblings('label').click(function (e) {
//                $element.click();
//            });
//            $element.bind(CHANGE, function (e) {
//                //PROPAGATE EVENT TO WIDGET
//                me.trigger(CHANGE, {
//                    field: 'value'
//                });
//            });
//            if (me.options.enabled !== undefined) {
//                me.enable(me.options.enabled);
//            }
//        }
//    }));

//    $("#grid").kendoGrid({
//        dataSource: {
//            schema: {
//                model: {
//                    fields: {
//                        name: { type: 'string' },
//                        checkSample1: { type: 'bool' },
//                        checkSample2: { type: 'bool' }
//                    }
//                }
//            },
//            data: [
//                {
//                    name: "California",
//                    checkSample1: true,
//                    checkSample2: true
//                },
//                {
//                    name: "Colorado",
//                    checkSample1: false,
//                    checkSample2: true
//                },
//                {
//                    name: "Florida",
//                    checkSample1: true,
//                    checkSample2: false
//                },
//                {
//                    name: "Texas",
//                    checkSample1: false,
//                    checkSample2: false
//                }
//            ]
//        },
//        columns: [
//            { field: 'name' },
//            { field: 'checkSample1', template: '<input type="checkbox" #= checkSample1 ? \'checked="checked"\' : "" # class="chkbx" />', width: 130 },
//            { field: 'checkSample2', template: kendo.template($('#checkColumnTemplate').html()) }
//        ],
//        dataBound: function (e) {
//            e.sender.tbody.find('.grid-check-cell').each(function (cell) {
//                var cb = $('input.select-checkbox', cell).kendoCustomCheckbox({
//                    checked: cell.value,
//                    label: '',
//                    change: function (e) {
//                        var grid = $("#grid").data("kendoGrid");
//                        var checked = $(this.element).is(':checked'),
//                            row = $(this.element).closest("tr"),
//                            dataItem = grid.dataItem(row);
//                        var col = $(this.element).closest('td');
//                        var field = grid.columns[col.index()].field;
//                        dataItem[field] = checked;
//                        log(dataItem);
//                    }
//                });
//            });
//        }
//    });

//    // from Kendo documentation for checkbox editing, 
//    // modified for multiple checkbox columns
//    $("#grid .k-grid-content").on("change", "input.chkbx", function (e) {
//        var grid = $("#grid").data("kendoGrid");
//        var checked = $(this).is(':checked');
//        var col = $(this).closest('td');
//        dataItem = grid.dataItem($(e.target).closest("tr"));
//        dataItem.set(grid.columns[col.index()].field, checked);
//        log(dataItem);
//    });

//    var log = function (item) {
//        var ot = $('#changedValue');
//        ot.html(ot.html() + '<br/>' + 'checkSample1: ' + item.checkSample1 + ' checkSample2: ' + item.checkSample2);
//    }


//})()

function accion(tab)
{
    switch (tab) {
        case 1:
            $("#tab1").show();
            $("#tab2").hide();
            $("#tab3").hide();
            break;
        case 2:
            debugger;

            var masterGrid = $("#grid").data("kendoGrid");
            var detailRows = masterGrid.element.find(".k-detail-row");
            var informacion = null;
            for (var i = 0; i < detailRows.length; i++) {
                var detailGrid = $(detailRows[i]).find(".k-grid").data("kendoGrid");
                informacion.push(detailGrid.dataSource.view());
            }

            debugger;
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


var editando = 0;
var lstCountry = 0;
var dtFechaInicio = "";
var dtFechaFinal = "";
var nombrePeriodo = "";

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


function valida(e) {
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

function onChange(event) {
    var listaEmpleados = $("#grid").data("kendoGrid").selectedKeyNames().join(", ");
    //$("#grid").data("kendoGrid")

    var perfil_Ident = $("#PerfilUsuarioId")[0].value;
    debugger;
    //$('#kendoSeleccion')[0].textContent = listaEmpleados;
    $.ajax({
        type: 'POST',
        url: '/PerfilEmpleadosAccesos/CreatePerfilEmpleadosAccesos',
        data: JSON.stringify({ "Perfil_Ident": perfil_Ident, "selectedKeyNames": listaEmpleados.trim() }),
        //JSON.stringify({ "Perfil_Ident": perfil_Ident, "selectedKeyNames": listaEmpleados }),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (resultData) { debugger}
    })    
}

function onDataBound(event) {
    var grid = event.sender;
    var allRows = grid.items();
    var selectedEmpleados = [];
    var idField = "PerfilEmpleadoAcceso_Activo";

    var rowsToSelect = [];
    debugger;
    allRows.each(function (idx, row) {
        var dataItem = grid.dataItem(row);
        debugger;
        if (dataItem[idField].toString()=="true") {
            debugger;
            rowsToSelect.push(row);
        }
    });
    debugger;
    event.sender.select(rowsToSelect);
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
    var data = {};
    $.ajax({
        type: "POST",
        url: urlSolicitud,
        data: data,
        success: success,
        dataType: dataType
    });
}

