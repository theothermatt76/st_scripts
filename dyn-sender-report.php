<?php
//dyn-sender-report: used to get list of approved senders at Dynect
//Matt Brister (matt.brister@sterlingts.com) 3/28/2018
//REQIREMENTS: php >5.3, php-curl, composer, "composer require dyninc/dyn-php", and API key.

require './vendor/autoload.php';

use Dyn\MessageManagement;
use Dyn\MessageManagement\Mail;

$mm = new MessageManagement('API_KEY');

$startIndex = 0;
do {
  $report = $mm->senders()->get($startIndex);
  print_r($report);
  $startIndex++;
} while ($startIndex <= 900);
?>
