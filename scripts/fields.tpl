<script>

	class CommonFieldController {

		constructor(hierarchy_controller){
			this.field_list = {
				"car_number" : "sync", 
				"car_option_code" : "sync",
				"car_color_code" : "sync", 
				"car_data" : "no_sync",
				"model_hierarchy" : "no_sync"
			};

			this.loadFieldContent();
			// this.setupSync();
		}

		loadFieldContent(){
			var field_list = Object.keys(this.field_list);

			for (const field_key of field_list) {
	            var content = custom_field_data[field_key];

	            var true_field = document.getElementById("form_"+field_key+"_1");
	            true_field.value = content;

	            if (this.field_list[field_key] == "sync"){
	            	var display_field = document.getElementById(field_key);
	            	display_field.value = content;
	            }
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
		
		constructor(input_data, hierarchy_controller, car_list_controller) {

			this.hierarchy = hierarchy_controller;
			this.car_list_controller = car_list_controller;

			this.UI_container = null;

			this.fields_order = ["car_model", "car_type", "car_version"];

			this.generateHTML(input_data);

			this.bindListeners();
		}

		generateHTML(input_data){
			var template = document.getElementById("car_field_template");
			var cars_list = document.getElementById("cars_list");

			var tpl_html = template.innerHTML;

			var car_container = document.createElement('div');
			car_container.classList.add("car_container");
			car_container.innerHTML = tpl_html;
			cars_list.appendChild(car_container);

			car_container.getElementsByClassName("car_model_form")[0].value = input_data["car_model"];
			car_container.getElementsByClassName("car_type_form")[0].value = input_data["car_type"];
			car_container.getElementsByClassName("car_version_form")[0].value = input_data["car_version"];

			this.UI_container = car_container;
		}

		getField(field_key){
			return this.UI_container.getElementsByClassName(field_key+"_form")[0];
		}

		getFieldValue(field_key){
			return this.getField(field_key).value;
		}


		bindListeners() {
			var controller = this.car_list_controller;

			for (var i=0; i<this.fields_order.length; i++){
				var field_key = this.fields_order[i];
				var field = this.getField(field_key)

				field.addEventListener(
		            'change', 
		            function(){ controller.onChangeCheckup(); }, 
		            false
		        );
			}
		}

	}

	class CarListController {
		constructor(hierarchy_controller) {
			this.hierarchy = hierarchy_controller;

			this.car_list_data = this.loadData();

			this.car_list = [];

			this.generateUI();
		}

		loadData(){
			var raw_json = document.getElementById("form_car_data_1").value;
			return JSON.parse(raw_json);
		}

		generateUI(){
			for (var i=0; i<this.car_list_data.length; i++){
				var car_data = this.car_list_data[i];
				var car_field = new CarFieldController(car_data, this.hierarchy, this);
				this.car_list.push(car_field);
			}
		}

		onChangeCheckup(){
			this.updateData();
			this.saveData();
		}

		saveData(){
			console.log("Saving data...");
			console.log(this.car_list_data);
			document.getElementById("form_car_data_1").value = JSON.stringify(this.car_list_data);
		}

		updateData(){
			var full_data = [];

			for (var i=0; i<this.car_list.length; i++){
				var car_controller = this.car_list[i];
				var data = {
					"car_model" : car_controller.getFieldValue("car_model"),
					"car_type" : car_controller.getFieldValue("car_type"),
					"car_version" : car_controller.getFieldValue("car_version")
				};

				full_data.push(data);
			}

			this.car_list_data = full_data;
			return full_data;
		}
	}
	



</script>