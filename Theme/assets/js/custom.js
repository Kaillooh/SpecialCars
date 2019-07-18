/*
 * Custom code goes here.
 * A template should always ship with an empty custom.js
 */

console.log("HEEY");

window.onload = startup;

dummy_data = ["Mercedes", "Renault", "Peugeot"];
category_hierarchy = {"brand_category":"car_category", "car_category":"model_category"};
current_selected_category = null;

selected_search_options = {};

function startup(){
	console.log("Starting up !");
	console.log(getLocation());
	var location = getLocation();

	if (location == "index"){
		relocateSearch();
		addBanner();
		initDrawer();
		launchSearch();

	} 
	else if (location == "iframe"){
		expandProducts();
		addBaseTag();
		hideWaitingCache();
		changeBackground();
	}
	else {
		var logo = document.getElementsByClassName("logo")[0];
		logo.src = "/Prestashop/themes/verstappen_theme/assets/css/VD_logo.png";
		logo.style.opacity = "1";
	}

	display("wrapper");
	display("footer");
}

function display(element_id){
	var element = document.getElementById(element_id);
	if (element != null){
		element.style.opacity = "1";
	}
}

function expandProducts(){
	var body = document.body
	// var products = document.getElementById("wrapper").getElementsByClassName("container")[0];
	var products = document.getElementById("wrapper");
	products.className = "full_page";
	body.innerHTML = "";
	body.appendChild(products);
	console.log(products);

	var title = document.getElementById("main").getElementsByTagName("h2")[0];
	var header = document.getElementById("js-product-list-top");
	title.remove();
	header.remove();
}

function addBaseTag(){
	var body = document.body;
	var base = document.createElement("base");
	base.target = "_parent";
	body.appendChild(base);
	console.log(base);
}

function getLocation(){
	var raw_location = window.location.pathname;
	var full_url = window.location.href;
	console.log(raw_location);
	if (raw_location == "/Prestashop/en/"){
		return "index";
	} 
	else if (raw_location.includes("search") && full_url.includes("iframe=on")){
		console.log("IFrame detected !");
		return "iframe";
	}
	return "unknown";
}

function relocateSearch(){
	search_bar = document.getElementById("search_widget");
	search_bar.remove();

	var input_field = search_bar.getElementsByTagName("INPUT")[0];
	console.log(input_field.outerHTML);
	input_field.placeholder = "Search our shop";

	search_container = document.createElement("div");
	search_container.className = "search_container";
	search_container.appendChild(search_bar);

	main_section = document.getElementById("main");
	main_section.insertBefore(search_container, main_section.firstChild);

}

function addBanner(){
	var wrapper = document.getElementById("wrapper");

	var banner = document.createElement("div");
	banner.id = "verstappen_banner";

	var image = document.createElement("img");
	image.src = "/Prestashop/themes/verstappen_theme/assets/css/VD_temp_banner.png";

	banner.appendChild(image);
	wrapper.insertBefore(banner, wrapper.firstChild);
}

function hideWaitingCache(){
	console.log("Attempting to hide cache");
	var cache = parent.document.getElementById("cache");
	console.log(cache);
	cache.style.opacity = "0";
	cache.style.zIndex = "0";
}

function changeBackground(){
	console.log('Attempting to remove background');
	var body = document.body;
	body.style.background = "none";
}


function initDrawer(){
	document.getElementById("drawer_search").oninput = changeDrawerPropositions;
	displayPropositions(dummy_data);
}

function changeDrawerPropositions(){
	var input = document.getElementById("drawer_search").value;
	var prop_list = generateList(input, dummy_data);
	displayPropositions(prop_list);
}

function generateList(input, full_list){
	var select = [];
	for (var i=0; i<full_list.length; i++){
		if (full_list[i].toLowerCase().includes(input.toLowerCase())){
			select.push(full_list[i]);
		}
	}
	return select;
}

function displayPropositions(list){
	var spots = document.getElementById("drawer").getElementsByTagName("p");
	spots[0].innerText = "ALL";
	for (var i=0; i<spots.length-1; i++){
		if (i<list.length){
			spots[i+1].innerText = list[i];
		}
		else {
			spots[i+1].innerText = "";
		}
	}
}

