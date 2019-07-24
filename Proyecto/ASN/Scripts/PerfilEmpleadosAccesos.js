﻿$(document).ready(function () {

    $("#PerfilUsuarioId").change(function () {
        //debugger;

        if ($("#PerfilUsuarioId").val().length > 0) {
            //$('#grid').data('kendoGrid').dataSource.data([]);
            $('#grid').data('kendoGrid').dataSource.read();
            $('#grid').data('kendoGrid').refresh();

            ClavePerfil = "";
            NombrePerfil = "";
            TipoAccesoId = "";
            TipoAcceso = "";

            ClavePerfil = $("#PerfilUsuarioId").val();
            //debugger;

            //rellenaPerfilTipoAcceso();

            $.post(urlPerfilTipoAcceso + "/?Perfil_Ident=" + ClavePerfil, function (data) {
                //debugger;
                //ClavePerfil = data[0].Perfil_Ident;
                NombrePerfil = data.NombrePerfilEmpleados;
                TipoAccesoId = data.TipoAccesoId;
                TipoAcceso = data.Descripcion;

                $("#lblPerfilNombre").val(NombrePerfil);
                $("#lblPerfilNombre").text(NombrePerfil);
                $("#lblAccesosNombre").val(TipoAcceso);
                $("#lblAccesosNombre").text(TipoAcceso);

                $("#lblPerfil").show();
                $("#lblAccesos").show();


                //debugger;
                if (TipoAcceso == "Autorizante") {
                    //$("#NumeroNivel").show();
                    $("#lblEmpleadoNivel").val("    Seleccion de Empleado - Nivel");
                    $("#lblEmpleadoNivel").text("    Seleccion de Empleado - Nivel");

                    $("#NumeroNivel").data("kendoNumericTextBox").wrapper.show();

                    //var grid = $("#grid").data("kendoGrid");
                    //grid.showColumn("Nivel");

                }
                else {
                    $("#NumeroNivel").val("");
                    $("#NumeroNivel").text("");

                    $("#lblEmpleadoNivel").val("    Seleccion de Empleado");
                    $("#lblEmpleadoNivel").text("    Seleccion de Empleado");
                    //$("#NumeroNivel").hide();

                    //var grid = $("#grid").data("kendoGrid");
                    //grid.hideColumn("Nivel");

                    $("#NumeroNivel").data("kendoNumericTextBox").wrapper.hide();
                }

                //$("#FechaCierreAnio").val(data[0].Active);
                //debugger;
            }).fail(function (ex) {
                //debugger;
                console.log("fail" + ex);
            });

       }
        else {
            $('#grid').data('kendoGrid').dataSource.data([]);

            $("#lblPerfilNombre").val("");
            $("#lblPerfilNombre").text("");
            $("#lblAccesosNombre").val("");
            $("#lblAccesosNombre").text("");

            $("#lblPerfil").hide();
            $("#lblAccesos").hide();

        }
    });
});

