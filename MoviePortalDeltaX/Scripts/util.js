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
            url: config.baseApiUrl + config.module + apiName,
            type: "GET",
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
    HttpPost: function (apiName, jsonObject, callbackSuccess, callbackError) {
        $.ajax({
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
