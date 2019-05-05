
<style>
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
        outline: 1px solid #d9d9d9;
        width:225px;
        padding: 20px;
        background-color: #fafafa;
        display: inline-block;
        margin: 7px;

    }

    .car_close_button{
        display: inline-block;
        top:50px;
        left:50px;
        margin-right: auto;
    }

    .align_right {
        text-align: right;
        margin-bottom: -24px;
        margin-top: -11px;
    }

    .car_model_form, .car_type_form, .car_version_form{
        padding: 5px;
        border: 1px solid #d9d9d9;
    }

    .form_wrong{
        border: 1px solid rgba(255, 50, 50, 150);
    }

</style>

<h2>Cars specifics</h2>

<button type="button" class="btn btn-outline-secondary" id="add_car_btn">Add car</button>
<div id="cars_list">
    <template id="car_field_template">
        <div class="align_right"><a class="car_close_button" href="javascript:void(0);" >x</a></div>
        <br/>
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

