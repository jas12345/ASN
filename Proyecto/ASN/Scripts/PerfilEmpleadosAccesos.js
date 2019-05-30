$(document).ready(function () {
    //$("#Accounts").change(function () {
    //    //$('#grid').data('kendoGrid').dataSource.data([]);
    //    $('#grid').data('kendoGrid').dataSource.read();
    //    $('#grid').data('kendoGrid').refresh();
    //    // $("#Accounts").val() == "" ? $('#grisaseo').fadeOut('fast') : $('#grisaseo').fadeIn('slow');
    //    $("#Accounts").val() == "" ? $('#grisaseo').fadeOut('fast') : $('#grisaseo').fadeIn('slow');
    //});

    $("#PerfilUsuarioId").change(function () {
        debugger;
        //var grid = $("#grid").data("kendoGrid");
        //grid.clearSelection();

        if ($("#PerfilUsuarioId").val().length > 0) {
            //$('#grid').data('kendoGrid').dataSource.data([]);
            $('#grid').data('kendoGrid').dataSource.read();
            $('#grid').data('kendoGrid').refresh();

            //$("#PerfilUsuarioId").data("kendoDropDownList").dataSource._data[$("#PerfilUsuarioId").data("kendoDropDownList").selectedIndex].colour;

            //var dataItem = $("#PerfilUsuarioId").dataItem($("#PerfilUsuarioId").item.index());
            //var Valor = dataItem.val();

            ClavePerfil = "";
            NombrePerfil = "";
            TipoAccesoId = "";
            TipoAcceso = "";

            $("#lblAccesos").val('X       ' +$("#PerfilUsuarioId").val() + " Accesos: Solicitantes");
            $("#lblAccesos").text('X       ' + $("#PerfilUsuarioId").val() + " Accesos: Solicitantes");

            ClavePerfil = $("#PerfilUsuarioId").val();
            //NombrePerfil = $("#PerfilUsuarioId").data("kendoDropDownList").Valor;
            NombrePerfil = "DEMO00" + $("#PerfilUsuarioId").val();
            TipoAccesoId = "";
            //TipoAcceso = "";
            debugger;

            //rellenaPerfilTipoAcceso();

            $.post(urlPerfilTipoAcceso + "/?Perfil_Ident=" + ClavePerfil, function (data) {
                debugger;
                //ClavePerfil = data[0].Perfil_Ident;
                NombrePerfil = data.NombrePerfilEmpleados;
                TipoAccesoId = data.TipoAccesoId;
                TipoAcceso = data.Descripcion;

                $("#lblAccesos").val('X       ' + NombrePerfil + " Accesos: " + TipoAcceso);
                $("#lblAccesos").text('X       ' + NombrePerfil + " Accesos: " + TipoAcceso);

                //$("#FechaCierreAnio").val(data[0].Active);
                debugger;


            }).fail(function (ex) {
                debugger;
                console.log("fail" + ex);
            });

            //debugger;
            //$("#lblAccesos").val('X       ' + NombrePerfil + " Accesos: " + TipoAcceso);
            //$("#lblAccesos").text('X       ' + NombrePerfil + " Accesos: " + TipoAcceso);

       }
        else {
            $('#grid').data('kendoGrid').dataSource.data([]);
        }
    });

    //$("#CCMSId").kendoNumericTextBox({
    //    change: onChangeCCMSId
    //});


});

function onChangeCCMSId() {
    debugger;

    CCMSId = "";
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    CCMSId = $("#CCMSId").val();
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    rellenaEmpleadoPuestoSupervisor();
    debugger;
    $("#lblPropiedades").val(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
    $("#lblPropiedades").text(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
}


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

            var masterGrid = $("#grid").data("kendoGrid");
            var detailRows = masterGrid.element.find(".k-detail-row");
            var informacion = null;
            for (var i = 0; i < detailRows.length; i++) {
                var detailGrid = $(detailRows[i]).find(".k-grid").data("kendoGrid");
                informacion.push(detailGrid.dataSource.view());
            }

            //debugger;
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

function borrarAcceso(e) {
    e.preventDefault(); // sho J
    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));

    var Perfil_Ident = dataItem.Perfil_Ident; 
    var Ident = dataItem.Ident; 

    debugger;

    if (anioId != 0) {
        $.post(urlUpdatePerfilEmpleadosAccesos + "/?anioId=" + anioId, function (data) {
            $("#FechaInicioAnio").val(data[0].FechaInicio);
            $("#FechaCierreAnio").val(data[0].FechaCierre);
            debugger;
            var FInicioAnio = $("#FechaInicio").data("kendoDatePicker");
            var FCierreAnio = $("#FechaCierre").data("kendoDatePicker");

            FInicioAnio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            FCierreAnio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            debugger;

            if (editando === 0) {
                var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
                var fechaCierre = $("#FechaCierre").data("kendoDatePicker");
                fechaInicio.value(data[0].FechaInicio);
                fechaCierre.value(data[0].FechaCierre);
            }

        }).fail(function (ex) {
            console.log("fail" + ex);
        });
    }





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
    ////var listaEmpleados = $("#selectedEmpleados").join(", ");
    //debugger;
    //var listaSelectedEmpleados = $("#grid").data("kendoGrid").selectedKeyNames().join(", ");
    ////$("#grid").data("kendoGrid")

    //var perfil_Ident = $("#PerfilUsuarioId")[0].value;
    ////debugger;
    ////$('#kendoSeleccion')[0].textContent = listaEmpleados;
    //$.ajax({
    //    type: 'POST',
    //    url: '/PerfilEmpleadosAccesos/CreatePerfilEmpleadosAccesos',
    //    data: JSON.stringify({ "Perfil_Ident": perfil_Ident, "selectedKeyNames": listaSelectedEmpleados.trim(), "SelectedEmpleados": listaEmpleados }),
    //        //JSON.stringify({ "Perfil_Ident": perfil_Ident, "selectedKeyNames": listaEmpleados }),
    //    contentType: 'application/json; charset=utf-8',
    //    dataType: 'json',
    //    success: function (resultData) { //debugger
    //    }
    //})    
}

