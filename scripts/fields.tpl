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
		
		constructor(input_data, hierarchy_controller, car_list_controller, id) {
			this.id = id;
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
			car_container.getElementsByClassName("car_model_form")[0].id = "car_model_form_"+this.id;

			car_container.getElementsByClassName("car_type_form")[0].value = input_data["car_type"];
			car_container.getElementsByClassName("car_type_form")[0].id = "car_type_form_"+this.id;

			car_container.getElementsByClassName("car_version_form")[0].value = input_data["car_version"];
			car_container.getElementsByClassName("car_version_form")[0].id = "car_version_form_"+this.id;

			this.UI_container = car_container;
		}

		delete(){
			this.UI_container.parentNode.removeChild(this.UI_container);
		}

		getField(field_key){
			return this.UI_container.getElementsByClassName(field_key+"_form")[0];
		}

		getFieldValue(field_key){
			var value = this.getField(field_key).value;
			console.log("Value of field '"+field_key+"' of car #"+this.id+" is '"+value+"'");
			return value;
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

		        field.addEventListener(
		            'focusout', 
		            function(){ controller.onChangeCheckup(); }, 
		            false
		        );
			}

			var close_btn = this.UI_container.getElementsByClassName("car_close_button")[0];
			var car_id = this.id;
			close_btn.addEventListener(
	            'click',
	            function(event){ console.log("Attempting to close car #"+car_id); controller.removeCar(car_id); },
	            false
	        );
		}

	}

	class CarListController {
		constructor(hierarchy_controller) {
			this.last_id_given = 0;
			this.hierarchy = hierarchy_controller;
			this.validator = new FieldValidator(this.hierarchy);

			this.car_list_data = this.loadData();

			this.car_list = [];

			var controller = this;
			document.getElementById("add_car_btn").addEventListener(
	            'click',
	            function(event){ controller.addNewCar() },
	            false
	        );

			this.generateUI();
			this.validateFields();
		}

		addNewCar(car_data){
			if (car_data == null){
					var car_data = {
					"car_model" : "",
					"car_type" : "",
					"car_version" : ""
				};
			}
			var car_field = new CarFieldController(car_data, this.hierarchy, this, this.last_id_given);
			this.car_list.push(car_field);
			this.last_id_given += 1;
			this.validateFields();
		}

		loadData(){
			var raw_json = document.getElementById("form_car_data_1").value;
			if (raw_json == ''){
				return []
			}
			return JSON.parse(raw_json);
		}

		generateUI(){
			for (var i=0; i<this.car_list_data.length; i++){
				var car_data = this.car_list_data[i];
				this.addNewCar(car_data);
			}
		}

		removeCar(id){
			for (var i=0; i<this.car_list.length; i++){
				var car = this.car_list[i];
				if (car.id == id){
					car.delete();
					this.car_list.splice(id, 1);
				}
			}
			this.onChangeCheckup();
		}

		validateFields(){
			for (var i=0; i<this.car_list.length; i++){
				var car_field = this.car_list[i];
				this.validator.update(car_field);
			}
		}

		onChangeCheckup(){
			this.validateFields();
			this.updateData();
			this.saveData();
		}

		saveData(){
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
	
	class FieldValidator{
		constructor(hierarchy){
			this.hierarchy = hierarchy;
		}

		update(car_field){
			var field_keys = ["car_model", "car_type", "car_version"];
			console.log("Updating field #"+car_field.id);

			for (var i=0; i<field_keys.length; i++){
				var field_key = field_keys[i];
				console.log(field_key);

				var allowed_values = this.getAllowedValues(field_key, car_field);

				this.updateBucket(car_field, field_key, allowed_values);
				this.validateField(car_field, field_key, allowed_values);
			}

		}

		updateBucket(car_field, field_key, option_list){
			var id = field_key+"_form_"+car_field.id;

			// console.log("Updating field '#"+id+"', content : ");
			// console.log(option_list);


			$('#'+id).autocomplete({
	            source : option_list,
	            delay : 0,
	            minLength: 0
	        }).focus(function(){
	            $(this).data("uiAutocomplete").search($(this).val());
	        });
		}

		validateField(car_field, field_key, option_list){
			var current_value = car_field.getFieldValue(field_key);

			console.log("Validating field value '"+current_value+"' against list : ");
			console.log(option_list);

			if (option_list.includes(current_value)){
				car_field.getField(field_key).classList.remove("form_wrong");
				console.log("Form is OK");
			}

			else {
				car_field.getField(field_key).classList.add("form_wrong");
				console.log("Form is WRONG");
			}
		}

		getAllowedValues(field_key, car_field) {
			return Object.keys(this.getLocalHierarchy(field_key, car_field));
		}

		getLocalHierarchy(field_key, car_field) {
			var local_hierarchy = this.hierarchy.data;
			var fields_order = ["car_model", "car_type", "car_version"];

	        for (var i=0; i<fields_order.length; i++){
	        	var current_field_key = fields_order[i];

	        	if (current_field_key == field_key){
	        		return local_hierarchy;
	        	}
	        	
	        	else {
	        		var option_list = Object.keys(local_hierarchy);
	        		var current_field_value = car_field.getFieldValue(current_field_key);

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



</script>