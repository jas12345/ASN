//var _perfil = 0;

$(document).ready(function () {
    //$("#ViewForm").bind("click", function () {
    //    $("#window").data("kendoWindow").open();
    //    $("#ViewForm").hide();
    //});
});

function getFolio() {
    return {
        folioid: $("#folioId").val(),
    };
}

function Salvar() {
    //console.log("Salvado");
    infoEmployee();
}


function infoEmployee() {
    //$.ajax({
    //    type: "POST",
    //    url: urlSolicitudEmpleados,
    //    data: JSON.stringify({ "ccmsid": $("#CCMSIDSolicitado").val() }),
    //    contentType: 'application/json',
    //    success: function (resultData) {
    //        if (resultData.status !== "0") {
                
    //        } else {
    //            console.log("falso");
    //        }
    //    }
    //});

    //$.post(InfoCCMSID + '/?ccms=' + 844795, function (data) {
    //    var dat = data;
    //    //debugger;
    //});
}


//function GuardaEmpleadosSolicitud() {//GuardarBorrador
//    var valoresGrid = $("#grid").data("kendoGrid");
//    var listado = valoresGrid.selectedKeyNames().join(", ")
//    var solicitud = $("#SolicitudId").val();

//    continuaAccion = false;
//    if (listado !== "") {
//        $.ajax({
//            type: "POST",
//            url: urlSolicitudEmpleados,
//            data: JSON.stringify({ "solicitud": solicitud, "listaEmpleados": listado }),
//            contentType: 'application/json',
//            success: function (resultData) {
//                if (resultData.status !== "0") {
//                    continuaAccion = false;
//                    var notification = $("#popupNotification").data("kendoNotification");
//                    notification.show(resultData.responseError.Errors, "error");
//                } else {
//                    continuaAccion = true
//                    SolicitudNueva = resultData.Id;

//                    var notification = $("#popupNotification").data("kendoNotification");
//                    CargaEmpleadosSolicitud();
//                    notification.show("Procesado Correctamente", "success");
//                }
//            }
//        });
//    } else {
//        var notification = $("#popupNotification").data("kendoNotification");
//        notification.show(" Seleccione al menos 1 empleado", "error");
//    }
//}


//function Perfil() {
//    return {
//        perfil: $("#Perfil_Ident").val(),
//    };
//}
