// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require jquery-ui
//= require_tree .

function plusMinus() {
  $('.plus-minus').each(function() {
    var val = $(this).text();
    if (val[0] == '+') {
      $(this).css({"color":"green"});
    } else if (val[0] == '-') {
      $(this).css({"color":"red"});
    } else {
      $(this).css({"color":"black"});
    }
  });
}

function localeString(x, sep, grp) {
  var sx = (''+x).split('.'), s = '', i, j;
  sep || (sep = ' '); // default seperator
  grp || grp === 0 || (grp = 3); // default grouping
  i = sx[0].length;
  while (i > grp) {
      j = i - grp;
      s = sep + sx[0].slice(j, i) + s;
      i = j;
  }
  s = sx[0].slice(0, i) + s;
  sx[0] = s;
  return sx.join('.')
}

function hotCold() {
  $('.hotcold').each(function() {
    var val = $(this).text();
    var red;
    var blue;
    var green;
    if (val > 50) {
      green = 0;
      blue = 0;
      red = (val - 50)*255/50;
    } else {
      green = 0;
      red = 0;
      blue = (50 - val)*255/50
    }
    var rgb = "rgb(" + Math.floor(red) + "," + Math.floor(green) + "," + Math.floor(blue) + ")";
    $(this).css({"color":rgb});
  });
}
