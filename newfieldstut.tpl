

<script>


    
    var field_list = ["car_model", "car_type", "car_version", "car_serial", "car_optioncode", "car_colorcode"];

    var model_hierarchy = {}

    var tree_display_position = [];


    $(document).ready(function() {

        updateAllComplete();
        generateTreeDisplay();

        document.getElementById("tree_nav_back").addEventListener(
            'click',
            function(event) { 
                tree_display_position.pop();
                generateTreeDisplay();
            },
            false
        );

        document.getElementById("tree_nav_new").addEventListener(
            'click',
            newTreeElement,
            false
        );

        document.getElementById("tree_nav_delete").addEventListener(
            'click',
            deleteCurrentElement,
            false
        );

    })

    function deleteCurrentElement(element){
        var element_name = element.parentNode.previousSibling.innerHTML;
        console.log(element_name);
        var tree = getLocalTree();
        delete tree[element_name];
        generateTreeDisplay();
        saveModelHierarchy();
    }

    function newTreeElement(){
        var new_value = document.getElementById("tree_new_element").value;
        document.getElementById("tree_new_element").value = "";
        console.log("New value : "+new_value);
        if (new_value == ""){
            return;
        }

        var tree = getLocalTree();

        tree[new_value] = {};

        generateTreeDisplay();
        saveModelHierarchy();
    }

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

    function updateSaveButton(){
        if (document.getElementById("car_model").classList.contains("form_wrong")){
            getSaveButton().disabled = true;
        }
        else {
            getSaveButton().disabled = false;
        }
    }

    function getSaveButton(){
        var button_list = document.getElementsByClassName("js-btn-save");
        for (var i=0; i<button_list.length; i++){
            if (button_list[i].classList.contains("btn-primary")){
                return button_list[i];
            }
        }
    }

    function startup(){
        loadAttributes();
        getModelHierarchy();
        updateAllComplete();
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

    function hey(){
        console.log("HEY !");
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

    function popup(){
        console.log("POPUP !");
        console.log(custom_field_data['model_hierarchy']);
    }

    function generateDeleteButton(){
        var delete_button = document.createElement("a")
        delete_button.classList.add("btn");
        delete_button.classList.add("delete");
        delete_button.classList.add("discreet");

        var delete_icon = document.createElement("i");
        delete_icon.classList.add("material-icons");
        delete_icon.innerHTML = "delete";

        delete_button.appendChild(delete_icon);

        delete_button.addEventListener(
            'click',
            function(event){ deleteCurrentElement(event.target) },
            false
        );

        return delete_button;
    }

    function generateButton(text){
        var button = document.createElement("button");
        button.type = "button";
        button.classList.add("btn");
        button.classList.add("tree_category");
        // button.classList.add("btn-block" );
        button.classList.add("btn-outline-secondary");
        button.innerHTML = text;

        button.addEventListener(
            'click',
            function(event) { 
                tree_display_position.push(event.target.innerHTML);
                console.log(tree_display_position);
                generateTreeDisplay();
            },
            false
        );

        var delete_button = generateDeleteButton();

        var container = document.createElement("div");
        container.appendChild(button);
        container.appendChild(delete_button);
        

        return container;
    }

    function getLocalTree(){
        var tree = model_hierarchy;

        for (var i=0; i<tree_display_position.length; i++){
            item = tree_display_position[i];
            tree = tree[item];
        }

        return tree;
    }


    function generateTreeDisplay(){
        var tree = getLocalTree();

        var list = Object.keys(tree);

        var container = document.getElementById("tree_display");

        while(container.firstChild){
            container.removeChild(container.firstChild);
        }

        for (var i=0; i<list.length; i++){
            item = list[i];
            container.appendChild(generateButton(item))

        }
    }

    window.onload = startup;

</script>

<style>
    .form_wrong{
        border: 1px solid rgba(255, 50, 50, 150);
    }

    .tree_category{
        width: 500px;
        margin-bottom: 5px;
    }

    .discreet{
        opacity: 0.2;
    }

    .discreet:hover{
        opacity: 1;
    }
</style>

<h2>Cars specifics</h2>

<!-- <div class="separation"></div> -->


Model
<br/><input type="text" name="car_model" id="car_model" class="form-control" onchange="updateAttributes(this.id, 'form_car_model_1');"></input>
<br/>
Type
<br/><input type="text" name="car_type" id="car_type" class="form-control" onchange="updateAttributes(this.id, 'form_car_type_1');"></input>
<br/>
Version
<br/><input type="text" name="car_version" id="car_version" class="form-control" onchange="updateAttributes(this.id, 'form_car_version_1');"></input>
<br/>
Serial Number
<br/><input type="text" name="car_number" id="car_number" class="form-control" onchange="updateAttributes(this.id, 'form_car_number_1');"></input>
<br/>
Option code
<br/><input type="text" name="car_option_code" id="car_option_code" class="form-control" onchange="updateAttributes(this.id, 'form_car_option_code_1');"></input>
<br/>
Color code
<br/><input type="text" name="car_color_code" id="car_color_code" class="form-control" onchange="updateAttributes(this.id, 'form_car_color_code_1');"></input>



<!-- <br/><br/>

<button type="button" class="btn btn-outline-primary sensitive" onclick="updateAttributes();">Generate form</button> -->

