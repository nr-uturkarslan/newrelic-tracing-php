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

if ($parts[1] != "persistence") {
  $logger->error("Endpoint does not exist.");
  http_response_code(404);
  echo json_encode(["message" => "Endpoint does not exist."]);
  exit;
}
else {
  $logger->info("Request URI is parsed successfully.");
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $logger->info("POST endpoint is triggered. Executing...");

  $responseDto = array(
    "value" => 20,
    "tag" => "POST",
  );
  
  $logger->info("POST method is executed successfully.");

  http_response_code(201);
  echo json_encode($responseDto);
  exit;
}
else {
  $logger->warning("Only POST method is allowed.");

  http_response_code(400);
  echo json_encode(["message" => "Only POST method is allowed."]);
  exit;
}