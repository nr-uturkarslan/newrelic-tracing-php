<?php

declare(strict_types=1);

require __DIR__ . "/vendor/autoload.php";

use Monolog\Logger;
use Monolog\Handler\BufferHandler;
use NewRelic\Monolog\Enricher\{Handler, Processor};

# Init logger
$logger = new Logger("my_logger");
$logger->pushProcessor(new Processor);
$logger->pushHandler(new BufferHandler(new Handler));

spl_autoload_register(function ($class) {
    require __DIR__ . "/$class.php";
});

header("Content-type: application/json; charset=UTF-8");

$logger->info("Parsing request URI...");
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$parts = explode("/", $uri);

if ($parts[1] != "proxy") {
  $logger->error("Endpoint does not exist.");
  http_response_code(404);
  echo json_encode(["message" => "Endpoint does not exist."]);
  exit;
}
else {
  $logger->info("Request URI is parsed successfully.");
}

if ($_SERVER["REQUEST_METHOD"] == "GET") {
  $logger->info("GET endpoint is triggered. Executing...");

  $randomNumber = random_int(0, 100);
  $responseDto = array(
    "message" => "Suceeded.",
    "value" => $randomNumber,
    "tag" => "GET",
  );

  http_response_code(200);
  echo json_encode($responseDto);
  exit;
}
elseif ($_SERVER["REQUEST_METHOD"] == "POST") {
  $logger->info("POST endpoint is triggered. Executing...");
  
  $requestDto = array(
    "value" => 10,
    "tag" => "POST",
  );

  try {
    $ch = curl_init();
    $headers = array(
      "Accept: application/json",
      "Content-Type: application/json",
    );
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_URL, "http://persistence-php:80/persistence");
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $requestDto);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $result = curl_exec($ch);
    curl_close($ch);

    if ($result === FALSE) {
      $logger->error("Request to persistence service is failed.");
      http_response_code(500);
      echo json_encode(["message" => "Request to persistence service is failed."]);
    }
    else {
      http_response_code(201);
      echo $result;
    }
  }
  catch (Exception $e) {
    echo $e->getMessage();
  }
  exit;
}
else {
  http_response_code(400);
  echo json_encode(["message" => "Only GET and POST methods are allowed."]);
  exit;
}