function onDataBound(event) {
    //var grid = event.sender;
    //var allRows = grid.items();
    //listaEmpleados = "";
    //selectedEmpleados.length = 0;
    //var totalEmpleados = 0;
    //var idField = "PerfilEmpleadoAcceso_Activo";
    //var idFieldIdent = "Ident";
    //debugger;
    //var rowsToSelect = [];
    ////debugger;
    //allRows.each(function (idx, row) {
    //    var dataItem = grid.dataItem(row);
    //    //debugger;
    //    if (dataItem[idField] != null)
    //    {
    //        if (dataItem[idField].toString() == "true") {
    //            //debugger;
    //            totalEmpleados = selectedEmpleados.push(dataItem[idFieldIdent]);
    //            rowsToSelect.push(row);
    //        }
    //        else {
    //            //debugger;
    //            totalEmpleados = selectedEmpleados.push(dataItem[idFieldIdent] * -1);
    //        }
    //    }
    //});
    ////debugger;
    //event.sender.select(rowsToSelect);

    //listaEmpleados = selectedEmpleados.join(", ")
    ////debugger;
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

function BorraEmpleadoAcceso(e) {
    e.preventDefault();
    var d = this.dataItem($(e.currentTarget).closest("tr"));
    window.location.href = urlEditar + "?id=" + d.FolioSolicitud;
}

function GuardarBorrador() {
    //debugger;
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

function rellenaEmpleadoPuestoSupervisor() {
    debugger;

        //@Perfil_Ident
        //@Ident

    if (anioId != 0) {
        $.post(urlEmpleadoPuestoSupervisor + "/?Perfil_Ident=" + Perfil_Ident + '&' + "Ident=" + Ident, function (data) {
            //$("#FechaInicioAnio").val(data[0].Ident);
            Nombre = data[0].Nombre;
            Position_Code_Ident = data[0].Position_Code_Ident;
            Position_Code_Title = data[0].Position_Code_Title;
            Manager_Ident = data[0].Manager_Ident;
            Nombre_Manager = data[0].Nombre_Manager;
            //Perfil_Ident = data[0].Perfil_Ident;
            NombrePerfil = data[0].NombrePerfilEmpleados;
            Active = data[0].Active;
            TipoAccesoId = data[0].TipoAccesoId;
            TipoAcceso = data[0].TipoAcceso;
            AccesoSolicitante = data[0].AccesoSolicitante;
            AccesoAutorizante = data[0].AccesoAutorizante;
            AccesoResponsable = data[0].AccesoResponsable;
            AccesoConsultante = data[0].AccesoConsultante;
            AccesoOtros = data[0].AccesoOtros;

        //var ClavePerfil = "";
        //var NombrePerfil = "";
        //var TipoAccesoId = "";
        //var TipoAcceso = "";

        //Ident
        //Nombre
        //Position_Code_Ident
        //Position_Code_Title
        //Manager_Ident
        //Nombre_Manager
        ////Perfil_Ident
        ////NombrePerfilEmpleados
        //Active
        ////TipoAccesoId
        ////TipoAcceso
        //AccesoSolicitante
        //AccesoAutorizante
        //AccesoResponsable
        //AccesoConsultante
        //AccesoOtros


            FInicioAnio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            FCierreAnio.setOptions({
                max: data[0].FechaCierre,
                min: data[0].FechaInicio
            });

            debugger;

            if (editando === 0) {
                var fechaInicio = $("#FechaInicio").data("kendoDatePicker");
                var fechaCierre = $("#FechaCierre").data("kendoDatePicker");
                fechaInicio.value(data[0].FechaInicio);
                fechaCierre.value(data[0].FechaCierre);
            }

        }).fail(function (ex) {
            debugger;
            console.log("fail" + ex);
        });
    }
}

function rellenaPerfilTipoAcceso() {
    var anioId = 0;
    debugger;

    anioId = $("#AnioId").val();

    if (anioId != 0) {
        $.post(urlPerfilTipoAcceso + "/?Perfil_Ident=" + ClavePerfil, function (data) {
            debugger;
            //ClavePerfil = data[0].Perfil_Ident;
            NombrePerfil = data[0].NombrePerfilEmpleados;
            TipoAccesoId = data[0].TipoAccesoId;
            TipoAcceso = data[0].Descripcion;
            //$("#FechaCierreAnio").val(data[0].Active);
        })
        .fail(function (ex) {
            console.log("fail" + ex);
        });
    }
}