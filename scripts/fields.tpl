<script>

	class CommonFieldController {

		constructor(hierarchy_controller){
			console.log("Creating new CommonFieldController");
			this.field_list = {
				"car_model" : "form_car_model_1", 
				"car_type" : "form_car_type_1", 
				"car_version" : "form_car_version_1", 
				"car_number" : "form_car_number_1", 
				"car_option_code" : "form_car_option_code_1", 
				"car_color_code" : "form_car_color_code_1",
				"model_hierarchy" : "form_model_hierarchy_1"
			};

			console.log("Loading field content ");
			this.loadFieldContent();
			console.log("Setup sync");
			this.setupSync();

			this.car_field_controller = new CarFieldController(hierarchy_controller);
		}

		loadFieldContent(){
			var field_list = Object.keys(this.field_list);

			for (const field_key of field_list) {
	            var true_field = document.getElementById(this.field_list[field_key]);
	            var display_field = document.getElementById(field_key);

	            var content = custom_field_data[field_key];

	            true_field.value = content;
	            display_field.value = content;
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
				console.log("Attempting to load field '"+source_field_id+"'");
				var source_field = document.getElementById(source_field_id);
				console.log(source_field)

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
		
		constructor(hierarchy_controller) {
			console.log("Creating new CarFieldController")
			this.hierarchy = hierarchy_controller;

			this.fields_id = {
				"car_model" : "car_model",
				"car_type" : "car_type",
				"car_version" : "car_version"
			};

			this.fields_order = ["", "car_model", "car_type", "car_version"];

			this.fields = {};

			console.log("Binding listeners for CarFieldController validation process")
			this.bindListeners();
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

		updateAllBuckets() {
			var field_list = Object.keys(this.fields);

			for (const field_key in field_list) {
				updateBucket(field_key);
			}
		}

		updateBucket(field_key) {
			var options = getAllowedChildren(field_keys);
			var id = this.fields_id[field_key]

			$('#'+id).autocomplete({
	            source : options,
	            minLength: 0
	        });
		}

		getParentFieldKey(field_key) {
			for (var i=0; i<this.fields_order.length; i++){
				if (this.fields_order[i] == field_key){
					return this.fields_order[i-1];
				}
			}
		}

		validateAllFields() {
			var field_list = Object.keys(this.fields);

			for(const key in field_list){
				validateField(key);
			}
		}

		validateField(field_key) {
			field = this.fields[field_key];
	        var allowed_values = getAllowedValues(field_key);

	        if (allowed_values.includes(field.value)){
	            field.classList.remove("form_wrong");  
	        }

	        else {
	            field.classList.add("form_wrong");
	        }
		}

		getAllowedValues(field_key) {
			var parent_field_key = this.getParentFieldKey(field_key);
			return Object.keys(this.getLocalHierarchy(parent_field_key));
		}

		getAllowedChildren(field_key) {
			return Object.keys(getLocalHierarchy(field_keys))
		}

		getLocalHierarchy(field_id) {
			local_hierarchy = {}

	        car_model_txt = this.fields["car_model"].value;
	        car_type_txt = this.fields["car_type"].value;

	        if (field_id == "")
	            local_hierarchy = hierarchy.data;

	        else if (field_id == "car_model"){
	            if (Object.keys(hierarchy.data).includes(car_model_txt)){
	                local_hierarchy = hierarchy.data[car_model_txt];
	            }
	        }

	        else if (field_id == "car_type"){
	            if (Object.keys(hierarchy.data).includes(car_model_txt)){
	                if (Object.keys(hierarchy.data[car_model_txt]).includes(car_type_txt)){
	                    local_hierarchy = hierarchy.data[car_model_txt][car_type_txt];
	                }                
	            }
	        }

	        console.log(local_hierarchy);

	        return local_hierarchy;
		}

	}
	



</script>