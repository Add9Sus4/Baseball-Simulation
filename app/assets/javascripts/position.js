$('.position').each(function() {
  var positionSymbol = $(this).text();
  var position = '';
  switch (positionSymbol.toLowerCase()) {
    case 'p':
      $(this).attr('data-value',1);
      position = 'Pitcher';
      break;
    case 'c':
    $(this).attr('data-value',2);
      position = 'Catcher';
      break;
    case '1b':
      $(this).attr('data-value',3);
      position = 'First Base';
      break;
    case '2b':
      $(this).attr('data-value',4);
      position = 'Second Base';
      break;
    case '3b':
      $(this).attr('data-value',5);
      position = 'Third Base';
      break;
    case 'ss':
      $(this).attr('data-value',6);
      position = 'Shortstop';
      break;
    case 'lf':
      $(this).attr('data-value',7);
      position = 'Left Field';
      break;
    case 'cf':
      $(this).attr('data-value',8);
      position = 'Center Field';
      break;
    case 'rf':
      $(this).attr('data-value',9);
      position = 'Right Field';
      break;
  }
  $(this).text(position);
});
