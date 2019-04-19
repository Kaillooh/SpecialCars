<script>

    var hierarchy = null;


    $(document).ready(function() {


        updateAllComplete();
        loadAttributes();

        hierarchy = new HierarchyController();
        hierarchy.renderTreeUI();

        

    })

    function updateAllComplete(){
        var car_model = document.getElementById("car_model");
        var car_type = document.getElementById("car_type");
        var car_version = document.getElementById("car_version");

        updateAutocompleteList('car_model', model_hierarchy);

        car_model.addEventListener(
            'change', 
            function(){ handleAllInputs() }, 
            false
        );

        car_type.addEventListener(
            'change', 
            function(){ handleAllInputs() }, 
            false
        );

        car_version.addEventListener(
            'change', 
            function(){ handleAllInputs() }, 
            false
        );
    }

    function handleAllInputs(){
        handleInput('car_model', 'car_type');
        handleInput('car_type', 'car_version');
        handleInput('car_version', '');
    }

    function handleInput(father_input_id, child_input_id){
        father_input = document.getElementById(father_input_id);

        var hierarchy = getFieldHierarchy(father_input_id);

        // console.log("Searching for "+father_input_id+" : "+father_input.value+" in :");
        // console.log(Object.keys(hierarchy));

        if (Object.keys(hierarchy).includes(father_input.value)){
            // console.log("Found")
            father_input.classList.remove("form_wrong");
            if (child_input_id != "")
                updateAutocompleteList(child_input_id, hierarchy[father_input.value]);    
        }

        else {
            // console.log("Not found")
            father_input.classList.add("form_wrong");
        }

        updateSaveButton();
    }

    function getFieldHierarchy(field_id){
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

    function updateAutocompleteList(id, tree){
        var options = Object.keys(tree);
        console.log(options);

        $('#'+id).autocomplete({
            source : options,
            minLength: 0
        });
    }

    function getModelHierarchy(){
        var json = document.getElementById("model_hierarchy").value;
        console.log(json);
        model_hierarchy = JSON.parse(json);
        console.log(model_hierarchy);
    }

    function saveModelHierarchy(){
        var save_field = document.getElementById("form_model_hierarchy_1");
        var saved_content = JSON.stringify(model_hierarchy);
        console.log("SAVING : "+saved_content);
        save_field.value = JSON.stringify(model_hierarchy);

        handleAllInputs();
    }

    function getFieldNum(field_name){
        var len = field_list.length;
        for (var i=0;i<len;i++){
            if (field_name == field_list[i]){
                return i;
            }
        }
    }

    function getValue(field_name){
        var value = document.getElementById(field_name).value;
        value = value.replace(',', '&com');
        return value;
    }

    function updateAttributes(source_id, target_id){
        console.log("Syncing "+source_id+" to "+target_id);
        var original_field = document.getElementById(source_id);
        var field = document.getElementById(target_id);
        
        var value = original_field.value;
        // value = value.replace(/\n/g, "NEWLINE");
        field.value = value;
    }

    function loadAttributes(){
        

        for (var key in custom_field_data) {
            var model_field = document.getElementById("form_"+key+"_1");
            var content = custom_field_data[key];
            // content = content.replace(/NEWLINE/g, "\n");
            model_field.value = content;
            updateAttributes("form_"+key+"_1", key);
        }
    }

    function setUpSyncFields(){
        for (var key in custom_field_data) {
            var id1 = "form_"+key+"_1";
            var id2 = key;
            var field1 = document.getElementById(id1);
            var field2 = document.getElementById(id2);

            console.log("Setting up sync between "+id1+" and "+id2);

            field1.addEventListener(
                'change',
                function() { updateAttributes(id1, id2); },
                false
            );

            field2.addEventListener(
                'change',
                function() { updateAttributes(id2, id1); },
                false
            );
        }
    }

</script>