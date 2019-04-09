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

function rellenaFechasMes() {
    var anioId = 0;
    var mesId = 0;

    anioId = $("#AnioId").val();
    mesId = $("#MesId").val();

    if (anioId != 0 && mesId != 0) {
        $.post(urlFechasMes + "/?mesId=" + mesId + "&anioId=" + anioId, function (data) {

            dtFechaInicio = formatDate(data[0].FechaInicio);
            dtFechaFinal = formatDate(data[0].FechaCierre);

            var meses = $("#MesId").data("kendoDropDownList");
            var cnsecutivo = $("#ConsecutivoId").data("kendoDropDownList");

            var FInicio = $("#FechaInicio").data("kendoDatePicker");
            var FFin = $("#FechaFin").data("kendoDatePicker");

            FInicio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            FFin.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            if (editando === 0) {
                var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
                fechaInicio.value(dtFechaInicio);

                var FechaFin = $("#FechaFin").data("kendoDatePicker");
                FechaFin.value(dtFechaFinal);

                $("#FechaInicio").val(data[0].FechaInicio);
                $("#FechaFin").val(data[0].FechaCierre);
                meses.enable(true);
                cnsecutivo.enable(true);
            } else {


                meses.enable(false);
                cnsecutivo.enable(false);

                $("#NombrePeriodo").val(nombrePeriodo);
                dtFInicio = new Date(dtFechaInicio);
                dtFInicio.setDate(dtFInicio.getDate() + 1);

                FInicio.setOptions({
                    max: new Date(dtFechaFinal),
                    min: dtFInicio
                });
            }
            delimitaRango();

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}

function validando() {
    if (editando === 1) {
        var consecutivos = $("#ConsecutivoId").data("kendoDropDownList");
        var mesesId = $("#MesId").data("kendoDropDownList");
        var periodicidad = $("#PeriodicidadNominaId").data("kendoDropDownList");
        consecutivos.enable(false);
        mesesId.enable(false);
        periodicidad.enable(false);
    }
}

function delimitaRango() {
    var FInicio = $("#FechaCaptura").data("kendoDateTimePicker");
    var FFin = $("#FechaCierre").data("kendoDateTimePicker");

    var dtFInicio = "";
    var dtFinal = "";

    dtFInicio = new Date(dtFechaInicio + " 00:00");
    dtFInicio.setDate(dtFInicio.getDate());

    dtFinal = new Date(dtFechaFinal + " 23:55");
    dtFinal.setDate(dtFinal.getDate());

    FInicio.setOptions({
        max: dtFinal,
        min: dtFInicio
    });

    FFin.setOptions({
        max: dtFinal,
        min: dtFInicio
    });
}

function tipoPerio() {
    return {
        anioId: $("#AnioId").val(),
        mesId: $("#MesId").val(),
        perid: $("#PeriodicidadNominaId").val()
    };
}

function Anio() {
    return {
        anioId: $("#AnioId").val()
    };
}

function AnioMes() {
    return {
        anioId: $("#AnioId").val(),
        mesId: $("#MesId").val()
    };
}

function onChangeCountry(e) {
    if ("kendoConsole" in window) {
        var dataItem = e.dataItem;
        // kendoConsole.log("event :: select (" + dataItem.Text + " : " + dataItem.Value + ")");
        $("#CountryIdents").val(dataItem.Value);
        alert(dataItem.Value);
    }

}

function fechasValor() {
    return {
        fechainicio: $("#FechaInicio").val(),
        fechaFin: $("#FechaFin").val(),
        fechaCaptura: $("#FechaCaptura").val(),
        fechaCierre: $("#FechaCierre").val()
    };
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}

function formatDateTime(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear(),
        hour = d.getHours(),
        minutes = d.getMinutes();


    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-') + " " + hour + ":" + minutes;
}

function getName() {
    if (editando == 0) {
        var anioVl = $("#AnioId").val();
        var mesVl = $("#MesId").val();
        var periodisidadVl = $("#PeriodicidadNominaId").val();
        var consecutivoVl = $("#ConsecutivoId").val();
        var tipoPeriodoVl = $("#TipoPeriodo").val();
        mesVl = mesVl >= 1 && mesVl < 10 ? ("0" + mesVl) : mesVl;
        var propuesto = anioVl + "_" + mesVl + "_" + periodisidadVl + "_" + consecutivoVl + "_" + tipoPeriodoVl;
        var nombrePeriodo = $("#NombrePeriodo").data("TextBox");

        $("#NombrePeriodo").val(propuesto).change();
    }
}

