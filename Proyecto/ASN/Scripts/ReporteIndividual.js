function resizeGrid() {
    var gridElement = $("#grid"),
        dataArea = gridElement.find(".k-grid-content"),
        gridHeight = gridElement.innerHeight(),
        otherElements = gridElement.children().not(".k-grid-content"),
        otherElementsHeight = 0;
    otherElements.each(function () {
        otherElementsHeight += $(this).outerHeight();
    });
    dataArea.height(gridHeight - otherElementsHeight);
}

function resizeWrapper() {
    $("#parent").height(document.body.offsetHeight - 150);
}

$(window).resize(function () {
    resizeWrapper();
    resizeGrid();
});

function columnas(e) {
    var columns = e.workbook.sheets[0].columns;
    columns.forEach(function (column) {
        // also delete the width if it is set
        delete column.width;
        column.autoWidth = true;
    });
}

$(document).ready(function () {
    $(window).trigger("resize");
});
