$.ajaxSetup({ cache: true});
var x;

// variables to track movements 
var latestaxelerationX = 0;
var latestaxelerationY = 0;
var latestaxelerationZ = 0;
var latestTiltLR = 0;
var latestTiltFB = 0;
var positionSet = true;

// constants that specify allowable range of movement before triggering event
var accelerationAllowed = 10;
var tiltAllowed = 10;
//var target = document.getElementById('div_to_refeshed');
//var spinner = new Spinner(opts).spin(target);
var opts = {
    lines: 13, // The number of lines to draw
    length: 20, // The length of each line
    width: 10, // The line thickness
    radius: 30, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#FFF', // #rgb or #rrggbb
    speed: 1, // Rounds per second
    trail: 60, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: 'auto', // Top position relative to parent in px
    left: 'auto' // Left position relative to parent in px
};



$(function () {
    $('#div_to_refeshed').touchwipe({
        wipeLeft: swipeleftHandler,
        wipeRight: swiperightHandler,
        min_move_x: 100,
        min_move_y: 10000,
        preventDefaultEvents: false
    });

    function swipeleftHandler() {
        reload(next_url);
    };
    function swiperightHandler() {
        reload(previous_url);
    };
    function reload(url) {
        var target = document.getElementById('div_to_refeshed');
        var spinner = new Spinner(opts);
        spinner.spin(target);
        $('#div_to_refeshed').unbind();
        $('body').load(url,
            function (responseText, textStatus, req) {
                if (textStatus == "error" || textStatus == "timeout" || textStatus == "parsererror") {
                    document.getElementById('error_on_refresh').innerHTML = 'Oops, we seem to have lost the internet connection. Unfortunately this will stop you from being able to request help, if required.';
                }
                else {
                    document.getElementById('error_on_refresh').innerHTML = '';
                }
            });
    }
//    $('#div_to_refeshed').bind(' swipeleft swipeleftup swipeleftdown', swipeleftHandler);
//    $('#div_to_refeshed').bind(' swiperight swiperightup swiperightdown', swiperightHandler);
});

function pulseBackgroundImage() {
    x = 1;
    setInterval(change, 3000);
}

function change() {
    if (x == 1) {
        x = 2;
        document.getElementsByClassName("bigpicture")[0].className = document.getElementsByClassName("bigpicture")[0].className + " lighten";
    } else {

        document.getElementsByClassName("bigpicture")[0].className =
            document.getElementsByClassName("bigpicture")[0].className.replace
                (/(?:^|\s)lighten(?!\S)/g, '');
        x = 1;
    }
}


function startUp(reminder1, reminder2, reminder3, playSound) {
    refresh_page(reminder1, reminder2, reminder3, playSound);
    setupMotionDetection();
}

function refresh_page(reminder1, reminder2, reminder3, playSound) {
    // setInterval for 60 second = 1 minute
    setInterval(function () {
        $('body').load(refresh_url,
            function (responseText, textStatus, req) {
                if (textStatus == "error" || textStatus == "timeout" || textStatus == "parsererror") {
                    document.getElementById('error_on_refresh').innerHTML = 'Oops, we seem to have lost the internet connection. Unfortunately this will stop you from being able to request help, if required.';
                }
                else {
                    document.getElementById('error_on_refresh').innerHTML = '';
                }
            });


        var clickSound = new Audio('/assets/reminder.wav');

        // code for medication reminder
        var currentdate = new Date(); 
        var currentTime = "" + currentdate.getHours() + ":" + currentdate.getMinutes();
        if (currentdate.getMinutes() == "00") {
            if (currentdate.getHours() == reminder1 || currentdate.getHours() == reminder2 || currentdate.getHours() == reminder3) {
                // play sound and give alert
                clickSound.play();
                setTimeout(function(){alert("This is a friendly reminder to take your medicine");},2000);
            } else if (playSound) {
                clickSound.play();
            }
        }
        
        // alert("The reminder is: " + reminder1 + " & current hours is " + currentdate.getHours());
    }, 60000);
}

function setupMotionDetection() {
    if (window.DeviceMotionEvent) {
        addMotionEvent();
    }
}

var motionHandler = function deviceMotionHandler(eventData) {
    // Grab the acceleration including gravity from the results
    var acceleration = eventData.accelerationIncludingGravity;

    // Display the raw acceleration data
    var rawAcceleration = "[" + Math.round(acceleration.x) + ", " +
        Math.round(acceleration.y) + ", " + Math.round(acceleration.z) + "]";

    // Z is the acceleration in the Z axis, and if the device is facing up or down
    var facingUp = -1;
    if (acceleration.z > 0) {
        facingUp = +1;
    }

    // Convert the value from acceleration to degrees acceleration.x|y is the 
    // acceleration according to gravity, we'll assume we're on Earth and divide 
    // by 9.81 (earth gravity) to get a percentage value, and then multiply that 
    // by 90 to convert to degrees.                                
    var tiltLR = Math.round(((acceleration.x) / 9.81) * -90);
    var tiltFB = Math.round(((acceleration.y + 9.81) / 9.81) * 90 * facingUp);

    if (significantMovementDetected(rawAcceleration.x, rawAcceleration.y, rawAcceleration.z, tiltLR, tiltFB)) {
        if (positionSet) {
            sendMovement();
            positionSet = false;
            window.removeEventListener('devicemotion', motionHandler, false);
            setTimeout(function(){ positionSet = true;}, 20000);
        }

        latestaxelerationX = rawAcceleration.x;
        latestaxelerationY = rawAcceleration.y;
        latestaxelerationZ = rawAcceleration.z;
        latestTiltLR = tiltLR;
        latestTiltFB = tiltFB;


    }
}
function sendMovement(){
    $.ajax({
            type: 'post',
            url: movement_url,
            timeout: 6000,
            data: {_method: 'put'}
        }
    );
}
function addMotionEvent() {
    window.addEventListener('devicemotion', motionHandler, false)
}
function significantMovementDetected(rawAccelerationX, rawAccelerationY, rawAccelerationZ, tiltLR, tiltFB) {
    return ((Math.abs(rawAccelerationX - latestaxelerationX) > accelerationAllowed) ||
        (Math.abs(rawAccelerationY - latestaxelerationY) > accelerationAllowed) ||
        (Math.abs(rawAccelerationZ - latestaxelerationZ) > accelerationAllowed) ||
        (Math.abs(tiltLR - latestTiltLR) > tiltAllowed) ||
        (Math.abs(tiltFB - latestTiltFB) > tiltAllowed));

}

function leavingPopUp() {
    alert("You are now leaving the wellbeing check website.");
}