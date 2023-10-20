<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap/dist/css/bootstrap.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script type="text/javascript" charset="utf8"
	src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css">



<script
	src="https://cdn.datatables.net/plug-ins/1.11.5/dataRender/ellipsis.js"></script>
<script
	src="https://cdn.datatables.net/plug-ins/1.11.5/api/fnSetFilteringDelay.js"></script>
<script
	src="https://cdn.datatables.net/plug-ins/1.11.5/api/fnReloadAjax.js"></script>



<style>
/* Custom CSS for additional styling */
body {
	background-color: #f7f7f7;
}

.container {
	margin-top: 50px;
	background-color: #fff;
	padding: 20px;
	border-radius: 5px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
}

h1 {
	color: #333;
}

#myDataTable input, #myDataTable select {
	font-size: 14px; padding : 5px 5 5px 5px;
	display: block;
	width: 50%;
	border: none;
	background: transparent;
	padding: 5px 5 5px 5px;
}

#myDataTable input:focus, #myDataTable select:focus {
	outline: none;
	border-bottom: 1px solid #757575;
}
</style>


</head>
<body>

	<div class="container">
		<h1 class="text-center">Upload Excel File</h1>
		<form action="/upload" method="post" enctype="multipart/form-data">
			<div class="form-group">
				<label for="file">Choose an Excel file:</label> <input type="file"
					name="file" id="file" class="form-control-file">
			</div>
			<button type="button" id="uploadButton"
				class="btn btn-primary btn-block">Upload</button>
		</form>
	</div>

	<div class="container" id="dataTableGrid" style="display: none">

		<div class="row-mb-3">

			<div class="col-md-12">

				<table id="myDataTable" style="height: 100%; width: 100%">
					<thead>
						<tr>
							<th>ID</th>
							<th>Sr No.</th>
							<th>Date</th>
							<th>Employee Code</th>
							<th>Employee Name</th>
							<th>Attendance Time</th>
							<th>Attendance Type</th>
							<th>Shift Code</th>
							
							<th>Action</th>
						</tr>
					</thead>
				</table>

			</div>
		</div>
		
		<div class="row-mb-3">

		<p id="validCountDisplay" style="color: green;font-weight: bold;"></p>
		<p id="unvalidCountDisplay" style="color: red;font-weight: bold;"></p>

		</div>

		<div class="row-mb-3">

			<button id="validateData" class="btn btn-info">Validate Data</button>

			<button id="save-button" class="btn btn-success">Save Valid Data</button>

		</div>

	</div>




	<script>
	$( document ).ready(function() {

	
		$("#uploadButton").on('click', function() {
			loadDatatable();
		});

		$('#validateData').on('click', function() {

			syncData();
		});
		
		$('#save-button').on('click', function() {

			saveData();
		});
		
		
		
	});
	</script>

	<script type="text/javascript">


	function loadDatatable() {

		var fileInput = $("#file")[0];
		var file = fileInput.files[0];
		if (file) {
			var formData = new FormData();
			formData.append('excelFile', file);

			$
					.ajax({
						url : '/upload',
						type : 'POST',
						data : formData,
						processData : false,
						contentType : false,
						success : function(response) {

							if (response.status == 'SUCCESS') {
								
								dataTableScript(response);
								
							} else {
								alert('ERROR');
							}

						}
					});
		} else {
			alert('Please select an Excel file to upload.');
		}

	}
</script>

	<script type="text/javascript">


function syncData() {

	 var selectedData = [];

     // Get All the Rows form the front end
     $('#myDataTable').DataTable().$('tr').each(function () {
     	 var rowData = $(this).find('td').find('input').map(function () {
              return $(this).val();
          }).get();
         selectedData.push(rowData);
     });

     
     console.log(selectedData);
     
     $('#myDataTable').DataTable().destroy();
     
     
     // Send data to the controller
      $.ajax({
         type: 'POST',
         url: '/syncData',
         contentType: 'application/json',
         data: JSON.stringify(selectedData),
         success: function (response) {
             
        	 if (response.status == 'SUCCESS') {
        		 
        		 dataTableScript(response);
        		 
				} else {
					alert('ERROR');
				}	 
         
         },
         error: function (error) {
             // Handle any errors
         }
     }); 

	
}


</script>


<script type="text/javascript">


function saveData() {

	 var selectedData = [];

     // Get All the Rows form the front end
     $('#myDataTable').DataTable().$('tr').each(function () {
     	 var rowData = $(this).find('td').find('input').map(function () {
              return $(this).val();
          }).get();
         selectedData.push(rowData);
     });

     
     console.log(selectedData);
     
     $('#myDataTable').DataTable().destroy();
     
     
     // Send data to the controller
      $.ajax({
         type: 'POST',
         url: '/saveData',
         contentType: 'application/json',
         data: JSON.stringify(selectedData),
         success: function (response) {
             
        	 if (response == 'SUCCESS') {
        		 console.log('SAVED');
        		 window.location.reload();
        		 
				} else {
					alert('ERROR');
				}	 
         
         },
         error: function (error) {
             // Handle any errors
         }
     }); 

	
}


