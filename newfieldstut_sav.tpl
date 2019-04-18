<h2>Cars specifics</h2>
<script src="//code.jquery.com/jquery-2.1.4.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script src="//netsh.pp.ua/upwork-demo/1/js/typeahead.js"></script>
<script>
    var field_list = ["car_model", "car_type", "car_version", "car_serial", "car_optioncode", "car_colorcode"];

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
        
    	field.value = original_field.value;
    }

    function loadAttributes(){
        

        for (var key in custom_field_data) {
            var model_field = document.getElementById("form_"+key+"_1");
            model_field.value = custom_field_data[key];
            updateAttributes("form_"+key+"_1", key);

            // setUpSyncFields();
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

    window.onload = loadAttributes;

</script>
<div class="separation"></div>

<br/>
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