function onChangeCCMSId() {
    //debugger;

    CCMSId = "";
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    CCMSId = $("#CCMSId").val();
    NombreEmpleado = "";
    PuestoEmpleado = "";
    SupervisorEmpleado = "";

    ClavePerfil = $("#PerfilUsuarioId").val();
    //debugger;
    //rellenaEmpleadoPuestoSupervisor();

    if ($("#CCMSId").val().length > 0) {
        //debugger;
        //$.post(urlEmpleadoPuestoSupervisor + "/?Perfil_Ident=" + ClavePerfil + '&' + "Ident=" + CCMSId, function (data) {
        $.post(urlEmpleadoPuestoSupervisor + "/?Ident=" + CCMSId, function (data) {
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

            $("#lblPropiedades").val(" CCMSId: " + CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
            $("#lblPropiedades").text(" CCMSId: " + CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);

            $("#lblCCMSIdClave").val(CCMSId);
            $("#lblCCMSIdClave").text(CCMSId);
            $("#lblEmpleadoNombre").val(Nombre);
            $("#lblEmpleadoNombre").text(Nombre);
            $("#lblPuestoNombre").val(Position_Code_Title);
            $("#lblPuestoNombre").text(Position_Code_Title);
            $("#lblSupervisorNombre").val(Nombre_Manager);
            $("#lblSupervisorNombre").text(Nombre_Manager);

            $("#lblCCMSId").show();
            $("#lblEmpleado").show();
            $("#lblPuesto").show();
            $("#lblSupervisor").show();

        }).fail(function (ex) {
            //debugger;
            console.log("fail" + ex);
        });

    }
    else {
        //$('#grid').data('kendoGrid').dataSource.data([]);

        //$("#lblPerfilNombre").val("");
        //$("#lblPerfilNombre").text("");
        //$("#lblAccesosNombre").val("");
        //$("#lblAccesosNombre").text("");


        $("#lblCCMSIdClave").val("");
        $("#lblCCMSIdClave").text("");
        $("#lblEmpleadoNombre").val("");
        $("#lblEmpleadoNombre").text("");
        $("#lblPuestoNombre").val("");
        $("#lblPuestoNombre").text("");
        $("#lblSupervisorNombre").val("");
        $("#lblSupervisorNombre").text("");

        $("#lblCCMSId").hide();
        $("#lblEmpleado").hide();
        $("#lblPuesto").hide();
        $("#lblSupervisor").hide();

    }

    //$("#lblPropiedades").val(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
    //$("#lblPropiedades").text(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
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
    //Se ejecuta Update con Active=false para eliminar el acceso respondiendo al botón Borrar
    var Active = false;

    //debugger;

    //int Perfil_Ident, int Ident, bool Active
    $.post(urlUpdatePerfilEmpleadosAccesos + "/?Perfil_Ident=" + Perfil_Ident + "&Ident=" + Ident + "&Active=" + Active, function (data) {
        //debugger;

        //if ($("#PerfilUsuarioId").val().length > 0) {

        //$('#grid').data('kendoGrid').dataSource.data([]);
        $('#grid').data('kendoGrid').dataSource.read();
        $('#grid').data('kendoGrid').refresh();

        //debugger;

    }).fail(function (ex) {
        console.log("fail" + ex);
    });

    //var validator = e.container.data('kendoValidator');

    //$('input[name="NombrePeriodo"]').blur(function () {
    //    validator.validateInput(this);
    //});

    //$('input[name="TipoPeriodo"]').change(function () {
    //    validator.validateInput(this);
    //});

    //var lstCountryIdents = $("#LstCountryIdents").data("kendoMultiSelect");

    //$("#FechaCaptura").attr("readonly", true);
    //$("#FechaCierre").attr("readonly", true);

    //if (e.model.isNew() === false) {
    //    e.container.kendoWindow("title", "Editar");

    //    var paises = e.model.CountryIdents.split(',');
    //    lstCountryIdents.value(paises);

    //    $("#FechaInicio").val(e.model.FechaInicio);
    //    $("#FechaFin").val(e.model.FechaFin);
    //    $("#FechaCaptura").val(e.model.FechaCaptura);
    //    $("#FechaCierre").val(e.model.FechaCierre);

    //    nombrePeriodo = e.model.NombrePeriodo;
    //    var anios = $("#AnioId").data("kendoDropDownList");
    //    var Periodo = $("#PeriodicidadNominaId").data("kendoDropDownList");
    //    var tipoperiodo = $("#TipoPeriodo").data("kendoDropDownList");

    //    anios.enable(false);
    //    Periodo.enable(false);
    //    tipoperiodo.enable(false);

    //    editando = 1;
    //}
    //else {
    //    e.container.kendoWindow("title", "Nuevo");
    //    editando = 0;
    //}

}

function valida(e) {
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
    //debugger;
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
    //debugger;
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
    //debugger;
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
    //debugger;
    //event.sender.select(rowsToSelect);

    //listaEmpleados = selectedEmpleados.join(", ")
    //debugger;
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



function agregaEmpleado() {
    //debugger;
    ClavePerfil = "";
    CCMSId = "";
    nivel = "";

    ClavePerfil = $("#PerfilUsuarioId").val();
    CCMSId = $("#CCMSId").val();
    nivel = $("#NumeroNivel").val();

    $.post(urlCreatePerfilEmpleadosAccesos + "/?perfil_Ident=" + ClavePerfil + "&empleadoId=" + CCMSId + "&nivel=" + nivel, function (data){
        debugger

        var notification = $("#popupNotification").data("kendoNotification");
        notification.show(data, "success");

        //Notification("Perfil empleado Accesos", mensaje)

        actualizaGrid();
    }).fail(function (ex) {
        //debugger;
        console.log("fail" + ex);
    });
}

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
    //debugger;

        //@Perfil_Ident
        //@Ident

    if (anioId != 0) {
        //$.post(urlEmpleadoPuestoSupervisor + "/?Perfil_Ident=" + Perfil_Ident + '&' + "Ident=" + Ident, function (data) {
        $.post(urlEmpleadoPuestoSupervisor + "/?Ident=" + CCMSId + '&' + "Perfil_Ident=" + ClavePerfil, function (data) {
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

            //$("#lblPropiedades").val(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);
            //$("#lblPropiedades").text(CCMSId + " Empleado: " + Nombre + ", Puesto: " + Position_Code_Title + ", Supervisor: " + Nombre_Manager);

        }).fail(function (ex) {
            //debugger;
            console.log("fail" + ex);
        });
    }
}

function rellenaPerfilTipoAcceso() {
    //debugger;

    $.post(urlPerfilTipoAcceso + "/?Perfil_Ident=" + ClavePerfil, function (data) {
        //debugger;
        //ClavePerfil = data[0].Perfil_Ident;
        NombrePerfil = data[0].NombrePerfilEmpleados;
        TipoAccesoId = data[0].TipoAccesoId;
        TipoAcceso = data[0].Descripcion;
        //$("#FechaCierreAnio").val(data[0].Active);
        $("#lblPerfilNombre").val(NombrePerfil);
        $("#lblPerfilNombre").text(NombrePerfil);
        $("#lblAccesos").val(TipoAcceso);
        $("#lblAccesos").text(TipoAcceso);

        //@Html.Label("lblPerfilNombre", ",", new { id = "lblPerfilNombre", style = "font-weight:normal" })
        //@Html.Label("lblAccesosNombre", ",", new { id = "lblAccesosNombre", style = "font-weight:normal" })

    })
    .fail(function (ex) {
        console.log("fail" + ex);
    });
}