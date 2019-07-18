<script>

    class SearchOptimizer {

        constructor() {
            this.tags = [];
        }

        addTag(tag){
            if (!this.tags.includes(tag)){
                this.tags.push(tag);
            }          
        }

        resetTags(){
            this.tags = [];
        }

        onmodif(){
            this.updateTags(this.tags);
        }

        scan_cars(){
            var car_list = document.getElementById("cars_list");

            for(var child=cars_list.firstChild; child!==null; child=child.nextSibling) {
                if (child.tagName == "DIV"){
                    var fields = child.getElementsByTagName("input"); 
                    
                    this.addTag(fields[0].value);
                    this.addTag(fields[1].value);
                    this.addTag(fields[2].value);
                }
            }
        }

        scan(){
            this.resetTags();
            this.addTag(document.getElementById("car_number").value);
            this.addTag(document.getElementById("car_option_code").value);
            this.addTag(document.getElementById("car_color_code").value);
            this.scan_cars();
            this.onmodif();
        }

        updateTags(tag_list){
            var tag_container = document.getElementById("form_step6_tags_1");
            var tag_csv = "";

            for (var i=0; i<tag_list.length; i++){
                tag_csv += tag_list[i]+", "
            }

            tag_csv = tag_csv.substring(0, tag_csv.length-2);

            var parent = tag_container.parentElement;
            tag_container.remove();
            tag_container = document.createElement("input");
            tag_container.id = "form_step6_tags_1";
            tag_container.name = "form[step6][tags][1]";
            tag_container.type = "text";
            tag_container.style = "display:none;"
            tag_container.value = tag_csv;
            parent.appendChild(tag_container);
        }

    }

</script>