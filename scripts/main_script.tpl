<script>

    var hierarchy = null;


    $(document).ready(function() {

        field_controller = new CommonFieldController(hierarchy);
        console.log("Loading content ?");
        field_controller.loadFieldContent();
        
        hierarchy = new HierarchyController();
        hierarchy.renderTreeUI();

    })

    function disp_fields() {
        document.getElementById("true_fields").style.display="block";
    }

</script>