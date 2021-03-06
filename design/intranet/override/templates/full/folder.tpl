
<div id="middle">
	{if fetch( 'content', 'access', hash( 'access', 'create',
                                                      'contentobject', $node,
                                                      'contentclass_id', 'comment' ) )}
                    <form method="post" action={"content/action"|ezurl}>
                    <input type="hidden" name="ClassIdentifier" value="article" />
                    <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                    <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                    <input class="button new_comment" type="submit" name="NewButton" value="New post" />
                    </form>
                    
                    <form method="post" action={"content/action"|ezurl}>
                        <input type="hidden" name="ClassIdentifier" value="folder" />
                        <input type="hidden" name="NodeID" value="{$node.object.main_node.node_id}" />
                        <input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
                        <input class="button new_comment" type="submit" name="NewButton" value="New page" />
                        </form>
                    
                    <br />
    {/if}
                
	{* Folder - Full view *}
{def $rss_export = fetch( 'rss', 'export_by_node', hash( 'node_id', $node.node_id ) )}
        
            {def $page_limit = 10
                 $classes = ezini( 'MenuContentSettings', 'ExtraIdentifierList', 'menu.ini' )
                 $children = array()
                 $children_count = ''}
                 
            {if le( $node.depth, '3')}
                {set $classes = $classes|merge( ezini( 'ChildrenNodeList', 'ExcludedClasses', 'content.ini' ) )}
            {/if}

            {set $children_count=fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id,
                                                                      'class_filter_type', 'exclude',
                                                                      'class_filter_array', $classes ) )}
            <div class="content-view-children">
                {if $children_count}
                    {foreach fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
                                                            'offset', $view_parameters.offset,
                                                            'sort_by', $node.sort_array,
                                                            'class_filter_type', 'exclude',
                                                            'class_filter_array', $classes,
                                                            'limit', $page_limit ) ) as $child }
                        {node_view_gui view='line' content_node=$child}
                    {/foreach}
                {/if}
            </div>

            {include name=navigator
                     uri='design:navigator/google.tpl'
                     page_uri=$node.url_alias
                     item_count=$children_count
                     view_parameters=$view_parameters
                     item_limit=$page_limit}

        
</div>
<div id="right">
    <div id="right-toolbar">
    	<div class="tool">        	
            {* Event Calendar - Line view *}

            <div class="content-view-line">
                <div class="class-event-calendar">
                <h3><a href={$node.url_alias|ezurl}>{$node.object.data_map.title.content|wash()}</a></h3>
                {def     $event_ts=currentdate()
                         $list_data=fetch( 'content', 'tree', hash( 
                            'parent_node_id', 228,
                            'class_filter_type', 'include',
                            'attribute_filter',    array( array( 'event/to_time', '>=', $event_ts )),
                            'class_filter_type', 'include',
                            'class_filter_array', array('event'),
                            'sort_by', array( 'attribute', true(), 'event/from_time' ),
                            'ignore_visibility', true(),
                            'limit',  3 ) )}
            
                {if gt(count($list_data),0)}
                <div class="content-view-children">
                <h3>Next events</h3>
                    {foreach $list_data as $event}
                    {if or( eq($event.object.data_map.to_time.content.timestamp|datetime( custom, '%j%m'), $event_ts|datetime( custom, '%j%m')),
                            eq($event.object.data_map.from_time.content.timestamp|datetime( custom, '%j%m'), $event_ts|datetime( custom, '%j%m')),
                            and(lt($event.object.data_map.from_time.content.timestamp, $event_ts),
                                gt($event.object.data_map.to_time.content.timestamp, $event_ts))
                 )}
                    <p class="ezagenda_today">
                    {else}
                    <p>
                    {/if}
                    <span class="ezagenda_date">{$event.object.data_map.from_time.content.timestamp|datetime(custom,"%d %M")}</span>
                    <a href={$event.url_alias|ezurl}>{$event.name|wash()}</a>
                    </p>
                    {/foreach}
                </div>
                {/if}
            {undef $list_data $event_ts}
              	</div>
            </div>
        </div>
        <br />
        <br />
        <div class="tool">
        	
            <h3>Subscribe to this page</h3>
            <div class="notificaton">
            {def $notification_access=fetch( 'user', 'has_access_to', hash( 'module', 'notification', 'function', 'addtonotification' ) )}            
                {if $notification_access }
			<div class="notification">
        	<form method="post" action={'/content/action'|ezurl}>
				<input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
				<input type="submit" name="ActionAddToNotification" value="Keep me updated" />
			</form>
        	</div>
            <br />
            <br />
        	<h3>Invitations</h3>
            <div class="invitations">
            	<p>Prosjektgruppe 4 <a href="#">Bekreft</a> | <a href="#">Avslå</a></p>
                <p>Planlegging kick-off <a href="#">Bekreft</a> | <a href="#">Avslå</a></p>
            </div>
        </div>        	
    </div>
</div>
