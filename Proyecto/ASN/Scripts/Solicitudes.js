
var editando = 0;
var lstCountry = 0;
var dtFechaInicio = "";
var dtFechaFinal = "";
var nombrePeriodo = "";
var continuaAccion = false;
var SolicitudNueva = 0;
var _perfil = 0;

$(document).ready(function () {
    $("#ViewForm").bind("click", function () {
        $("#window").data("kendoWindow").open();
        $("#ViewForm").hide();
    });
});

function accion(tab)
{
    switch (tab) {
        case 1:
            $("#tab1").show();
            $("#tab2").hide();
            $("#tab3").hide();
            break;
        case 2:
            var informacion = null;

            GuardaEmpleadosSolicitud();
            if (continuaAccion) {
                $("#tab2").show();
                $("#tab1").hide();
                $("#tab3").hide();
            }
            
            break;
        case 3:
            CargaEmpleadosAutorizadores();
            $("#tab3").show();
            $("#tab1").hide();
            $("#tab2").hide();
            break;
        case 4:
            GuardaEmpleadosSolicitud();
            $("#tab1").hide();
            $("#tab2").hide();
            $("#tab3").hide();
            setTimeout('redirectDefault()', 2000); 
            
            break;
        case 5:
            redirectDefault();
            $("#tab2").hide();
            $("#tab1").hide();
            $("#tab3").hide();
            break;
        case 6:
            EnviarSolicitud();
            $("#tab2").hide();
            $("#tab1").hide();
            $("#tab3").hide();
            break;
    }
}

function edit(e) {

    if (e.model.isNew() === false) {
        e.container.kendoWindow("title", "Editar");
        editando = 1;
    }
    else {
        e.container.kendoWindow("title", "Nuevo");
        editando = 0;
    }
}

