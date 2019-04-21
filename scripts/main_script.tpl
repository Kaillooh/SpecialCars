<script>

    var hierarchy = null;


    $(document).ready(function() {

        var field_controller = new CommonFieldController(hierarchy);
        console.log("Loading content ?");
        field_controller.loadFieldContent();

        var hierarchy = new HierarchyController();
        hierarchy.renderTreeUI();

        var car_field_controller = new CarFieldController(hierarchy);

    })

    function disp_fields() {
        document.getElementById("true_fields").style.display="block";
    }

</script>