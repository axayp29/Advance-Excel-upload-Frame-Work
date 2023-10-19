<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>Excel File Upload via AJAX</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <input type="file" id="excelFile">
    <button id="uploadButton">Upload Excel File</button>
    <div id="uploadStatus"></div>
    <div id="tableContainer"></div>
    <div id="saveButtonDiv" style="display: none">
    <button id="saveButton">Save</button>
    </div>
    
    <script>
        $(document).ready(function() {
            $("#uploadButton").on('click', function() {
                var fileInput = $("#excelFile")[0];
                var file = fileInput.files[0];
                if (file) {
                    var formData = new FormData();
                    formData.append('excelFile', file);
                    
                    $.ajax({
                        url: '/upload',
                        type: 'POST',
                        data: formData,
                        processData: false,
                        contentType: false,
                        success: function(response) {
                           
                        	  // Create a table with checkboxes and data
                            var tableHtml = '<table><thead><tr><th></th><th>Employee ID</th><th>Product Name</th><th>Price</th><th>Categories</th></tr></thead><tbody>';
                            response.forEach(function(response) {
                                tableHtml += '<tr><td><input type="checkbox" value='+response.employeeId+'></td><td>' + response.employeeId + '</td><td>' + response.productName + '</td><td>' + response.price + '</td><td>' + response.category + '</td></tr>';
                            });
                            tableHtml += '</tbody></table>';

                            // Update the page content with the table
                            $("#tableContainer").html(tableHtml);
                            
                            $('#saveButtonDiv').show();
                        }
                    });
                } else {
                    alert('Please select an Excel file to upload.');
                }
            });
        });
        
        
        
        $("#saveButton").on('click', function() {
            var selectedCheckboxes = [];
            
            // Find all selected checkboxes and push their values into the array
            $('input[type="checkbox"]:checked').each(function() {
                selectedCheckboxes.push($(this).val());
            });
            
            // Display the selected values in the result div
           console.log(selectedCheckboxes);
            
           $.ajax({
               type: "POST",
               url: "/saveData", // URL of your controller
               contentType: "application/json",
               data: JSON.stringify(selectedCheckboxes),
               success: function(response) {
                   console.log(response);
                   // Handle the response from the controller
                   alert(response);
               }
           });
            
            
            
            
            
            
            
        });
        
        
    </script>
</body>
</html>

