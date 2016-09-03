<?php

define('BOT_TOKEN', '269576788:AAFYdxw9M7YW7e1G-bh5ZRFpPvXBSpJnk2w');
define('API_URL', "https://api.telegram.org/bot${BOT_TOKEN}/");

function apiRequestWebhook($method, $parameters) {
    if (!is_string($method)) {
        error_log("Method name must be a string\n");
        return false;
    }

    if (!$parameters) {
        $parameters = array();
    } else if (!is_array($parameters)) {
        error_log("Parameters must be an array\n");
        return false;
    }

    $parameters["method"] = $method;

    header("Content-Type: application/json");
    echo json_encode($parameters);

    return true;
}

function exec_curl_request($handle) {
    $response = curl_exec($handle);

    if ($response === false) {
        $errno = curl_errno($handle);
        $error = curl_error($handle);
        error_log("Curl returned error $errno: $error\n");
        curl_close($handle);
        return false;
    }


}
