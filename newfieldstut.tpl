
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

    .car_container{
        outline: 1px solid #b3b3b3;
        width:225px;
        padding: 20px;
        background-color: #f6f6f6;
        display: inline-block;
        margin: 7px;

    }

    .car_close_button{
        display: block;
        position: absolute;
        top:50px;
        left:50px;
    }
</style>

<h2>Cars specifics</h2>

<button type="button" class="btn btn-outline-secondary" id="add_car">Add car</button>
<div id="cars_list">
    <template id="car_field_template">
        <a class="pstaggerClosingCross car_close_button" href="#" data-id="2">x</a>
        Model
        <br/><input type="text" name="car_model" class="car_model_form" class="form-control"></input>
        <br/>
        Type
        <br/><input type="text" name="car_type" class="car_type_form" class="form-control"></input>
        <br/>
        Version
        <br/><input type="text" name="car_version" class="car_version_form" class="form-control"></input>
    </template>
</div>

<br/>
Serial Number
<br/><input type="text" name="car_number" id="car_number" class="form-control"></input>
<br/>
Option code
<br/><input type="text" name="car_option_code" id="car_option_code" class="form-control"></input>
<br/>
Color code
<br/><input type="text" name="car_color_code" id="car_color_code" class="form-control"></input>



<!-- <br/><br/>

<button type="button" class="btn btn-outline-primary sensitive" onclick="updateAttributes();">Generate form</button> -->

