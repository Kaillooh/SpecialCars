<script>

	class HierarchyController {

		constructor() {
			this.data = {};
			this.current_position = [];

			this.loadHierarchyData();
			this.bindListeners();
		}

		bindListeners(){
			var tree = this;
			document.getElementById("tree_nav_back").addEventListener(
	            'click',
	            function(event) { 
	                tree.current_position.pop();
	                tree.renderTreeUI();
	            },
	            false
	        );

	        document.getElementById("tree_nav_new").addEventListener(
	            'click',
	            function() {
	            	tree.newElement();
	            },
	            false
	        );
		}

		newElement(){
			var new_value = document.getElementById("tree_new_element").value;
	        document.getElementById("tree_new_element").value = "";
	        console.log("New value : "+new_value);
	        if (new_value == ""){
	            return;
	        }

	        var local_tree = this.getLocalTree();

	        local_tree[new_value] = {};

	        this.renderTreeUI();
	        this.saveHierarchyData();
		}

		deleteElement(element){
			var element_name = element.parentNode.previousSibling.innerHTML;
	        console.log(element_name);
	        var tree = this.getLocalTree();
	        delete tree[element_name];
	        this.renderTreeUI();
	        this.saveHierarchyData();
		}

		loadHierarchyData(){
			var json = document.getElementById("model_hierarchy").value;
	        console.log(json);
	        this.data = JSON.parse(json);
	        console.log(this.data);
		}

		saveHierarchyData(){
			var save_field = document.getElementById("form_model_hierarchy_1");
	        var saved_content = JSON.stringify(this.data);
	        console.log("SAVING : "+saved_content);
	        save_field.value = JSON.stringify(this.data);

	        //handleAllInputs();
		}

		generateDeleteButton(){
			var delete_button = document.createElement("a")
	        delete_button.classList.add("btn");
	        delete_button.classList.add("delete");
	        delete_button.classList.add("discreet");

	        var delete_icon = document.createElement("i");
	        delete_icon.classList.add("material-icons");
	        delete_icon.innerHTML = "delete";

	        delete_button.appendChild(delete_icon);

	        var tree = this;
	        delete_button.addEventListener(
	            'click',
	            function(event){ tree.deleteElement(event.target) },
	            false
	        );

	        return delete_button;
		}

		generateCategoryButton(text){
			var button = document.createElement("button");
	        button.type = "button";
	        button.classList.add("btn");
	        button.classList.add("tree_category");
	        button.classList.add("btn-outline-secondary");
	        button.innerHTML = text;

	        var tree = this;
	        button.addEventListener(
	            'click',
	            function(event) {
	                tree.current_position.push(event.target.innerHTML);
	                console.log(tree.current_position);
	                tree.renderTreeUI();
	            },
	            false
	        );

	        var delete_button = this.generateDeleteButton();

	        var container = document.createElement("div");
	        container.appendChild(button);
	        container.appendChild(delete_button);
	        

	        return container;
		}

		getLocalTree(){
			var tree = this.data;

	        for (var i=0; i<this.current_position.length; i++){
	            var item = this.current_position[i];
	            tree = tree[item];
	        }

	        return tree;
		}

		renderTreeUI(){
			var tree = this.getLocalTree();

	        var list = Object.keys(tree);

	        var container = document.getElementById("tree_display");

	        while(container.firstChild){
	            container.removeChild(container.firstChild);
	        }

	        for (var i=0; i<list.length; i++){
	            var item = list[i];
	            container.appendChild(this.generateCategoryButton(item))

	        }
		}
	}

</script>