function valida(e) {
    if (e.type === "create" || e.type === "update") {
        $('#gridEmpleados').data('kendoGrid').dataSource.data([]);
        $('#gridEmpleados').data('kendoGrid').dataSource.read();
        $('#gridEmpleados').data('kendoGrid').refresh();

        if (e.response.Errors === null) {
            continuaAccion = true;
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
    debugger;
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
    debugger;
    var valid = true;
    var rows = grid.tbody.find("tr");
    for (var i = 0; i < rows.length; i++) {

        var model = grid.dataItem(rows[i]);

        var cols = $(rows[i]).find("td");
        var displaynameObj = $(cols[0]);
        //var dispositionObj = $(cols[1]);

        if (model && model.id <= 0 && valid) {
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
                debugger;
                if (input.is("[name=Autorizador_Ident]") && input.val().trim() === "") {
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

function validacheckdefault(e) {
    var grid = this;
    var rows = grid.items();
    $(rows).each(function (e) {
        var row = this;
        var dataItem = grid.dataItem(row);

        if (dataItem.Existe) {
            grid.select(row);
        }
    });
}

//Inicio Parametros
function GetPerfil() {
    debugger;
    return {
        perfil: _perfil,
        solicitud: $("#SolicitudId").val()
    };
}

function Perfil() {
    return {
        perfil: $("#Perfil_Ident").val(),
    }
}

function PerfilSolicitud() {
    debugger;
    return {
        perfilBase: $("#PeriodoId").val()
    }
}

function GetAutorizador() {
    return {
        solicitud: $("#SolicitudId").val(),
        Autorizador_Id: $("#Autorizador_Ident").val()
    };
}
function GetSolicitudId() {

    if (SolicitudNueva ===0) {
        SolicitudNueva = $("#idSolicitud").val();
    }

    return {
        SolicitudId: SolicitudNueva
    };
}

function GetSolicitudAutoriza() {
    return {
        SolicitudId: $("#SolicitudId").val()
    };
}

function GetParametrosAlta() {

    var valoresGrid = $("#gridEmpleados").data("kendoGrid");
    var listado = valoresGrid.selectedKeyNames().join(", ")

    return {
        aplicaTodos: $("#TTConceptoMotivoId").is(':checked'),
        listEmpleados: listado,
        listConceptosMotivo: listado
    };
}

function GetParametros() {
    return {
        TTConceptoMotivoId: $("#TTConceptoMotivoId").is(':checked'),
        TTManager_Ident: $("#TTManager_Ident").is(':checked'),
        TTMonto: $("#TTMonto").is(':checked'),
        TTDetalle: $("#TTDetalle").is(':checked'),
        TTPeriodoNomina: $("#TTPeriodoNomina").is(':checked')
    };
}
// FIn Parametros

function GuardaEmpleadosSolicitud() {//GuardarBorrador
    var valoresGrid = $("#grid").data("kendoGrid");
    var listado = valoresGrid.selectedKeyNames().join(", ")
    var solicitud = $("#SolicitudId").val();

    continuaAccion = false;
    if (listado !== "") {
        $.ajax({
            type: "POST",
            url: urlSolicitudEmpleados,
            data: JSON.stringify({ "solicitud": solicitud, "listaEmpleados": listado }),
            contentType: 'application/json',
            success: function (resultData) {
                if (resultData.status !== "0") {
                    continuaAccion = false;
                    var notification = $("#popupNotification").data("kendoNotification");
                    notification.show(resultData.responseError.Errors, "error");
                } else {
                    continuaAccion = true
                    SolicitudNueva = resultData.Id;

                    var notification = $("#popupNotification").data("kendoNotification");
                    CargaEmpleadosSolicitud();
                    notification.show("Procesado Correctamente", "success");
                }
            }
        });
    } else {
        var notification = $("#popupNotification").data("kendoNotification");
        notification.show(" Seleccione al menos 1 empleado", "error");
    }
}

function CargaEmpleadosSolicitud() {
    $.ajax({
        url: '/EmpleadosSolicitudes/MuestraEmpleados?id=' + SolicitudNueva + "&perfilId=" + $("#PeriodoId").val(),
            contentType: 'application/html; charset=utf-8',
            type: 'GET',
            dataType: 'html'
        })
        .success(function (result) {
            $('#cuerpo2').html(result);

            $("#tab1").hide();
            $("#tab3").hide();
            $("#tab2").show();
        })
        .error(function (xhr, status) {
            alert(status);
        }) 
}

function CargaEmpleadosAutorizadores() {
    var solicitud = $("#SolicitudId").val();
    var perfil = $("#idPerfil").val();
    debugger;
    $.ajax({
        url: urlGridEmpleadosAutorizadores + '?id=' + solicitud + "&perfil=" + perfil,
        contentType: 'application/html; charset=utf-8',
        type: 'GET',
        dataType: 'html'
    })
        .success(function (result) {
            $('#cuerpo3').html(result);
        })
        .error(function (xhr, status) {
            alert(status);
        }) 
}

function GetParametros() {
    return {
        TTConceptoMotivoId: $('input#TTConceptoMotivoId').is(':checked').toString(),
        TTManager_Ident: $("#TTManager_Ident").is(':checked').toString(),
        TTMonto: $("#TTMonto").is(':checked').toString(),
        TTDetalleId: $("#TTDetalleId").is(':checked').toString(),
        TTPeriodoNomina: $("#TTPeriodoNomina").is(':checked').toString()
    };
}

function EditaSolicitud(e) {
    e.preventDefault();
    var d = this.dataItem($(e.currentTarget).closest("tr"));
    window.location.href = urlEditar +"?id="+ d.FolioSolicitud;
}


//#Inicio Funciones de Solicitud
function GetInformacionPerfil() {

    $(".infoPerfil").hide();

    $.ajax({
        url: '/Solicitudes/GetPerfil?perfilId=' + $("#Perfil_Ident").val(),
        contentType: 'application/json; charset=utf-8',
        type: 'POST',
        dataType: 'JSON'
    })
        .success(function (result) {

            if (result !== "") {
                var pais = (result.City_Name == "-1" || result.City_Name === null ? "TODOS" : result.City_Name);
                var site = (result.Location_Name == "-1" || result.Location_Name === null ? "TODOS" : result.Location_Name);
                var cliente = (result.Client_Name === "-1" || result.Client_Name === null ? "TODOS" : result.Client_Name);
                var programa = (result.Program_Name === '-1' || result.Program_Name === null ? "TODOS" : result.Program_Name);


                $("#Formulario input#FechaSolicitud").val();
                $("#Formulario #paisName").val(pais);
                $("#Formulario #siteName").val(site);
                $("#Formulario #clienteName").val(cliente);
                $("#Formulario input#programaName").val(programa);

                $("#Formulario input#FechaSolicitud").attr("disabled", "disabled");
                $("#Formulario #paisName").attr("disabled", "disabled");
                $("#Formulario #siteName").attr("disabled", "disabled");
                $("#Formulario #clienteName").attr("disabled", "disabled");
                $("#Formulario input#programaName").attr("disabled", "disabled");

                $(".infoPerfil").show();
            } else {
                $(".infoPerfil").hide();
            }

        })
        .error(function (xhr, status) {
            alert(status);
        })
}

function SaveSolicitud() {

    var formdata = new FormData($('#Formulario').get(0));
    $.ajax({
        type: "POST",
        url: urlCrearSolicitud,
        data: formdata,
        dataType: "json",
        processData: false, 
        contentType: false,
        success: function (response) {
            //debugger;
            if (response.success) {
                notification.show("Procesado Correctamente", "success");
                window.location.href = response.url;
                        }
            else if (!response.success) {
                hideKendoLoading();
                
                $('html, body').animate({ scrollTop: (0) }, 1000);
                $('#popupDiv').animate({ scrollTop: (0) }, 1000);
                var errorMsg = response.message;
                $('#divMessage').html(errorMsg).attr('class', 'alert alert-danger fade in');
                $('#divMessage').show();
            }
            else {
                var errorMsg = null;
                $('#divMessage').html(errorMsg).attr('class', 'empty-alert');
                $('#divMessage').hide();
            }
        }
    });

}

function redirectDefault() {
    window.location.href = urlDefault;
}

function EnviarSolicitud() {
    $.ajax({
        type: "POST",
        url: urlEnviaSolicitud + "?solicitud="+ $("#SolicitudId").val(),
        dataType: "json",
        success: function (response) {
            debugger;
            var notification = $("#popupNotification").data("kendoNotification");
            if (response.status == 0) {
                notification.show("Procesado Correctamente", "success");
                $("#tab1").html("");
                $("#tab2").html("");
                //window.location.href = response.url;
                setTimeout('redirectDefault()', 1000); 
            }
            else if (response.status != 0) {
                hideKendoLoading();

                $('html, body').animate({ scrollTop: (0) }, 1000);
                $('#popupDiv').animate({ scrollTop: (0) }, 1000);
                var errorMsg = response.Errors;
                $('#divMessage').html(errorMsg).attr('class', 'alert alert-danger fade in');
                $('#divMessage').show();
            }
            else {
                var errorMsg = null;
                $('#divMessage').html(errorMsg).attr('class', 'empty-alert');
                $('#divMessage').hide();
            }
        },
        error: function (response) {
            var notification = $("#popupNotification").data("kendoNotification");
            notification.show("Ocurrio un problema durante el proceso. Intente de nuevo más tarde.","error");
            setTimeout('redirectDefault()', 1000); 
        }
    });
}