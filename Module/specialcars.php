<?php

use PrestaShopBundle\Form\Admin\Type\TranslateType;
use PrestaShopBundle\Form\Admin\Type\FormattedTextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\FormType;
use PrestaShop\PrestaShop\Core\Product\Search\ProductSearchResult;
use PrestaShop\PrestaShop\Core\Product\Search\ProductSearchProviderInterface;
use PrestaShop\PrestaShop\Core\Product\Search\ProductSearchContext;
use PrestaShop\PrestaShop\Core\Product\Search\ProductSearchQuery;

if (!defined('_PS_VERSION_')) {
    exit;
}

class SpecialCars extends Module
{
    public function __construct()
    {
        $this->name = 'specialcars';
        $this->tab = 'administration';
        $this->version = '1.0.0';
        $this->author = 'Pierre Etheve';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = [
            'min' => '1.6',
            'max' => _PS_VERSION_
        ];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Special Car Product Page');
        $this->description = $this->l('Module aimed at streamlining product entry for car-related purposes.');

        $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');

        if (!Configuration::get('MYMODULE_NAME')) {
            $this->warning = $this->l('No name provided');
        }

        $this->context->controller->addJS($this->_path.'script.js');
    }

    public function install()
	{
        if (!parent::install() OR       
            !$this->registerHook('displayAdminProductsExtra') OR
            !$this->registerHook('displayAdminProductsMainStepLeftColumnMiddle') OR
            !$this->registerHook('displayProductExtraContent') OR
            !$this->registerHook('displayProductAdditionalInfo') OR
            !$this->registerHook('actionProductSave') OR
            !$this->registerHook('actionProductAttributeUpdate') OR
            !$this->registerHook('actionAdminProductsControllerSaveAfter') OR
            !$this->registerHook('productSearchProvider') OR
            !$this->registerHook('displayHeader') OR
            !$this->registerHook('actionAdminProductsControllerSaveBefore'))



            return false;
        else
            return true;
	}

	public function uninstall()
	{
	    return parent::uninstall();
	}

    private function logObject($label, $object) {
        $array_txt = var_export($object, TRUE);
        error_log($label." : ".$array_txt);
    }

    public function generateData($product_id) {
        try{
            error_log("Generating data");
            $query = "SELECT * FROM ps_product WHERE `id_product`=".$product_id;
            $data = Db::getInstance()->executeS($query);
            // $this->logObject("SQL data", $data);

            $query2 = "SELECT * FROM ps_model_hierarchy WHERE `id`=1";
            $data2 = Db::getInstance()->executeS($query2);

            $model_hierarchy = $data2[0]['full_hierarchy'];
            error_log('Model Hierarchy : '.$model_hierarchy);

            $car_number = $data[0]['car_number'];
            $car_color_code = $data[0]['car_color_code'];
            $car_option_code = $data[0]['car_option_code'];
            $car_data = $data[0]['car_data'];
            // $product_id = $_REQUEST['form']['id_product'];
            error_log("Saving car data : ");
            error_log($car_data);
            $content = "<script>var custom_field_data={'car_number':'".$car_number."', 'car_color_code':'".$car_color_code."', 'car_option_code':'".$car_option_code."', 'model_hierarchy' : '".$model_hierarchy."', 'car_data' : '".$car_data."'};</script>";
            return $content;
        } 
        catch (Exception $e){
            error_log("Error caught in 'generateData'");
            error_log($e->getMessage());
        }

    }

    public function hookDisplayAdminProductsMainStepLeftColumnMiddle($params){
        try{
            error_log("Hook 'displayAdminProductsMainStepLeftColumnMiddle' running (test)");
            
            $scripts = array('newfieldstut.tpl', 'scripts/hierarchy.tpl', 'scripts/fields.tpl', 'scripts/search_opti.tpl', 'scripts/main_script.tpl');

            $content = "";
            foreach ($scripts as $script) {
                error_log("Adding script '".$script."'");
                $content = $content.$this->display(__FILE__, $script);
            }

            $id_product = $params['id_product'];
            $content = $content.$this->generateData($id_product);
            // $content = "";
            return $content;
        } catch (Exception $e) {
            error_log("Error caught in 'hookDisplayAdminProductsMainStepLeftColumnMiddle'");
            error_log($e->getMessage());
        }
    }

