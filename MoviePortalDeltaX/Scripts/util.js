var config = {
    baseApiUrl: "/api/",
    module: "MoviePortal"
};

var flag = false;
$(function () {
    $.ajaxSetup({ cache: false });
});


var utils = {

    HttpGet: function (apiName, callbackSuccess, callbackError) {
        $.ajax({
            //beforeSend: function () {
            //    alert(1);
            //},
            url: config.baseApiUrl + config.module + apiName,
            type: "GET",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
               // alert(JSON.stringify(data));
                callbackSuccess(data);
            },
            error: function (response, status) {
                if (callbackError)
                    callbackError(response);
                else
                    utils.Message("Something went wrong! Please try again!", "error");
            }
        });
    },
    HttpPost: function (apiName, jsonObject, callbackSuccess, callbackError) {
        $.ajax({
            //beforeSend: function (xhr) {
            //    alert(1);
            //},
            url: config.baseApiUrl + config.module + apiName,
            type: "POST",
            data: jsonObject,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                callbackSuccess(data);
            },
            error: function (response, status) {
                if (callbackError)
                    callbackError(response);
                else
                    utils.Message("Something went wrong! Please try again!", "error");
            }
        });
    },

    getQueryString: function getParameterByName(name, url) {
        if (!url) {
            url = window.location.href;
        }
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },

    trimImage: function (canvas) {

        // First duplicate the canvas to not alter the original
        var croppedCanvas = document.createElement('canvas'),
            croppedCtx = croppedCanvas.getContext('2d');

        croppedCanvas.width = canvas.width;
        croppedCanvas.height = canvas.height;
        croppedCtx.drawImage(canvas, 0, 0);

        // Next do the actual cropping
        var w = croppedCanvas.width,
            h = croppedCanvas.height,
        pix = { x: [], y: [] },
            imageData = croppedCtx.getImageData(0, 0, croppedCanvas.width, croppedCanvas.height),
            x, y, index;

        for (y = 0; y < h; y++) {
            for (x = 0; x < w; x++) {
                index = (y * w + x) * 4;
                if (imageData.data[index + 3] > 0) {
                    pix.x.push(x);
                    pix.y.push(y);

                }
            }
        }
        pix.x.sort(function (a, b) {
            return a - b
        });
        pix.y.sort(function (a, b) {
            return a - b
        });
        var n = pix.x.length - 1;

        w = pix.x[n] - pix.x[0];
        h = pix.y[n] - pix.y[0];
        var cut = croppedCtx.getImageData(pix.x[0], pix.y[0], w, h);

        croppedCanvas.width = w;
        croppedCanvas.height = h;
        croppedCtx.putImageData(cut, 0, 0);

        return croppedCanvas.toDataURL();
    },

    messageTemplate: '<button id="btnCloseErrorMessg" onclick="utils.closeMessage()" type="button" class="close" style="opacity:0.5" ><span aria-hidden="true" >X</span></button><span id="spnMsg"></span>',

    Message: function (value, type) {
        if (type == 'error')
            $("#divMessage").removeClass().addClass('alertError');
        else if (type == 'success')
            $("#divMessage").removeClass().addClass('alertSuccess');

        $('#divMessage').html('').prepend(utils.messageTemplate);
        document.getElementById("spnMsg").innerHTML = value;
        $("#divMessage").show();
        var body = $("html, body");
        body.stop().animate({ scrollTop: 0 }, '500', 'swing', function () {
        });
    },

    closeMessage: function () {
        try {
            document.getElementById("spnMsg").innerHTML = "";
            $("#divMessage").fadeOut(200);
        }
        catch (err) {
        }
    },
    
    
};
