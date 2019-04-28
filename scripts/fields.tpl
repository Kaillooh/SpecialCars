<script>

	class CommonFieldController {

		constructor(hierarchy_controller){
			this.field_list = {
				"car_model" : "form_car_model_1", 
				"car_type" : "form_car_type_1", 
				"car_version" : "form_car_version_1", 
				"car_number" : "form_car_number_1", 
				"car_option_code" : "form_car_option_code_1", 
				"car_color_code" : "form_car_color_code_1", 
				"car_data" : "form_car_data_1",
				"model_hierarchy" : "form_model_hierarchy_1"
			};

			this.loadFieldContent();
			// this.setupSync();
		}

		loadFieldContent(){
			var field_list = Object.keys(this.field_list);

			for (const field_key of field_list) {
	            var true_field = document.getElementById(this.field_list[field_key]);
	            var display_field = document.getElementById(field_key);

	            var content = custom_field_data[field_key];

	            true_field.value = content;
	            // display_field.value = content;
	        }
		}

		sync(source_field_id, target_field_id){
			var source_field = document.getElementById(source_field_id);
			var target_field = document.getElementById(target_field_id);

			console.log("Syncing '"+source_field_id+"' to '"+target_field_id+"'");

			target_field.value = source_field.value;
		}

		setupSync() {
			var source_fields = Object.keys(this.field_list);

			var controller = this;

			for (const source_field_id of source_fields) {
				var source_field = document.getElementById(source_field_id);

				const target_field_id = this.field_list[source_field_id];


				source_field.addEventListener(
		            'change', 
		            function(){ controller.sync(source_field_id, target_field_id); }, 
		            false
		        );
			}
		}
	}

	class CarFieldController {
		
		constructor(input_data, hierarchy_controller) {
			console.log("Creating new CarFieldController")

			this.car_model = input_data["car_model"];
			this.car_type = input_data["car_type"];
			this.car_version = input_data["car_version"];

			this.hierarchy = hierarchy_controller;


			this.fields_id = {
				"car_model" : "car_model",
				"car_type" : "car_type",
				"car_version" : "car_version"
			};

			this.fields_order = ["car_model", "car_type", "car_version"];

			this.fields = this.generateFieldIndex();

			// this.updateAllBuckets();
			// this.bindListeners();
		}

		generateHTML(){
			var template = document.getElementById("car_field_template");
			var cars_list = document.getElementById("cars_list");

			var tpl_html = template.innerHTML;

			var car_container = document.createElement('div');
			car_container.classList.add("car_container");
			car_container.innerHTML = tpl_html;
			cars_list.appendChild(car_container);

			car_container.getElementsByClassName("car_model_form")[0].value = this.car_model;
			car_container.getElementsByClassName("car_type_form")[0].value = this.car_type;
			car_container.getElementsByClassName("car_version_form")[0].value = this.car_version;
		}


		bindListeners() {
			var field_keys = Object.keys(this.fields);
			var controller = this;

			for (const key of field_keys){
				this.fields[key].addEventListener(
		            'change', 
		            function(){ controller.validateAllFields(); }, 
		            false
		        );
			}
		}

		generateFieldIndex() {
			var field_key_list = Object.keys(this.fields_id);
			var rslt = {}

			for (const field_key of field_key_list) {
				var field_id = this.fields_id[field_key];
				rslt[field_key] = document.getElementById(field_id);
			}

			return rslt;
		}

		updateAllBuckets() {
			var field_list = Object.keys(this.fields);

			console.log("Updating all buckets from");
			console.log(field_list);

			for (const field_key of field_list) {

				this.updateBucket(field_key);
			}
		}

		updateBucket(field_key) {
			console.log("Attempting to load bucket for '"+field_key+"'");
			var options = this.getAllowedValues(field_key);
			console.log(options);
			var id = this.fields_id[field_key]

			$('#'+id).autocomplete({
	            source : options,
	            minLength: 0
	        });
		}

		validateAllFields() {
			this.updateAllBuckets();

			var field_list = Object.keys(this.fields);

			for(const key of field_list){
				this.validateField(key);
			}
		}

		validateField(field_key) {
			var field = this.fields[field_key];
	        var allowed_values = this.getAllowedValues(field_key);

	        if (allowed_values.includes(field.value)){
	            field.classList.remove("form_wrong");  
	        }

	        else {
	            field.classList.add("form_wrong");
	        }
		}

		getAllowedValues(field_key) {
			return Object.keys(this.getLocalHierarchy(field_key));
		}

		getLocalHierarchy(field_key) {
			var local_hierarchy = this.hierarchy.data;

	        for (var i=0; i<this.fields_order.length; i++){
	        	var current_field_key = this.fields_order[i];

	        	if (current_field_key == field_key){
	        		return local_hierarchy;
	        	}
	        	
	        	else {
	        		var option_list = Object.keys(local_hierarchy);
	        		var current_field_value = this.fields[current_field_key].value;

	        		if (option_list.includes(current_field_value)){
	        			local_hierarchy = local_hierarchy[current_field_value];
	        		}

	        		else {
	        			return {};
	        		}
	        	}
	        }
		}

	}

	class CarListController {
		constructor(hierarchy_controller) {
			this.hierarchy = hierarchy_controller;

			this.car_list_data = this.getCarListData();

			this.car_list = [];

			this.generateUI();
		}

		getCarListData(){
			var raw_json = document.getElementById("form_car_data_1").value;
			return JSON.parse(raw_json);
		}

		generateUI(){
			for (var i=0; i<this.car_list_data.length; i++){
				var car_data = this.car_list_data[i];
				var car_field = new CarFieldController(car_data, this.hierarchy);
				car_field.generateHTML()
				this.car_list.push(car_field);
			}
		}
	}
	



</script>