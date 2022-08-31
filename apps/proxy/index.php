<?php

declare(strict_types=1);

spl_autoload_register(function ($class) {
    require __DIR__ . "/$class.php";
});

header("Content-type: application/json; charset=UTF-8");

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

$parts = explode("/", $uri);

if ($parts[1] != "proxy") {
  http_response_code(404);
  echo json_encode(["message" => "Endpoint does not exist."]);
  exit;
}

if ($parts[2] != "method1") {
  http_response_code(404);
  echo json_encode(["message" => "Endpoint does not exist."]);
  exit;
}

if ($_SERVER["REQUEST_METHOD"] == "GET") {
  http_response_code(200);
  echo json_encode(["message" => "GET"]);
  exit;
}
else if ($_SERVER["REQUEST_METHOD"] == "POST") {
  http_response_code(201);
  echo json_encode(["message" => "POST"]);
  exit;
}