</script>

<script type="text/javascript">

function dataTableScript(response){

	var validCount = 0;
	var unvalidCount = 0;

	console.log(response);

	$('#dataTableGrid').show();
	// Initialize the DataTable with the retrieved data
	var table = $('#myDataTable')
			.DataTable(
					{
						data : response.manualAdhocData,
						order: [[1, 'asc']],
						columns : [
							
							{
								data : 'selected',
								 render : function(
										data,
										type,
										row,
										meta) {

									 if(type === 'display')
									 {
								            return '<input type="checkbox" value="'+ data +'" onchange="checkBoxChanged(this)" class="selectCheckbox" ' + (data ? 'checked' : '') + '>';
									 }
								 return data;
								} 
							},
							
							{
								data : 'selected',
								
							},
							
							{
								data : 'date',
								 render : function(
										data,
										type,
										row,
										meta) {

									 if(type === 'display')
									 {
									 return '<input type="text" value="' + data + '" />';
									 }
								 return data;
								} 
							},
							{
								data : 'empCd',
								 render : function(
										data,
										type,
										row,
										meta) {

									 if(type === 'display')
									 {
									 return '<input type="text" value="' + data + '" />';
									 }
								 return data;
								} 
							},
							{
								data : 'employeeName',
								 render : function(
										data,
										type,
										row,
										meta) {

									 if(type === 'display')
									 {
									 return '<input type="text" value="' + data + '" />';
									 }
								 return data;
								} 
							},
							{
								data : 'attendanceTime',
								 render : function(
										data,
										type,
										row,
										meta) {

									 if(type === 'display')
									 {
									 return '<input type="text" value="' + data + '" />';
									 }
								 return data;
								} 
							},
							{
								data : 'attendanceType',
								 render : function(
										data,
										type,
										row,
										meta) {
									 if(type === 'display')
										 {
										 return '<input type="text" value="' + data + '" />';
										 }
									 return data;
									
								} 
							},
							{
								data : 'shiftCode',
								 render : function(
										data,
										type,
										row,
										meta) {

									 if(type === 'display')
									 {
										 var valid = row.valid;
										 
									 return '<input type="text" value="' + data + '" /><input type="hidden" value="' + valid + '" />';
									 }
								 return data;
								} 
							},
							
							{
						        data: 'error',
						        render: function (data, type, row, meta) {
						            if (type === 'display') {
						            	// if error then need to show info button as a error message
						            	if(data != null)
						            		{
							                return '<a href="#" class="info-button" title="'+ data +'"><svg xmlns="http://www.w3.org/2000/svg" width="25px" height="25px" viewBox="0 0 512 512" version="1.1"><path d="M 242.500 129.429 C 226.438 132.608, 215.376 138.568, 203.446 150.468 C 195.817 158.079, 193.657 160.995, 189.722 169 C 184.202 180.226, 181.827 189.503, 181.638 200.578 C 181.512 207.942, 181.766 209.087, 184.515 213.534 C 188.870 220.577, 196.297 224.385, 204.317 223.685 C 215.904 222.674, 222.352 215.618, 224.048 202.090 C 225.777 188.302, 230.590 180.668, 241.175 174.929 C 247.051 171.744, 248.139 171.501, 256.500 171.507 C 263.947 171.513, 266.241 171.909, 269.795 173.800 C 281.334 179.942, 287.367 189.604, 287.434 202.048 C 287.468 208.606, 287.043 210.471, 284.187 216.272 C 280.069 224.637, 275.179 228.753, 263.603 233.599 C 251.901 238.497, 244.449 245.291, 239.253 255.798 L 235.500 263.386 235.177 283.591 C 234.881 302.137, 235.018 304.112, 236.836 307.648 C 245.225 323.962, 266.732 324.042, 275.092 307.790 C 276.713 304.638, 277 301.884, 277 289.489 L 277 274.898 280.750 273.358 C 303.535 263.999, 317.787 249.901, 325.687 228.908 C 336.564 200.004, 329.027 169.026, 305.910 147.623 C 297.941 140.245, 284.960 133.157, 274.500 130.471 C 265.877 128.258, 250.885 127.769, 242.500 129.429 M 250.994 341.883 C 240.470 345.299, 235 352.525, 235 363.008 C 235 371.395, 240.253 379.120, 248.218 382.447 C 261.614 388.043, 277 377.651, 277 363.008 C 277 357.318, 274.992 351.693, 271.702 348.166 C 266.951 343.073, 256.808 339.995, 250.994 341.883" stroke="none" fill="#fafbfc" fill-rule="evenodd"/><path d="M 237.191 43.056 C 153.106 50.539, 80.098 108.171, 53.575 188 C 38.630 232.984, 38.630 279.016, 53.575 324 C 87.333 425.604, 192.715 486.577, 298 465.422 C 363.005 452.360, 418.169 409.961, 447.522 350.500 C 464.104 316.909, 471.875 277.531, 469.083 241.250 C 461.879 147.654, 397.745 71.364, 307.078 48.536 C 286.685 43.402, 258.309 41.177, 237.191 43.056 M 242.500 129.429 C 226.438 132.608, 215.376 138.568, 203.446 150.468 C 195.817 158.079, 193.657 160.995, 189.722 169 C 184.202 180.226, 181.827 189.503, 181.638 200.578 C 181.512 207.942, 181.766 209.087, 184.515 213.534 C 188.870 220.577, 196.297 224.385, 204.317 223.685 C 215.904 222.674, 222.352 215.618, 224.048 202.090 C 225.777 188.302, 230.590 180.668, 241.175 174.929 C 247.051 171.744, 248.139 171.501, 256.500 171.507 C 263.947 171.513, 266.241 171.909, 269.795 173.800 C 281.334 179.942, 287.367 189.604, 287.434 202.048 C 287.468 208.606, 287.043 210.471, 284.187 216.272 C 280.069 224.637, 275.179 228.753, 263.603 233.599 C 251.901 238.497, 244.449 245.291, 239.253 255.798 L 235.500 263.386 235.177 283.591 C 234.881 302.137, 235.018 304.112, 236.836 307.648 C 245.225 323.962, 266.732 324.042, 275.092 307.790 C 276.713 304.638, 277 301.884, 277 289.489 L 277 274.898 280.750 273.358 C 303.535 263.999, 317.787 249.901, 325.687 228.908 C 336.564 200.004, 329.027 169.026, 305.910 147.623 C 297.941 140.245, 284.960 133.157, 274.500 130.471 C 265.877 128.258, 250.885 127.769, 242.500 129.429 M 250.994 341.883 C 240.470 345.299, 235 352.525, 235 363.008 C 235 371.395, 240.253 379.120, 248.218 382.447 C 261.614 388.043, 277 377.651, 277 363.008 C 277 357.318, 274.992 351.693, 271.702 348.166 C 266.951 343.073, 256.808 339.995, 250.994 341.883" stroke="none" fill="#2494f4" fill-rule="evenodd"/></svg></a><a href="#" class="delete-button" style="margin-left:8px;" ><svg version="1.2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="25px" height="25px"><title>trash-svg</title><style>.s0 { fill: #e63946 } .s1 { fill: #c9273a } </style><g id="Layer"><path id="Layer" class="s0" d="m183.5 44.9c-16.8 7.8-16.4 31.4 0.7 38.5 3.3 1.4 12.5 1.6 72 1.6 64.3 0 68.5-0.2 72.3-1.9 16.5-7.6 16.5-30.6 0-38.2-3.8-1.7-7.9-1.9-72.5-1.9-64.6 0-68.7 0.2-72.5 1.9z"/><path id="Layer" fill-rule="evenodd" class="s0" d="m257.5 128.3l175 0.2 4.7 2.8c10.9 6.3 13.9 21.5 6.2 30.6-5.8 7-7.5 7.6-23.4 8.1l-14.5 0.5-0.5 114c-0.6 122.7-0.2 114.8-5.5 129.5-9.8 27.5-36.5 49.2-66.5 54-8.8 1.3-145.2 1.3-154 0-31.7-5-58.2-27.8-67.8-58-1.1-3.6-2.4-7.6-2.8-9-0.5-1.4-1.1-53.8-1.4-116.5l-0.5-114-14.5-0.5c-15.9-0.5-17.6-1.1-23.4-8.1-9.1-10.8-3.1-28.6 11.2-32.9 1.5-0.5 81.5-0.8 177.7-0.7zm-63.4 97c-2.1 4.3-2.1 5.1-2.1 73.3 0 64.9 0.2 69.1 1.9 72.9 8.2 17.6 34.4 16 40-2.4 0.8-2.7 1.1-23.7 1.1-71.4v-67.5l-2.8-5.3c-2-3.9-4.1-6.2-7.5-8.3-11-6.8-25-2.8-30.6 8.7zm94.8-9.5c-3.9 2-6.2 4.1-8.4 7.7l-3 4.8-0.3 68.1c-0.2 48.7 0 69.3 0.9 72.2 5.1 18.8 31.7 20.7 40 2.9 1.7-3.8 1.9-8 1.9-72.9 0-67.9 0-69-2.1-73.3-2.5-5.1-7.6-9.6-12.8-11.2-6-1.8-10.5-1.3-16.2 1.7z"/><path id="Shape 1" class="s1" d="m64 148c0-11 9-20 20-20h344c11 0 20 9 20 20v2c0 11-9 20-20 20h-344c-11 0-20-9-20-20z"/></g></svg> </a>';
	
						            		}
						            	// else show only delete button
						            	else{
							                return '<a href="#" class="delete-button" style="margin-left:8px;" ><svg version="1.2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="25px" height="25px"><title>trash-svg</title><style>.s0 { fill: #e63946 } .s1 { fill: #c9273a } </style><g id="Layer"><path id="Layer" class="s0" d="m183.5 44.9c-16.8 7.8-16.4 31.4 0.7 38.5 3.3 1.4 12.5 1.6 72 1.6 64.3 0 68.5-0.2 72.3-1.9 16.5-7.6 16.5-30.6 0-38.2-3.8-1.7-7.9-1.9-72.5-1.9-64.6 0-68.7 0.2-72.5 1.9z"/><path id="Layer" fill-rule="evenodd" class="s0" d="m257.5 128.3l175 0.2 4.7 2.8c10.9 6.3 13.9 21.5 6.2 30.6-5.8 7-7.5 7.6-23.4 8.1l-14.5 0.5-0.5 114c-0.6 122.7-0.2 114.8-5.5 129.5-9.8 27.5-36.5 49.2-66.5 54-8.8 1.3-145.2 1.3-154 0-31.7-5-58.2-27.8-67.8-58-1.1-3.6-2.4-7.6-2.8-9-0.5-1.4-1.1-53.8-1.4-116.5l-0.5-114-14.5-0.5c-15.9-0.5-17.6-1.1-23.4-8.1-9.1-10.8-3.1-28.6 11.2-32.9 1.5-0.5 81.5-0.8 177.7-0.7zm-63.4 97c-2.1 4.3-2.1 5.1-2.1 73.3 0 64.9 0.2 69.1 1.9 72.9 8.2 17.6 34.4 16 40-2.4 0.8-2.7 1.1-23.7 1.1-71.4v-67.5l-2.8-5.3c-2-3.9-4.1-6.2-7.5-8.3-11-6.8-25-2.8-30.6 8.7zm94.8-9.5c-3.9 2-6.2 4.1-8.4 7.7l-3 4.8-0.3 68.1c-0.2 48.7 0 69.3 0.9 72.2 5.1 18.8 31.7 20.7 40 2.9 1.7-3.8 1.9-8 1.9-72.9 0-67.9 0-69-2.1-73.3-2.5-5.1-7.6-9.6-12.8-11.2-6-1.8-10.5-1.3-16.2 1.7z"/><path id="Shape 1" class="s1" d="m64 148c0-11 9-20 20-20h344c11 0 20 9 20 20v2c0 11-9 20-20 20h-344c-11 0-20-9-20-20z"/></g></svg> </a>';

						            	}
						            }
						            return data;
						        }
						    },

						],
						
						columnDefs : [ {
							targets : 1,
							render : function(data,
									type, row, meta) {
								return meta.row
										+ meta.settings._iDisplayStart
										+ 1;

							}
						}

						],
						
						
						rowCallback : function(row,
								data, index) {
							if (data.valid) {
								$(row)
										.css(
												'background-color',
												'#90EE90');
								
							} else {
								$(row)
										.css(
												'background-color',
												'#ffcccb');
								
							}

						},

					});
	
	
	
	 $('#myDataTable').DataTable().rows().data().each(function (rowData) {
        if (rowData.valid) {
            validCount++;
        } else {
            unvalidCount++;
        }
    });
	
	
	// Update the valid count display
	$('#validCountDisplay').text('Valid Count : ' + validCount);

	// Update the un-valid count display
	$('#unvalidCountDisplay').text('Non-Valid Count : ' + unvalidCount);

	
}

</script>


<script type="text/javascript">

$('#myDataTable').on('click', '.delete-button', function () {
	var data = $('#myDataTable').DataTable().row($(this).closest('tr')).data();
    $('#myDataTable').DataTable().row($(this).closest('tr')).remove().draw(false);
    
    // call ajax after delete the row because we need to update the valid and un-valid count
    syncData();
});

</script>

<script type="text/javascript">
 function checkBoxChanged(checkbox) {
	
    console.log('checked: ' + checkbox.checked);

    if (checkbox.checked) {
    	$(checkbox).prop('checked', true);
    	$(checkbox).val(true);

    } else {
    	$(checkbox).prop('checked', false);
    	$(checkbox).val(false);

    }
    
   
}

</script>



</body>
</html>