function validateChoice(element){
	var content = element.getElementsByTagName("p")[0].innerText;
	console.log(current_selected_category);
	current_display_text = current_selected_category.getElementsByTagName("p")[0];

	if (content == "ALL"){
		content = "";
	}

	current_display_text.innerHTML= "<br/>"+content;
	current_selected_category.selected = content;
	selected_search_options[current_selected_category.id] = content;

	console.log(selected_search_options);

	drawer.style.display = 'none';
	current_selected_category = null;

	formatCategoriesText();
	updateCategoriesVisibility();
	launchSearch();
	displayWaitingCache();
}

function formatCategoriesText(){
	var categories = document.getElementsByClassName("category_container");

	for (var i=0; i<categories.length; i++){
		var category = categories[i];
		var text = category.getElementsByTagName("p")[0];
		if (text.innerHTML == "<br/>"){
			text.style.display = "none";
		}
		else {
			text.style.display = "inline";
		}
	}
}

function getCategoryQuery(category_id){
	var keys = Object.keys(selected_search_options);
	if (keys.includes(category_id)){
		if (selected_search_options[category_id] != ""){
			return selected_search_options[category_id];
		}
	}
	return "";
}

function updateCategoriesVisibility(){
	for (var i=0; i<Object.keys(category_hierarchy).length; i++){

		var parent_category = Object.keys(category_hierarchy)[i];
		var parent_element = document.getElementById(parent_category).parentElement;

		var child_category = category_hierarchy[parent_category];
		var child_element = document.getElementById(child_category).parentElement;

		var category_query = getCategoryQuery(parent_category);

		console.log("Updating relation '"+parent_category+"'-'"+child_category+"' with value '"+category_query+"'");

		if (category_query == ""){
			child_element.style.display = "none";
		} 
		else if (parent_element.style.display == "none"){
			child_element.style.display = "none";
		}
		else {
			child_element.style.display = "block";
			console.log("Displaying '"+child_category+"' !");
			console.log(child_element);
		}

	}
}

function displayWaitingCache(){
	var cache = document.getElementById("cache");
	cache.style.opacity = "1";
	cache.style.zIndex = "2";
}

function launchSearch(){
	var iframe = document.getElementById("full_products");
	var url = "http://"+window.location.hostname+"/Prestashop/en/search?controller=search&iframe=on";

	var keys = Object.keys(selected_search_options);
	for (var i=0; i<keys.length; i++){
		var element = selected_search_options[keys[i]];
		console.log(keys[i]);
		if (element == "ALL"){

		}
		else if (keys[i] == "brand_category"){
			element = element.split(" ").join("+");
			url = url+"&brand="+element;
		} 
		else if (keys[i] == "car_category"){
			element = element.split(" ").join("+");
			url = url+"&car="+element;
		} 
		else if (keys[i] == "model_category"){
			element = element.split(" ").join("+");
			url = url+"&model="+element;
		} 
		else if (keys[i] == "type_category"){
			url = url+"&type="+categories[1][element];
		}
	}
	console.log(url);

	iframe.src = url;
}

function openDrawer(element){
	var drawer = document.getElementById("drawer");
	var drawer_style = getComputedStyle(drawer, null);
	if (current_selected_category == element) {
		drawer.style.display = "none";
		current_selected_category = null;
	} else {
		console.log(element);
		if (element.id == "brand_category"){
			dummy_data = Object.keys(hierarchy);
		} 
		else if (element.id == "car_category"){
			var current_brand = selected_search_options["brand_category"];
			dummy_data = Object.keys(hierarchy[current_brand]);
		} 
		else if (element.id == "model_category"){
			var current_brand = selected_search_options["brand_category"];
			var current_car = selected_search_options["car_category"]
			dummy_data = Object.keys(hierarchy[current_brand][current_car]);
		}
		else if (element.id == "type_category"){
			dummy_data = Object.keys(categories[1]);
		}
		console.log(dummy_data);
		displayPropositions(dummy_data);

		var pos = element.offsetTop;
		drawer.style.display = "flex";
		drawer.style.top = (pos-10)+"px";
		current_selected_category = element;
	}
}