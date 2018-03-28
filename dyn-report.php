<?php
//dyn-report: used to get list of Sent emails at Dynect
//Matt Brister (matt.brister@sterlingts.com) 3/28/2018
//REQIREMENTS: php >5.3, php-curl, composer, "composer require dyninc/dyn-php", and API key.

require './vendor/autoload.php';

use Dyn\MessageManagement;
use Dyn\MessageManagement\Mail;

$mm = new MessageManagement('API_KEY');

$start = new DateTime('2018-01-01 00:00:00', new DateTimeZone('America/Los_Angeles'));
//$end = new DateTime('2018-03-28 00:00:00', new DateTimeZone('America/Los_Angeles'));
$index = 0;
do {
  $report = $mm->reports()->getSent($index, $start, $end);
  print_r($report);
  $index++;
} while ($index <= 910);
?>
