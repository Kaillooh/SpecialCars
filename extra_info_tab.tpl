<script>
	var car_info_number = 1;

	if (window.addEventListener) {
	  window.addEventListener('load', init_completion, false); 
	} 

	else if (window.attachEvent) {
	  window.attachEvent('onload', init_completion);
	}

	function init_completion() {
		console.log("Ready function running !");
		completeField("car_number");
		completeField("car_color_code");
		completeField("car_option_code");

		var car_data = JSON.parse(custom_field_data["car_data"]);
		console.log("Displaying "+car_data.length+" cars")
		console.log(car_data);
		for (var i=0; i<car_data.length; i++){
			addCar(car_data[i]);
		}
	};

	function completeField(field_name){
		// console.log("Attempting to complete field '"+field_name+"'");
		field = document.getElementById(field_name).getElementsByTagName("i")[0];
		field.innerText = custom_field_data[field_name];
	}

	function addCar(car_data){
		console.log("Attemption to display car data for :");
		console.log(car_data);
		var car_info = document.createElement('p');
		car_info.id = "car_info_"+car_info_number;
		car_info_number += 1;
		car_info.innerText = car_data["car_model"]+" | "+car_data["car_type"]+" | "+car_data["car_version"];

		document.getElementById("car_number").parentElement.appendChild(car_info);
	}

</script>

<style type="text/css">
	.tabs > p{
		margin-bottom: 0px;
		font-style: bold;
		color : #232323;
		font-weight: 700;
	}

	.tabs > p > i{
		font-style: normal;
	}
</style>


<div class="tabs product-features">
	<h2>Caractéristiques</h2>
	<p id="car_number"><b>Serial : </b><i></i></p>
	<p id="car_color_code"><b>Color : </b><i></i></p>
	<p id="car_option_code"><b>Option : </b><i></i></p>

	<!-- <dl class="data-sheet">
		<dt class="name">Serial number</dt>
		<dd class="value">Trucmuche</dd>
	</dl> -->
</div>