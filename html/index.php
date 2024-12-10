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
      <div class="row">
        <div class="col-right">  
          <a href="/" class="logo">WebSite</a>
          <a href="DESCBC.php">Go to DESCBC page</a>
        </div>
        <div class="col-left">
          <ul class="mav nav-pills mb-3" id="pills-tab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="pills-tab1-tab" data-bs-taggle="pill" data-bs-target="#pill-tab1-tab" type="button" role="tab" aria-controls="pills-tab1" aria-selected="true">
              タブ１
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="pills-tab2-tab" data-bs-taggle="pill" data-bs-target="#pill-tab2-tab" type="button" role="tab" aria-controls="pills-tab2" aria-selected="true">
              <a href="sample.php">蛇足ページ</a>
            </button>
          </li>
          </ul>
        </div> 
      </div> 
    </div>
  </header>

  <div class="tab-content" id="pills-tabContent">

    <div class="tab-pane fade show active" id="pills-tab1" role="tabpanel" aria-labelledby="pills-tab1-tab">

      <div class="container">
        <!-- Your form content here -->
        <form id="search-form" action="#" method="post">
          <!-- Form elements go here -->
        </form>
      </div>

      <div class="container">
        <?php
        require 'custom_form.php';
        ?>
      </div>

    </div>   
  </div>

  <!-- JavaScript libs are placed at the end of the document so the pages load faster -->
  <script src="js/jquery-3.3.1.slim.min.js"></script>
  <script src="js/bootstrap.min.js"></script> 
  <script src="js/popper.min.js"></script> 
  <script src="js/bootstrap-4-navbar.js"></script> 
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</body>
</html>