    public function hookDisplayAdminProductsExtra($params)
    {
        try{
            error_log("'hookDisplayAdminProductsExtra' running !");
            $productAdapter = $this->get('prestashop.adapter.data_provider.product');
            $product = $productAdapter->getProduct($params['id_product']);
            $formData = [];
            $formFactory = $this->get('form.factory');
            $form = $formFactory->createBuilder(FormType::class, $formData)
                ->add('car_number', TranslateType::class, array(
                    'label' => 'Serial number',
                    'locales' => Language::getLanguages(),
                    'hideTabs' => true,
                    'required' => false
                ))
                ->add('car_option_code', TranslateType::class, array(
                    'label' => 'Option code',
                    'locales' => Language::getLanguages(),
                    'hideTabs' => true,
                    'required' => false
                ))
                ->add('car_color_code', TranslateType::class, array(
                    'label' => 'Color code',
                    'locales' => Language::getLanguages(),
                    'hideTabs' => true,
                    'required' => false
                ))
                ->add('model_hierarchy', TranslateType::class, array(
                    'label' => 'Hierarchy',
                    'locales' => Language::getLanguages(),
                    'hideTabs' => true,
                    'required' => false
                ))
                ->add('car_data', TranslateType::class, array(
                    'label' => 'Car Data',
                    'locales' => Language::getLanguages(),
                    'hideTabs' => true,
                    'required' => false
                ))

            ->getForm()
            ;
            return $this->get('twig')->render(_PS_MODULE_DIR_.'specialcars/views/display-admin-products-extra.html.twig', [
                'form' => $form->createView()
            ]) ;
        }   

        catch(Exception $e){
            error_log("Error caught in 'hookDisplayAdminProductsExtra'");
            error_log($e->getMessage());
        }

    }

    public function hookActionAdminProductsControllerSaveBefore($params)
    {
        try{
            $productAdapter = $this->get('prestashop.adapter.data_provider.product');
            $product = $productAdapter->getProduct($_REQUEST['form']['id_product']);

            $car_number = $_REQUEST['form']['car_number'][1];
            $car_color_code = $_REQUEST['form']['car_color_code'][1];
            $car_option_code = $_REQUEST['form']['car_option_code'][1];
            $product_id = $_REQUEST['form']['id_product'];
            $model_hierarchy = $_REQUEST['form']['model_hierarchy'][1];
            $car_data = $_REQUEST['form']['car_data'][1];

            error_log("Saving data for product_id #".$product_id);

            $this->logObject("Form data", $_REQUEST['form']);            

            // error_log("Model Hierarchy : ".$model_hierarchy);

            $sql_query = "UPDATE `ps_product` SET `car_number`='".$car_number."',`car_option_code`='".$car_option_code."',`car_color_code`='".$car_color_code."',`car_data`='".$car_data."' WHERE  `id_product`=".$product_id;
            error_log("QUERY 1 : ".$sql_query);
            Db::getInstance()->execute($sql_query);

            $sql_query_2 = "UPDATE `ps_model_hierarchy` SET `full_hierarchy`='".$model_hierarchy."' WHERE  `id`= 1";
            // error_log("QUERY 2 : ".$sql_query_2);
            Db::getInstance()->execute($sql_query_2);

        } 
        catch (Exception $e){
            error_log("Error caught in 'hookActionAdminProductsControllerSaveBefore'");
            error_log($e->getMessage());
        }

    } 

    public function hookActionAdminProductsControllerSaveAfter($params)
    {
        try{
            error_log("'hookActionAdminProductsControllerSaveAfter' running !");
        } 
        catch (Exception $e){
            error_log("Error caught in 'hookActionAdminProductsControllerSaveAfter'");
            error_log($e->getMessage());
        }

    } 

    public function hookDisplayProductExtraContent($params){
        try{
            // $this->logObject("Display product params", $params["product"]->id);
            $product_id = $params["product"]->id;
            $content = $this->generateData($product_id);
            error_log('Content : "'.$content.'"');
            $this->display_data = $content;
            return $content;

        } catch (Exception $e) {
            error_log("Error caught in 'hookDisplayProductExtraContent'");
            error_log($e->getMessage());
        }
    }

    public function hookDisplayProductAdditionalInfo($params){
        try{
            error_log("Hey from display additional infos ! ");
            $content = $this->display(__FILE__, 'extra_info_tab.tpl');
            error_log('Content : "'.$content.'"');
            // $this->logObject("Display product params", array_keys($params));
            // $this->logObject("Display product params", $params['product']);
            return $this->display_data.$content;

        } catch (Exception $e) {
            error_log("Error caught in 'hookDisplayProductAdditionalInfo'");
            error_log($e->getMessage());
        }
    }



    public function hookActionProductSave($params) {
        try{
            error_log("Hey from product save ! ");
            // $this->logObject("Product save params", $params);

        } catch (Exception $e) {
            error_log("Error caught in 'hookActionProductSave'");
            error_log($e->getMessage());
        }
    }

    public function hookActionProductAttributeUpdate($params) {
        try{
            error_log("Hey from product attribute update ! ");
            $this->logObject("Product attribute update params", $params);

        } catch (Exception $e) {
            error_log("Error caught in 'hookActionProductSave'");
            error_log($e->getMessage());
        }
    }

