<script>

    var hierarchy = null;


    $(document).ready(function() {

        var field_controller = new CommonFieldController(hierarchy);
        console.log("Loading content ?");
        field_controller.loadFieldContent();

        var hierarchy = new HierarchyController();
        hierarchy.renderTreeUI();

        var car_field_controller = new CarFieldController(hierarchy);

        console.log("Testing getLocalHierachy for 'car_model'");
        console.log(car_field_controller.getLocalHierarchy('car_model'));

        console.log("Testing getLocalHierachy for 'car_type'");
        console.log(car_field_controller.getLocalHierarchy('car_type'));

        console.log("Testing getLocalHierachy for 'car_version'");
        console.log(car_field_controller.getLocalHierarchy('car_version'));

    })

    function disp_fields() {
        document.getElementById("true_fields").style.display="block";
    }

</script>