﻿var imgSource = '';
$(function () {
    utils.closeMessage();
    $('#datetimepicker1').datetimepicker();
    $('#datetimepicker2').datetimepicker();
    document.getElementById("inp").addEventListener("change", readFile);
    utils.HttpGet("/getproducerlist", onSuccess, onError);

    $('#btnAddProducer').click(function () {
        $('#divCreateProducer').css("display", "block");
    });

    $('#btnAddActor').click(function () {
        $('#divCreateActor').css("display", "block");
    });

    $('#btnCancelProducer').click(function () {
        $('#divCreateProducer').css("display", "none");
    });

    $('#btnCancelActor').click(function () {
        $('#divCreateActor').css("display", "none");
    });

    $('#btnSaveProducer').click(function () {
        utils.closeMessage();
        var error = '';
        var pName = $('#txtProducerName').val();
        var pGender = $('input[name=radioName]:checked', '#genderButtons').val()
        var pDOB = $('#dttmProducer').val();
        var pBio = $('#txtBio').val();

        error = validateCreation(pName, pGender, pDOB, pBio);
        if (error.length > 0) {
            utils.Message(error, 'error');
            return false;
        }
        else {
            var json = {
                "PRODUCER_NAME": pName,
                "PRODUCER_GENDER": pGender,
                "PRODUCER_DOB": pDOB,
                "PRODUCER_BIO": pBio
            };
            utils.HttpPost("/createproducer", JSON.stringify(json), onSuccessCreateProducer, onError);
        }
    });

    function onSuccessCreateProducer(data) {
        if (data.Message = 'success') {
            utils.closeMessage();
            utils.Message("Producer created succssfully", "success");
            $('#divCreateProducer').css("display", "none");
            utils.HttpGet("/getproducerlist", onSuccess, onError);
        }
        else {
            utils.Message(data.MessageReason, "error");
        }
    }

    $('#btnSaveActor').click(function () {
        utils.closeMessage();
        var error = '';
        var aName = $('#txtActorName').val();
        var aGender = $('input[name=radioName]:checked', '#actorGenderButtons').val()
        var aDOB = $('#dttmActor').val();
        var aBio = $('#txtActorBio').val();

        error = validateCreation(aName, aGender, aDOB, aBio);
        if (error.length > 0) {
            utils.Message(error, 'error');
            return false;
        }
        else {
            var json = {
                "ACTOR_NAME": aName,
                "ACTOR_GENDER": aGender,
                "ACTOR_DOB": aDOB,
                "ACTOR_BIO": aBio
            };
            utils.HttpPost("/createactor", JSON.stringify(json), onSuccessCreateActor, onError);
        }
    });

    function onSuccessCreateActor(data) {
        if (data.Message = 'Success') {
            utils.closeMessage();
            utils.Message("Actor created succssfully", "success");
            $('#divCreateActor').css("display", "none");
            utils.HttpGet("/getactorlist", onSuccessActor, onError);
        }
    }

    $('#btnSubmit').click(function () {
        //e.preventDefault();
        var error = '';
        var movieName = $('#txtMovieName').val();
        var plot = $('#txtPlot').val();
        var year = $('#txtYear').val();
        var producerId = $("#ddlProducer option:selected").val();
        var actorIds = '';



        $("#ddlActors option:selected").each(function () {
            id = $(this).val();
            if (id > 0) {
                actorIds += id + ',';
            }
        });

        //alert(producerId);
        error = validate(movieName, plot, year, producerId, actorIds);

        if (error.length > 0) {
            utils.Message(error, "error");
            return false;
        }
        else {

            var json = {
                "MOVIE_NAME": movieName,
                "MOVIE_YOR": year,
                "MOVIE_PLOT": plot,
                "MOVIE_POSTER": imgSource,
                "PRODUCER_ANID": producerId,
                "ACTORS_ANIDS": actorIds

            };
            utils.HttpPost("/createmovie", JSON.stringify(json), onSuccessCreateMovie, onError);
        }

    });
});
function onSuccessCreateMovie(data) {
    utils.closeMessage();
    if (data.Message = 'success') {
        utils.Message("Created Movie Successfully");
        location.href = 'MovieList.html';
    }
    else {
        alert(data.MessageReason);
    }

}
function validate(movieName, plot, year, producerId, actorIds) {

    var error = '';
    if (movieName == undefined || movieName == '' || movieName == null)
        error += 'Movie Name cannot be empty. <br>'

    if (plot == undefined || plot == '' || plot == null)
        error += 'Plot cannot be empty. <br>'

    if (year == undefined || year == '' || year == null)
        error += 'Year cannot be empty. <br>'

    if (producerId == undefined || producerId == '' || producerId == null)
        error += 'Select producer. <br>'

    if (actorIds == undefined || actorIds == '' || actorIds == null)
        error += 'Select Actor(s). <br>'

    return error;
}

function validateCreation(pName, pGender, pDOB, pBio) {
    var error = '';
    if (pName == undefined || pName == '' || pName == null)
        error += 'Name cannot be empty. <br>'

    if (pGender == undefined || pGender == '' || pGender == null)
        error += 'Please select the gender. <br>'

    if (pDOB == undefined || pDOB == '' || pDOB == null)
        error += 'DOB cannot be empty. <br>'

    if (pBio == undefined || pBio == '' || pBio == null)
        error += 'Bio cannot be empty. <br>'
    return error;
}
function onSuccess(data) {
    if (data.Message = 'success') {
        $('#ddlProducer').empty();
        $('#ddlProducer').append($("<option selected='true' disabled/>").val("-1").html("Choose Producer"));

        $.each(JSON.parse(data.ProducerList), function (key, value) {
            $("#ddlProducer").append($("<option />").val(value.PRODUCER_ANID).html(value.PRODUCER_NAME));
        });
        utils.HttpGet("/getactorlist", onSuccessActor, onError);
    }
}
function onSuccessActor(data) {
    if (data.Message = 'success') {
        dropdown = $('#ddlActors');
        dropdown.empty();
        dropdown.prop('selectedIndex', 0);
        $.each(JSON.parse(data.ActorsList), function (index, value) {
            dropdown.append($('<option></option>').attr('value', value.ACTOR_ANID).text(value.ACTOR_NAME));
        });
    }
}
function onError(data) {
    alert(JSON.stringify(data));
}


function readFile() {

    if (this.files && this.files[0]) {

        var FR = new FileReader();

        FR.addEventListener("load", function (e) {
            imgSource = e.target.result;
        });

        FR.readAsDataURL(this.files[0]);
    }

}