<?php

declare(strict_types=1);

require __DIR__ . "/vendor/autoload.php";

use Monolog\Logger;
use Monolog\Level;
use Monolog\Handler\StreamHandler;
use Monolog\Formatter\JsonFormatter;
use NewRelic\Monolog\Enricher\{Handler, Processor};

$logger = new Logger("my_logger");
$logger->pushProcessor(new Processor);

// $streamHandler = new StreamHandler("php://stdout", Level::Debug);
$streamHandler = new StreamHandler("php://stdout", Level::Info);
$streamHandler->setFormatter(new JsonFormatter());
$logger->pushHandler($streamHandler);
// $logger->pushHandler(new Handler);

// Log the message
$logger->debug("This is a debug message.");
$logger->info("This is an info message.");
$logger->error("This is an error message.");
$logger->critical("This is a critical message.");

spl_autoload_register(function ($class) {
    require __DIR__ . "/$class.php";
});

header("Content-type: application/json; charset=UTF-8");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

$parts = explode("/", $uri);

if (count($parts) < 3) {
  $logger->error("URI is given wrong.");
  http_response_code(400);
  echo json_encode(["message" => "Endpoint does not exist."]);
  exit;
}

if ($parts[1] != "proxy") {
  $logger->error("Endpoint does not exist.");
  http_response_code(404);
  echo json_encode(["message" => "Endpoint does not exist."]);
  exit;
}

if ($parts[2] != "method1") {
  $logger->error("Endpoint does not exist.");
  http_response_code(404);
  echo json_encode(["message" => "Endpoint does not exist."]);
  exit;
}

if ($_SERVER["REQUEST_METHOD"] == "GET") {
  $logger->info("GET");
  http_response_code(200);
  echo json_encode(["message" => "GET"]);
  exit;
}
else if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $logger->info("POST");
  http_response_code(201);
  echo json_encode(["message" => "POST"]);
  exit;
}
