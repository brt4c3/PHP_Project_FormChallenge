<!DOCTYPE html>
<html lang="en-us">
<head>
  <title> SIMPLE TITLE </title>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="styles.css">
</head>

<body>
  <header>
    <div class="container">
      <a href="/" class="logo">WebSite</a>
  
    </div>
  </header>
  <?php 
    if(isset($_POST['submit'])){
      foreach($_POST['checkbox'] AS $value ){
        
      }
    }
  ?>

  <script>
    $(document).ready(function() {
      $("#form #industry_checkAll").click(function(){
        $("#form1 input[type='checkbox']").prop('checked',this.checked);
    
      });
    });
  </script>

  <div class="tab-content">

    <div id="tab1" class="container tab-pane active">

      <div class="container">
        <!-- Your form content here -->
        <form id="search-form" action="#" method="post">
          <!-- Form elements go here -->
        </form>
      </div>

      <div class="container">
        <form id="check-form">
          <div class="checkbox">
            <div class="condition-title">Area</div>
            <div class="condition">

              <label><input id="industry_checkAll" class="check-industry" type="checkbox" name="industry" value="">All</label>

              <?php
                // MySQL connection parameters
                $servername = "php-db"; 
                $username = "test"; 
                $password = "p@55w0rd"; 
                $dbname = "my_form";

                // SQL queries
                $areas_query = "SELECT slug, name FROM wp_terms WHERE taxonomy = 'area'";
                $prices_query = "SELECT slug, name FROM wp_terms WHERE taxonomy = 'work' ORDER BY slug";

                // Initialize arrays for areas and prices
                $areas = [];
                $prices = [];

                // Attempt MySQL connection
                try {
                    $conn = new mysqli($servername, $username, $password, $dbname);
                    
                    // Check connection
                    if ($conn->connect_error) {
                        throw new Exception("Connection failed: " . $conn->connect_error);
                    }

                    // Fetch areas
                    $areas_result = $conn->query($areas_query);
                    if ($areas_result->num_rows > 0) {
                        while ($row = $areas_result->fetch_assoc()) {
                            $areas[] = $row;
                        }
                    }

                    // Fetch prices
                    $prices_result = $conn->query($prices_query);
                    if ($prices_result->num_rows > 0) {
                        while ($row = $prices_result->fetch_assoc()) {
                            $prices[] = $row;
                        }
                    }
                } catch (Exception $e) {
                    die("Error: " . $e->getMessage());
                } finally {
                    // Close connection
                    if (isset($conn)) {
                        $conn->close();
                    }
                }
                ?>
              <?php
              foreach($areas as $area):
              ?>
              <label class="search-check">
                <input class="search-check-input check-industry" type="checkbox" name="search_area[]" value="<?php echo htmlspecialchars($area['slug']); ?>"><?php echo htmlspecialchars($area['name']); ?>
              </label>
              <?php endforeach; ?>

            </div>
          </div>
        </form>
      </div>

    </div>   

    <!-- Result List -->
    <div id="result-list">
      <h2>Query Result</h2>
      <ul>
        <?php
        // Iterate through $prices array to display the result
        foreach ($prices as $price) {
            echo '<li>' . htmlspecialchars($price['name']) . '</li>';
        }
        ?>
      </ul>
    </div>
  </div>

  <!-- JavaScript libs are placed at the end of the document so the pages load faster -->
  <script src="js/jquery-3.3.1.slim.min.js"></script>
  <script src="js/bootstrap.min.js"></script> 
  <script src="js/popper.min.js"></script> 
  <script src="js/bootstrap-4-navbar.js"></script> 

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script>
    $(document).ready(function() {
    function customSearch() {
        var formData = new FormData($('#search-form')[0]);
        formData.append('action', 'custom_search');
        
        // Add checkform data
        var checkformData = new FormData($('#check-form')[0]);
        for(var pair of checkformData.entries()) {
            formData.append(pair[0], pair[1]);
        }

        $.ajax({
            type: 'POST',
            url: 'admin-ajax.php', // Assuming this is the correct URL for your AJAX request
            data: formData,
            processData: false,
            contentType: false,
            success: function(data) {
                $('#search-result').html(data);
            }
        });
        return false;
    };

    $('#search-form').on('submit', function(event) {
        event.preventDefault(); // Prevent the default form submission
        customSearch(); // Call the custom search function
    });

    $('#search-form').on('change', 'input[type="checkbox"]', function() {
        customSearch();
    });

    // Function to handle "Select All" checkbox
    $('#industry_checkAll').on('change', function() {
        $('.check-industry').prop('checked', $(this).prop('checked'));
    });

    customSearch(); // Perform initial search on page load
    });
  </script>

</body>
</html>