<script>

    var hierarchy = null;
    var car_list_controller = null;
    var search_optimizer = null;


    $(document).ready(function() {

        var field_controller = new CommonFieldController(hierarchy);
        // console.log("Loading content ?");
        field_controller.loadFieldContent();

        var hierarchy = new HierarchyController();
        hierarchy.renderTreeUI();

        car_list_controller = new CarListController(hierarchy);

        search_optimizer = new SearchOptimizer();

        search_optimizer.addTag("extase");

        setInterval(function(){
            search_optimizer.scan();
        }, 500);

        field_controller.setupSync();
    })

    function disp_fields() {
        document.getElementById("true_fields").style.display="block";
    }

    function validate() {
        car_list_controller.validateFields();
    }

</script>