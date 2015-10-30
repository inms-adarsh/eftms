<?php global $path_to_root, $js_lib, $Validate, $Editors, $Ajax, $sql_queries;
$theme = user_theme();
?>

<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/

function page_footer($no_menu=false, $is_index=false)
{
	global $path_to_root, $js_lib, $Validate, $Editors, $Ajax, $sql_queries;
	$page_header_args = func_get_args();
	hook_invoke_all('pre_footer', $page_header_args);

	include_once($path_to_root."/themes/".user_theme()."/renderer.php");
	$rend = new renderer();
	//$rend->menu_footer($no_menu, $is_index);

	$edits = "editors = ".$Ajax->php2js($Editors).";";
	$Ajax->addScript('editors', $edits);

	echo "<script>
		_focus = '" . get_post('_focus') . "';
		_validate = " . $Ajax->php2js($Validate).";
		var $edits
	</script>";

   	add_user_js_data();
	echo "\n<script type=\"text/javascript\"><!--\n";

	foreach($js_lib as $text)
	  	echo $text;
	echo "\n--></script>\n";

	if ($sql_queries) {
		div_start('footer_debug');
		 echo "<div class='note_msg'>$sql_queries</div>";
		div_end();
	}
   
}?>
<!-- begin theme-panel -->
        <div class="theme-panel">
            <a href="javascript:;" data-click="theme-panel-expand" class="theme-collapse-btn"><i class="fa fa-cog"></i></a>
            <div class="theme-panel-content">
                <h5 class="m-t-0">Color Theme</h5>
                <ul class="theme-list clearfix">
                    <li class="active"><a href="javascript:;" class="bg-green" data-theme="default" data-click="theme-selector" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Default">&nbsp;</a></li>
                    <li><a href="javascript:;" class="bg-red" data-theme="red" data-click="theme-selector" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Red">&nbsp;</a></li>
                    <li><a href="javascript:;" class="bg-blue" data-theme="blue" data-click="theme-selector" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Blue">&nbsp;</a></li>
                    <li><a href="javascript:;" class="bg-purple" data-theme="purple" data-click="theme-selector" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Purple">&nbsp;</a></li>
                    <li><a href="javascript:;" class="bg-orange" data-theme="orange" data-click="theme-selector" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Orange">&nbsp;</a></li>
                    <li><a href="javascript:;" class="bg-black" data-theme="black" data-click="theme-selector" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Black">&nbsp;</a></li>
                </ul>
                <div class="divider"></div>
                <div class="row m-t-10">
                    <div class="col-md-5 control-label double-line">Header Styling</div>
                    <div class="col-md-7">
                        <select name="header-styling" class="form-control input-sm">
                            <option value="1">default</option>
                            <option value="2">inverse</option>
                        </select>
                    </div>
                </div>
                <div class="row m-t-10">
                    <div class="col-md-5 control-label">Header</div>
                    <div class="col-md-7">
                        <select name="header-fixed" class="form-control input-sm">
                            <option value="1">fixed</option>
                            <option value="2">default</option>
                        </select>
                    </div>
                </div>
                <div class="row m-t-10">
                    <div class="col-md-5 control-label double-line">Sidebar Styling</div>
                    <div class="col-md-7">
                        <select name="sidebar-styling" class="form-control input-sm">
                            <option value="1">default</option>
                            <option value="2">grid</option>
                        </select>
                    </div>
                </div>
                <div class="row m-t-10">
                    <div class="col-md-5 control-label">Sidebar</div>
                    <div class="col-md-7">
                        <select name="sidebar-fixed" class="form-control input-sm">
                            <option value="1">fixed</option>
                            <option value="2">default</option>
                        </select>
                    </div>
                </div>
                <div class="row m-t-10">
                    <div class="col-md-5 control-label double-line">Sidebar Gradient</div>
                    <div class="col-md-7">
                        <select name="content-gradient" class="form-control input-sm">
                            <option value="1">disabled</option>
                            <option value="2">enabled</option>
                        </select>
                    </div>
                </div>
                <div class="row m-t-10">
                    <div class="col-md-5 control-label double-line">Content Styling</div>
                    <div class="col-md-7">
                        <select name="content-styling" class="form-control input-sm">
                            <option value="1">default</option>
                            <option value="2">black</option>
                        </select>
                    </div>
                </div>
                <div class="row m-t-10">
                    <div class="col-md-12">
                        <a href="#" class="btn btn-inverse btn-block btn-sm" data-click="reset-local-storage"><i class="fa fa-refresh m-r-3"></i> Reset Local Storage</a>
                    </div>
                </div>
            </div>
        </div>
        <!-- end theme-panel -->
		
		<!-- begin scroll to top btn -->
		<a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top fade" data-click="scroll-top"><i class="fa fa-angle-up"></i></a>
		<!-- end scroll to top btn -->
</div>
	<!-- end page container -->
	<script>
	var theme = '<?php echo $path_to_root; ?>';
	</script>
	<!-- ================== BEGIN BASE JS ================== -->
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery/jquery-1.9.1.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery/jquery-migrate-1.1.0.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap/js/bootstrap.min.js></script>
	<!--[if lt IE 9]>
		<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/crossbrowserjs/html5shiv.js></script>
		<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/crossbrowserjs/respond.min.js></script>
		<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/crossbrowserjs/excanvas.min.js"></script>
	<![endif]-->
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/slimscroll/jquery.slimscroll.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery-cookie/jquery.cookie.js></script>
	<!-- ================== END BASE JS ================== -->
	
	<!-- ================== BEGIN PAGE LEVEL JS ================== -->
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/ionRangeSlider/js/ion-rangeSlider/ion.rangeSlider.min.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-colorpicker/js/bootstrap-colorpicker.min.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/masked-input/masked-input.min.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/gritter/js/jquery.gritter.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/flot/jquery.flot.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/flot/jquery.flot.time.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/flot/jquery.flot.resize.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/flot/jquery.flot.pie.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/sparkline/jquery.sparkline.js></script>
	<!--<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery-jvectormap/jquery-jvectormap-1.2.2.min.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery-jvectormap/jquery-jvectormap-world-mill-en.js></script>-->
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-select/bootstrap-select.min.js></script>
	<!-- <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/js/dashboard.js></script> -->
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/js/jquery.dataTables.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/js/dataTables.autoFill.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/js/dataTables.colReorder.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/js/dataTables.colVis.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/js/dataTables.fixedHeader.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/js/dataTables.keyTable.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/js/dataTables.tableTools.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/select2/dist/js/select2.min.js></script>
    <script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/js/form-plugins.demo.js></script>
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/js/apps.js></script>
	<!-- ================== END PAGE LEVEL JS ================== -->
	
	<script>
		$(document).ready(function() {
			App.init();
		    $('.datatable').DataTable({
            dom: 'CT<"clear">lfrtip',
            tableTools: {
                "sSwfPath": '<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/swf/copy_csv_xls_pdf.swf'
            },
           });
           FormPlugins.init();
           // TableManageCombine.init();
		});
        $(document).ajaxStop(function() {
            App.init();
            $('.datatable').DataTable({
            dom: 'CT<"clear">lfrtip',
            tableTools: {
                "sSwfPath": '<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/swf/copy_csv_xls_pdf.swf'
            }
           });
           FormPlugins.init();
        });
	</script>
	<?php
	 echo "</body></html>\n";
?>