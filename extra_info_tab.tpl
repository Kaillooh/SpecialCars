<script>
	window.onload = function() {
		console.log("Ready function running !");
		completeField("car_number");
		completeField("car_color_code");
		completeField("car_option_code");
	};

	function completeField(field_name){
		field = document.getElementById(field_name).getElementsByTagName("i")[0];
		field.innerText = custom_field_data[field_name];
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

	<dl class="data-sheet">
		<dt class="name">Serial number</dt>
		<dd class="value">Trucmuche</dd>
	</dl>
</div>