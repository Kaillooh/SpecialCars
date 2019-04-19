<script>

	class FieldsController {

		constructor(hierarchy_controller){
			this.field_list = ["car_model", "car_type", "car_version", "car_serial", "car_optioncode", "car_colorcode"];
			this.autocomplete_controller = new AutocompleteFieldsController(hierarchy_controller);
		}

		






	}

	class AutocompleteFieldsController {
		
		constructor(hierarchy_controller) {
			this.hierarchy = hierarchy_controller;
		}

		updateAllBuckets() {

		}

		updateBucket() {

		}

		validateFieldContent() {

		}

		getFieldHierarchy() {
			hierarchy = {}

	        car_model_txt = document.getElementById("car_model").value;
	        car_type_txt = document.getElementById("car_type").value;

	        if (field_id == "car_model")
	            hierarchy = model_hierarchy;

	        else if (field_id == "car_type"){
	            if (Object.keys(model_hierarchy).includes(car_model_txt)){
	                hierarchy = model_hierarchy[car_model_txt];
	            }
	        }

	        else if (field_id == "car_version"){
	            if (Object.keys(model_hierarchy).includes(car_model_txt)){
	                if (Object.keys(model_hierarchy[car_model_txt]).includes(car_type_txt)){
	                    hierarchy = model_hierarchy[car_model_txt][car_type_txt];
	                }                
	            }
	        }

	        console.log(hierarchy);

	        return hierarchy;
		}

	}
	



</script>