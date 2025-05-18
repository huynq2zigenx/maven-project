<!DOCTYPE html>
<html>
<head>
 <title>Table with database</title>
 <style>
  table {
   border-collapse: collapse;
   width: 100%;
   color: #588c7e;
   font-family: monospace;
   font-size: 25px;
   text-align: left;
     }
  th {
   background-color: #588c7e;
   color: white;
    }
  tr:nth-child(even) {background-color: #f2f2f2}
 </style>
</head>
<body>
 <h1>PHP Database Test</h1>
 
 <?php
 // Display PHP info for debugging
 echo "<h2>PHP Version: " . phpversion() . "</h2>";
 
 // Test basic PHP functionality
 echo "<p>Current time: " . date("Y-m-d H:i:s") . "</p>";
 
 // Database connection
 echo "<h2>Database Connection Test</h2>";
 try {
     $conn = mysqli_connect("db", "root", "1234", "test");
     
     // Check connection
     if ($conn->connect_error) {
         throw new Exception("Connection failed: " . $conn->connect_error);
     }
     
     echo "<p style='color:green'>Database connection successful!</p>";
     
     // Try to query data
     $sql = "SELECT id, name, lastname, age FROM registers where age > 20";
     $result = $conn->query($sql);
     
     if ($result === false) {
         throw new Exception("Query failed: " . $conn->error);
     }
     
     if ($result->num_rows > 0) {
         echo "<table>
         <tr>
          <th>id</th>
          <th>name</th>
          <th>lastname</th>
          <th>age</th>
         </tr>";
         
         // output data of each row
         while($row = $result->fetch_assoc()) {
             echo "<tr><td>" . $row["id"]. "</td><td>" . $row["name"] . "</td><td>"
             . $row["lastname"]. "</td><td>" . $row["age"]. "</td></tr>";
         }
         
         echo "</table>";
     } else {
         echo "<p>0 results found in the database.</p>";
     }
     
     $conn->close();
     
 } catch (Exception $e) {
     echo "<p style='color:red'>Error: " . $e->getMessage() . "</p>";
 }
 ?>
</body>
</html>
