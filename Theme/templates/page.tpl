{**
 * 2007-2018 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License 3.0 (AFL-3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/AFL-3.0
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    PrestaShop SA <contact@prestashop.com>
 * @copyright 2007-2018 PrestaShop SA
 * @license   https://opensource.org/licenses/AFL-3.0 Academic Free License 3.0 (AFL-3.0)
 * International Registered Trademark & Property of PrestaShop SA
 *}
{extends file=$layout}

{block name='content'}

  <section id="main">

    {block name='page_header_container'}
      {block name='page_title' hide}
        <header class="page-header">
          <h1>{$smarty.block.child}</h1>
        </header>
      {/block}
    {/block}

    {block name='page_content_container'}
      <section id="content" class="page-content card card-block">
        {block name='page_content_top'}{/block}
        {block name='page_content'}
          <!-- Page content -->
        {/block}
      </section>
    {/block}

    <div id="advanced_search_panel">
      <div id="left_search_controller">
        <div class="category_container"><button onclick="openDrawer(this);" class="btn-unstyle category_btn" id="brand_category">BRAND<p></p></button></div>

        <div class="category_container" style="display: none;"><button onclick="openDrawer(this);" class="btn-unstyle category_btn" id="car_category">CAR<p></p></button></div>

        <div class="category_container" style="display: none;"><button onclick="openDrawer(this);" class="btn-unstyle category_btn" id="model_category">MODEL<p></p></button></div>

        <div class="category_container"><button onclick="openDrawer(this);" id="type_category" class="btn-unstyle category_btn">TYPE<p></p></button></div>
      </div>

      <div id="drawer">
        <input type="text" name="drawer_search" id="drawer_search">
        <a onclick="validateChoice(this);" class="choice"><p>YO</p></a>
        <a onclick="validateChoice(this);" class="choice"><p>YO</p></a>
        <a onclick="validateChoice(this);" class="choice"><p>YO</p></a>
        <a onclick="validateChoice(this);" class="choice"><p>YO</p></a>
        <a onclick="validateChoice(this);" class="choice"><p>YO</p></a>
        <a onclick="validateChoice(this);" class="choice"><p>YO</p></a>
      </div>

      <div id="iframe_container">
        <div id="cache">
          <div id="cache_status_text">No results found.</div>
        </div>
        <iframe id="full_products"
            title="Inline Frame Example"
            width="1155"
            height="800"
            scrolling="no"
            style="border:none;"
            src="http://localhost/Prestashop/en/search?controller=search&s=merc&iframe=on">
        </iframe>
      </div>
    </div>

    {block name='page_footer_container'}
      <footer class="page-footer">
        {$language.id}
        {block name='page_footer'}
          <!-- Footer content -->
        {/block}
      </footer>
    {/block}

  </section>

{/block}
