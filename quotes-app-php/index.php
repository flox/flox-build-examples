<?php
// Set the content type for all responses
header("Content-Type: application/json");

// Load quotes from the JSON file
$quotesFile = __DIR__ . '/quotes.json';
if (!file_exists($quotesFile)) {
    http_response_code(500);
    echo json_encode(['error' => 'Quotes file not found']);
    exit;
}

$quotes = json_decode(file_get_contents($quotesFile), true);

// Route parsing
$requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$requestMethod = $_SERVER['REQUEST_METHOD'];

// GET /quotes
if ($requestMethod === 'GET' && $requestUri === '/quotes') {
    echo json_encode($quotes);
    exit;
}

// GET /quotes/{index}
if ($requestMethod === 'GET' && preg_match('#^/quotes/(\d+)$#', $requestUri, $matches)) {
    $index = (int)$matches[1];
    if ($index >= 0 && $index < count($quotes)) {
        echo json_encode($quotes[$index]);
    } else {
        http_response_code(404);
        echo json_encode(['error' => 'Index out of bounds']);
    }
    exit;
}

// 404 fallback
http_response_code(404);
echo json_encode(['error' => 'Not found']);