    public function hookProductSearchProvider($params){
        error_log("Hey from hookProductSearchProvider !");
        return new CustomSearchEngine();
    }

    public function hookDisplayHeader($params){
        error_log("Hey from hookDisplayHeader !");
        $categories = $this->gatherCategories();

        $query2 = "SELECT * FROM ps_model_hierarchy WHERE `id`=1";
        $data2 = Db::getInstance()->executeS($query2);
        $model_hierarchy = $data2[0]['full_hierarchy'];

        $content = "<script>var categories=".json_encode($categories)."; var hierarchy = ".$model_hierarchy."</script>";

        return $content;
    }

    private function gatherCategories(){
        try{
            $query = "SELECT * FROM ps_category";
            $data = Db::getInstance()->executeS($query);
            $category_id = array();

            foreach ($data as $category) {
                array_push($category_id, $category['id_category']);
            }

            $final_categories = array(1=>array(), 2=>array(), 3=>array(), 4=>array());

            foreach ($category_id as $id) {
                if ($id != 1 and $id != 2){
                    $query = "SELECT * FROM ps_category_lang WHERE id_category=".$id;
                    error_log($query);
                    $data = Db::getInstance()->executeS($query);
                    // $this->logObject("Category ".$id, $data);
                    foreach ($data as $lang_cat) {
                        // array_push($final_categories[$lang_cat['id_lang']], );
                        $final_categories[$lang_cat['id_lang']][$lang_cat['name']] = $id;
                    }
                }
            }

            // error_log($final_categories);

            return $final_categories;

        } catch (Exception $e) {
            error_log("Error caught in 'gatherCategories'");
            error_log($e->getMessage());
        }
    }
}

class CustomSearchEngine implements ProductSearchProviderInterface{

    public function runQuery(ProductSearchContext $context, ProductSearchQuery $params){
        $this->logObject("Params", $params);

        $search_params = $this->getSearchParams();
        $this->logObject("Search params", $search_params);

        $array_list = $this->selectAll();;

        if (array_key_exists('brand', $search_params)){
            $new_list = $this->selectBrand($search_params['brand']);
            $array_list = $this->fuseList($new_list, $array_list);
        }

        if (array_key_exists('type', $search_params)){
            $new_list = $this->selectType($search_params['type']);
            $array_list = $this->fuseList($new_list, $array_list);
        }

        if (array_key_exists('model', $search_params)){
            $new_list = $this->selectModel($search_params['model']);
            $array_list = $this->fuseList($new_list, $array_list);
        }

        if (array_key_exists('car', $search_params)){
            $new_list = $this->selectCar($search_params['car']);
            $array_list = $this->fuseList($new_list, $array_list);
        }

        $this->logObject("Results", $array_list);
        
        $new_products = new ProductSearchResult();
        $new_products->setProducts($array_list);
        return $new_products;
    }

    private function fuseList($array1, $array2){
        $new_array = array();
        foreach ($array1 as $value1) {
            foreach ($array2 as $value2) {
                // error_log("Comparing ".$value1['id_product']." and ".$value2["id_product"]);
                if ($value1['id_product'] == $value2["id_product"]){
                    array_push($new_array, $value1);
                }
            }
        }
        return $new_array;
    }

    private function selectAll(){
        $query = "SELECT * FROM `ps_product`";
        return $this->query($query);
    }

    private function selectBrand($brand){
        $brand = str_replace("+", " ", $brand);
        $query = "SELECT * FROM `ps_product` WHERE car_data LIKE '%".$brand."%'";
        return $this->query($query);
    }

    private function selectType($type){
        $query = "SELECT * FROM `ps_category_product` WHERE id_category=".$type;
        return $this->query($query);
    }

    private function selectCar($car){
        $car = str_replace("+", " ", $car);
        $query = "SELECT * FROM `ps_product` WHERE car_data LIKE '%".$car."%'";
        return $this->query($query);
    }

    private function selectModel($model){
        $model = str_replace("+", " ", $model);
        $query = "SELECT * FROM `ps_product` WHERE car_data LIKE '%".$model."%'";
        return $this->query($query);
    }

    private function query($query){
        error_log($query);
        $data = Db::getInstance()->executeS($query);

        $product_id = array();

        foreach ($data as $entry) {
            array_push($product_id, array("id_product"=>$entry['id_product']));
        }
        return $product_id;
    }

    private function getSearchParams(){
        $search_params = array();
        error_log($_SERVER['REQUEST_URI']);

        $possible_args = array("type", "brand", "model", "car");

        foreach ($possible_args as $arg) {
            if (isset($_GET[$arg])){
                $search_params[$arg] = $_GET[$arg];
            }
        }

        return $search_params;
    }

    private function logObject($label, $object) {
        $array_txt = var_export($object, TRUE);
        error_log($label." : ".$array_txt);
    }
}