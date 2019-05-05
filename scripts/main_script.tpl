<script>

    var hierarchy = null;
    var car_list_controller = null;


    $(document).ready(function() {

        var field_controller = new CommonFieldController(hierarchy);
        console.log("Loading content ?");
        field_controller.loadFieldContent();

        var hierarchy = new HierarchyController();
        hierarchy.renderTreeUI();

        car_list_controller = new CarListController(hierarchy);

    })

    function disp_fields() {
        document.getElementById("true_fields").style.display="block";
    }

    function validate() {
        car_list_controller.validateFields();
    }

</script>