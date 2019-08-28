$.ajaxSetup({
    // Disable caching of AJAX responses
    cache: false
});


function gridFilterIntegerNumericTextbox(args) {
    args.element.kendoNumericTextBox({
        format: "n0",
        decimals: 0,
    });
}

function dateFilter(e) {
    e.element.kendoDatePicker({
        format: "yyyy-MM-dd",
    });
}


/* Menu Toggle Script */
$(document).ready(function () {
    var trigger = $('.hamburger'),
        overlay = $('.overlay'),
       isClosed = false;

    trigger.click(function () {
        hamburger_cross();
    });


    kendo.culture("en-US");

    function hamburger_cross() {

        if (isClosed == true) {
            overlay.hide();
            trigger.removeClass('is-open');
            trigger.addClass('is-closed');
            isClosed = false;
        } else {
            overlay.show();
            trigger.removeClass('is-closed');
            trigger.addClass('is-open');
            isClosed = true;
        }
    }

    $('[data-toggle="offcanvas"]').click(function () {
        $('#wrapper').toggleClass('toggled');
    });
});



function onShow(e) {
    if (e.sender.getNotifications().length == 1) {
        var element = e.element.parent(),
            eWidth = element.width(),
            eHeight = element.height(),
            wWidth = $(window).width(),
            wHeight = $(window).height(),
            newTop, newLeft;

        newLeft = Math.floor(wWidth / 2 - eWidth / 2);
        newTop = Math.floor(wHeight / 2 - eHeight / 2);

        e.element.parent().css({ top: newTop, left: newLeft });
    }
}


var General = {
    BASE_URL: "",

    //Muestra un mensaje cuando sea invocado
    FlashMessage: function (mensaje, cssclass) {
        //toast(mensaje, 4000, cssclass);
        alert(mensaje);
    },

    FlashMessageReload: function (mensaje, cssclass, displayLength) {
        toast(mensaje, displayLength, cssclass, function () { location.reload() });
    }

}