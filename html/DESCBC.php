<?php
// Function to perform DECCBC encryption
function encryptWithDECCBC($plaintext, $password) {
    // Path to DECCBC executable
    $deccbc_path = '/path/to/deccbc'; // Replace this with the actual path

    // Prepare command to execute DECCBC encryption
    $command = $deccbc_path . ' -e -p ' . escapeshellarg($password) . ' -z 0';

    // Open a pipe to execute the command
    $descriptors = array(
        0 => array("pipe", "r"), // stdin
        1 => array("pipe", "w"), // stdout
        2 => array("pipe", "w")  // stderr
    );
    $process = proc_open($command, $descriptors, $pipes);

    if (is_resource($process)) {
        // Write plaintext to stdin of the process
        fwrite($pipes[0], $plaintext);
        fclose($pipes[0]);

        // Read the encrypted output from stdout
        $encrypted = stream_get_contents($pipes[1]);
        fclose($pipes[1]);

        // Close stderr
        fclose($pipes[2]);

        // Close the process
        $return_value = proc_close($process);

        if ($return_value === 0) {
            return base64_encode($encrypted);
        } else {
            return false; // Encryption failed
        }
    } else {
        return false; // Unable to execute DECCBC
    }
}

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve plaintext and password from the form
    $plaintext = $_POST["plaintext"];
    $password = $_POST["password"];

    // Perform DECCBC encryption
    $encrypted_text = encryptWithDECCBC($plaintext, $password);

    if ($encrypted_text !== false) {
        echo '<div class="alert alert-success" role="alert">';
        echo 'Encrypted Text (Base64): ' . $encrypted_text;
        echo '</div>';
    } else {
        echo '<div class="alert alert-danger" role="alert">';
        echo 'Encryption failed.';
        echo '</div>';
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>DECCBC Encryption</title>
    <!-- Include Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">DECCBC Encryption Tool</h5>
                <form method="post">
                    <div class="form-group">
                        <label for="plaintext">Plaintext:</label>
                        <input type="text" class="form-control" id="plaintext" name="plaintext" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Encrypt</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
