
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

