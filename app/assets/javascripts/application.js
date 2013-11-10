// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require rails-timeago
//= require_tree .

$(function(){ $(document).foundation(); });
$('.datePicker').datepicker();

$('.next-button').click(function(){
    $('#tweet-information').hide();
    $('#tweet-information').addClass('animated bounceOutRight').hide();
    $('#additional-information').show();
    $('#additional-information').addClass('animated bounceInRight');

    if ($('#additional-information').is(':visible')) {
        $('#tweet-information').hide();
    }
    return false;
});

$('.notification-button').click(function(){
    $('.notifications-list').toggle();
});

$('.back-button').click(function(){
    $('#additional-information').hide();
    $('#tweet-information').show();
    $('#tweet-information').removeClass('bounceOutRight');
    $('#tweet-information').addClass('animated bounceInLeft');
    return false;
});



$(document).ready(function(){
    var lat =  gon.lat;
    var long = gon.long;
    var myLatlng = new google.maps.LatLng(lat,long);

    // Create an array of styles.
    var styles = [
        {
            stylers: [
                { hue: '#064472' },
                { visibility: 'simplified' },
                { gamma: 1.5 },
                { weight: .3 }
            ]
        },
        {
            elementType: 'labels',
            stylers: [
                { visibility: 'on' },
                {  color: '#ffffff' }
            ]
        },
        {
            featureType: 'water',
            stylers: [
                { color: '#064472' }
            ]
        } ,
        {
            featureType: 'landscape',
            stylers: [
                { color: '#000000' }
            ]
        },
        {
            featureType: 'road',
            stylers: [
                { color: '#064472' }
            ]
        },
        {
            featureType: 'poi',
            stylers: [
                { color: '#333333' }
            ]
        }
    ];

    // Create a new StyledMapType object, passing it the array of styles,
    // as well as the name to be displayed on the map type control.
    var styledMap = new google.maps.StyledMapType(styles,
        {name: "Styled Map"});

    var mapIcon = gon.location_marker

    // Create a map object, and include the MapTypeId to add
    // to the map type control.
    var mapOptions = {
        zoom: 16,
        center: myLatlng,
        scrollwheel: false,
        mapTypeId: google.maps.MapTypeId.HYBRID
    }
    var map = new google.maps.Map(document.getElementById('map-canvas'),
        mapOptions);

    var marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        icon: mapIcon,
        title: 'Hello World!'
    });

    //Associate the styled map with the MapTypeId and set it to display.
    map.mapTypes.set('map_style', styledMap);
    map.setMapTypeId('map_style');

    var windowHeight = $(window).height();
    $('#show-game #map-canvas').height(windowHeight - 300);
    $('#comment-column').height(windowHeight - 120);
});
